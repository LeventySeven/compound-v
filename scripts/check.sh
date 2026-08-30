#!/usr/bin/env bash
# check.sh — verify Compound V against its own constitution and publish boundary.
# No dependencies. Run from anywhere:  bash scripts/check.sh
# Exit 0 = clean, 1 = at least one failure.

set -uo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$root" || exit 2

fail=0
warn=0
err()  { printf 'FAIL  %s\n' "$1"; fail=$((fail + 1)); }
note() { printf 'warn  %s\n' "$1"; warn=$((warn + 1)); }

# 1. Frontmatter, name matches directory, description present, line budget.
#    Constitution: target <=250 lines, hard ceiling 500.
for f in skills/*/SKILL.md; do
  d="$(basename "$(dirname "$f")")"
  head -1 "$f" | grep -q '^---' || err "$f: missing frontmatter opener"
  name="$(awk -F': *' '/^name:/{print $2; exit}' "$f")"
  [ "$name" = "$d" ] || err "$f: name '$name' does not match directory '$d'"
  awk '/^description:/{ok=1} END{exit !ok}' "$f" || err "$f: no description"
  n="$(wc -l < "$f")"
  if   [ "$n" -gt 500 ]; then err  "$f: $n lines (over the 500 hard ceiling)"
  elif [ "$n" -gt 250 ]; then note "$f: $n lines (over the 250 target)"
  fi
  # Words, not lines, are the real budget: a body can double in size with the line count
  # flat just by merging paragraphs, so a line check alone silently stops bounding
  # anything. Compaction re-attaches only the first ~5,000 TOKENS of a skill (~3,750
  # words) — past that, the tail of the file stops existing exactly when context is
  # tightest, so anything below the line has to be expendable.
  w="$(wc -w < "$f")"
  if   [ "$w" -gt 5000 ]; then err  "$f: $w words (over the 5000 hard ceiling)"
  elif [ "$w" -gt 3750 ]; then note "$f: $w words (past the ~5000-token compaction head — the tail may not survive)"
  fi
done

# 2. Publish boundary: shipped files must never name the internal research corpus.
#    (scripts/ is excluded on purpose — this file holds the pattern itself.)
#    `~/…` counts as an absolute path too: a tilde form once carried a private repo name
#    through this gate untouched, because only the /Users/ spelling was matched.
leak="$(grep -rnoE 'BAD_GUIDE|researchfms|guidesfm|teardowns|skills_research|AGENTIC_SEARCH|research/(findings|SYNTH|sources)|/Users/[a-z]|~/(Desktop|Users|Documents|src|repos|code)/' \
  skills/ agents/ hooks/ references/ README.md .claude-plugin/ 2>/dev/null || true)"
if [ -n "$leak" ]; then
  err "internal-corpus references in shipped files (these must never publish):"
  printf '%s\n' "$leak" | sed 's/^/        /'
fi

# 3. Cross-reference integrity: every compound-v:<name> resolves to a real skill.
for r in $(grep -rhoE 'compound-v:[a-z][a-z-]+' skills/ agents/ hooks/ README.md 2>/dev/null | sed 's/compound-v://' | sort -u); do
  [ -d "skills/$r" ] || err "dangling cross-reference: compound-v:$r (no skills/$r)"
done

# 4. No @path skill links (they force-load and burn context).
if grep -rnE '@[a-z][a-z-]*/SKILL|@compound-v' skills/ >/dev/null 2>&1; then
  err "@path skill link found (use 'compound-v:<name>' by name instead):"
  grep -rnE '@[a-z][a-z-]*/SKILL|@compound-v' skills/ | sed 's/^/        /'
fi

# 5. Frontmatter keys must be in the allowed set (any other key fails harness validation).
for f in skills/*/SKILL.md; do
  awk 'NR==1&&/^---/{p=1;next} p&&/^---/{exit} p&&/^[a-zA-Z][a-zA-Z0-9_-]*:/{sub(/:.*/,"");print}' "$f" \
  | while read -r k; do
      case "$k" in
        name|description|when_to_use|disable-model-invocation|user-invocable|allowed-tools|license|metadata) ;;
        *) printf 'FAIL  %s: unknown frontmatter key "%s"\n' "$f" "$k" ;;
      esac
    done
done
unknown="$(for f in skills/*/SKILL.md; do
  awk 'NR==1&&/^---/{p=1;next} p&&/^---/{exit} p&&/^[a-zA-Z][a-zA-Z0-9_-]*:/{sub(/:.*/,"");print}' "$f"
