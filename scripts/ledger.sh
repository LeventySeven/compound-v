#!/usr/bin/env bash
# ledger.sh — compute completion from .claude/slices.json. Never assert it.
#
# The rule this enforces (compound-v:get-shit-done, references/completion-ledger.md):
#   every declared row is `passed` or `dropped`-with-attribution; nothing may remain
#   `todo` or `building` at the verdict, and `blocked` is not success.
#
# Exit 0 = the run may claim done. Exit 1 = rows are still open. Exit 2 = cannot tell.
# That distinction is the whole point, and exit 2 is the one that matters most: a ledger this
# cannot read honestly must never resolve toward "done". An adversarial recheck reproduced the
# opposite — one typo'd status (`done` for `passed`) dropped a row out of every bucket and this
# printed 93% and exited 0 on unfinished work. Validation now lives in ledger-extract.jq,
# shared with hooks/stop-ledger so the two halves cannot certify a run in disagreement.
#
#   bash scripts/ledger.sh              # the scope-delta line
#   bash scripts/ledger.sh --open       # + every row not closed, with its slice
#   bash scripts/ledger.sh --discharge  # can this ledger be deleted yet? (the landing gate)
#   bash scripts/ledger.sh --path P     # a ledger somewhere other than .claude/slices.json
#
# Proven by: bash scripts/hooks-test.sh

set -uo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
extract="$here/ledger-extract.jq"
ledger=".claude/slices.json"
show_open=0
discharge=0
while [ $# -gt 0 ]; do
  case "$1" in
    --open) show_open=1; shift ;;
    --discharge) discharge=1; shift ;;
    --path)
      # A bare `--path` with nothing after it used to shift past the end and then read the
      # ledger from stdin, which hangs forever. Fail loudly instead.
      [ $# -ge 2 ] && [ -n "${2:-}" ] || { printf 'ledger.sh: --path needs a value\n' >&2; exit 2; }
      ledger="$2"; shift 2 ;;
    -h|--help) sed -n '2,18p' "$0"; exit 0 ;;
    *) printf 'ledger.sh: unknown argument %s\n' "$1" >&2; exit 2 ;;
  esac
done

[ -f "$ledger" ] || { printf 'no ledger at %s — nothing to measure\n' "$ledger"; exit 2; }
command -v jq >/dev/null 2>&1 || { printf 'jq not found — cannot compute coverage\n' >&2; exit 2; }
[ -r "$extract" ] || { printf 'missing %s — cannot validate the ledger\n' "$extract" >&2; exit 2; }

report="$(jq -c -f "$extract" "$ledger" 2>/dev/null)"
[ -n "$report" ] || { printf 'could not parse %s as JSON — refusing to report a number\n' "$ledger" >&2; exit 2; }

if [ "$(printf '%s' "$report" | jq -r 'try .ok catch "false"')" != "true" ]; then
  printf 'ledger does not validate: %s\n' "$(printf '%s' "$report" | jq -r '.why')" >&2
  printf 'refusing to report completion — an unreadable row counts as open, never as done\n' >&2
  exit 2
fi

eval "$(printf '%s' "$report" | jq -r '.counts
  | "n_open=\(.open) n_passed=\(.passed) n_dropped=\(.dropped) n_blocked=\(.blocked)",
    "n_decl=\(.declared) n_disc=\(.discovered) n_total=\(.total)"')"

closed=$(( n_passed + n_dropped ))
pct=0; [ "$n_total" -gt 0 ] && pct=$(( closed * 100 / n_total ))

printf 'declared %s · discovered +%s · dropped −%s · passed %s · blocked %s · open %s  →  %s%%\n' \
  "$n_decl" "$n_disc" "$n_dropped" "$n_passed" "$n_blocked" "$n_open" "$pct"

# A dropped row with no reason is the failure the attribution rule exists to stop: it is
# indistinguishable from a row someone quietly deleted.
unattributed="$(printf '%s' "$report" | jq -r '[.rows[] | select(.status == "dropped")
  | select(((.dropped_by // "") | tostring | ltrimstr(" ") | length) == 0
        or ((.dropped_why // "") | tostring | ltrimstr(" ") | length) == 0)
  | .id // "?"] | join(", ")')"
[ -n "$unattributed" ] && printf 'dropped without attribution (who + why): %s\n' "$unattributed"

if [ "$show_open" -eq 1 ] && [ $(( n_open + n_blocked )) -gt 0 ]; then
  printf '\n'
  printf '%s' "$report" | jq -r '.rows[]
    | select(.status == "todo" or .status == "building" or .status == "blocked")
    | "  [\(.status)] \(.id // "?") — \(.does // .capability // "(no description)")"'
fi

# --discharge: the landing gate. A row's `status` is run-scoped and reads `passed` forever the day
# after the merge, so keeping the ledger as a live document makes a stale claim an agent will trust
# as fact — but its `steps` and `evidence.how` are a regression contract the run already paid to
# write. Deleting is right; deleting UNDISCHARGED is the bug. Every passed row must first name a
# durable target that outlives the file: a command someone can re-run, a production observable and
# the query that reads it, or a named human and the check they own.
if [ "$discharge" -eq 1 ]; then
  undischarged="$(printf '%s' "$report" | jq -r '[.rows[] | select(.status == "passed")
    | select((.discharge // {}) as $d
        | (($d.rerun // "") | tostring | length) == 0
          and ((($d.observable // "") | tostring | length) == 0 or (($d.query // "") | tostring | length) == 0)
          and ((($d.owner // "") | tostring | length) == 0 or (($d.check // "") | tostring | length) == 0))
    | "  " + (.id // "?") + " — " + (.does // "(no description)")] | join("\n")')"
  if [ -n "$undischarged" ]; then
    printf '\nnot dischargeable — %s passed row(s) name no durable target:\n%s\n' \
      "$(printf '%s\n' "$undischarged" | grep -c '^')" "$undischarged"
    printf 'each needs one of: discharge.rerun (a command), discharge.observable + .query, or discharge.owner + .check\n'
    exit 1
  fi
  if [ "$n_open" -gt 0 ] || [ "$n_blocked" -gt 0 ] || [ -n "$unattributed" ]; then
    printf '\nnot dischargeable — the run is not finished yet\n'; exit 1
  fi
  printf '\ndischargeable: every passed row names a durable target; the ledger may be deleted in the landing commit\n'
  exit 0
fi

[ "$n_open" -gt 0 ] && exit 1
[ -n "$unattributed" ] && exit 1
if [ "$n_blocked" -gt 0 ]; then
  printf 'no open rows, but %s blocked — blocked is not success; it counts against completion\n' "$n_blocked"
  exit 1
fi
exit 0