done | sort -u | grep -vE '^(name|description|when_to_use|disable-model-invocation|user-invocable|allowed-tools|license|metadata)$' || true)"
[ -n "$unknown" ] && fail=$((fail + 1))

# 6. Description budget. Descriptions are ALWAYS loaded and share a listing budget across every
#    skill in the session; when it overflows, the harness SHORTENS descriptions — silently killing
#    the trigger phrases that sit at the tail. Per-entry hard cap is 1024 chars.
desc_total=0
for f in skills/*/SKILL.md; do
  d="$(awk '/^description:/{sub(/^description: */,""); print; exit}' "$f")"
  n=${#d}
  desc_total=$((desc_total + n))
  [ "$n" -gt 1024 ] && err "$f: description $n chars (over the 1024 hard cap — it will be truncated)"
done
printf 'always-on description cost: %s chars (~%s tokens) across all skills\n' \
  "$desc_total" "$((desc_total / 4))"
[ "$desc_total" -gt 14000 ] && note "description budget $desc_total chars — trim or merge skills; the listing is shortened when it overflows"

# 7. Agents must not pin a worker's model. `recheck` states the rule: "do not set a `model`
#    parameter when you dispatch it; a pin can silently downgrade the worker, and the clean
#    context is what buys the catch, not a model tier." An agent file is a dispatch spec, so
#    a `model:` key there is that same pin, written down.
for f in agents/*.md; do
  [ -e "$f" ] || continue
  if awk 'NR==1&&/^---/{p=1;next} p&&/^---/{exit} p&&/^model:/{found=1} END{exit !found}' "$f"; then
    err "$f: pins a model in frontmatter — workers inherit the session model (see skills/recheck/SKILL.md)"
  fi
done

# 8. Ledger anchors must still be greppable in the file they point at.
#    An anchor names either a skill (`recheck`) or a reference (`references/prior-art.md`). Both are
#    resolved and checked; a target that resolves to neither is reported rather than skipped, because
#    a silently-skipped anchor is an unchecked claim that looks checked.
#    references/sources.md states the contract itself: the Anchor phrase is "text that appears
#    verbatim in the current skill body and can be grepped for". Anchors rot silently whenever a
#    skill is reworded, and a rotted anchor breaks the "read its row first" lookup several skills
#    promise their reader. Case- and emphasis-insensitive so markdown edits don't cause noise.
#    WARNING, not failure: anchors in the older ledger sections have already drifted; hardening
#    this to err() is a follow-up that has to re-sync those rows first.
#    A markdown table cell cannot contain a literal '|', so '|' is a safe field separator here.
norm_md() { tr -d '*_`' | tr '[:upper:]' '[:lower:]' | tr '\n' ' ' | tr -s ' '; }
anchor_pairs="$(mktemp)"; anchor_rot="$(mktemp)"
trap 'rm -f "$anchor_pairs" "$anchor_rot"' EXIT
grep -ohE '`(references/)?[a-z][a-z0-9-]+(\.md)?` *(→|->) *"[^"]+"' references/sources.md 2>/dev/null \
  | sed -E 's/^`((references\/)?[a-z0-9-]+(\.md)?)` *(→|->) *"(.*)"$/\1|\5/' | sort -u > "$anchor_pairs"
anchor_last=''
anchor_body=''
while IFS='|' read -r sk phrase; do
  [ -n "${sk:-}" ] || continue
  case "$sk" in
    references/*) anchor_file="$sk" ;;
    *)            anchor_file="skills/$sk/SKILL.md" ;;
  esac
  [ -f "$anchor_file" ] || continue
  if [ "$sk" != "$anchor_last" ]; then
    anchor_body="$(norm_md < "$anchor_file")"
    anchor_last="$sk"
  fi
  needle="$(printf '%s' "$phrase" | norm_md)"
  case "$anchor_body" in
    *"$needle"*) ;;
    *) printf '%s → "%s"\n' "$sk" "$phrase" >> "$anchor_rot" ;;
  esac
done < "$anchor_pairs"
if [ -s "$anchor_rot" ]; then
  note "$(wc -l < "$anchor_rot" | tr -d ' ') ledger anchor(s) no longer appear in the file they point at:"
  sed 's/^/        /' "$anchor_rot"
fi

skills_n="$(find skills -maxdepth 1 -mindepth 1 -type d | wc -l | tr -d ' ')"
printf '\n%s skills checked — %s failure(s), %s warning(s)\n' "$skills_n" "$fail" "$warn"
[ "$fail" -eq 0 ]
