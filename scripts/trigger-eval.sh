#!/usr/bin/env bash
# trigger-eval.sh — measure whether Compound V skills actually FIRE.
#
# The kit's whole claim is that every line changes what the agent does. A skill that
# never gets invoked changes nothing, and it fails silently: a description that the
# harness truncated is indistinguishable from one that simply didn't match. This is the
# instrument that turns "does this line earn its keep?" from taste into a number.
#
# It drives the real CLI on your existing session auth (no API key, no SDK) and reports
# which skill each realistic prompt actually invoked.
#
#   bash scripts/trigger-eval.sh                 # every fixture
#   bash scripts/trigger-eval.sh recheck         # only rows expecting recheck
#   REPS=3 bash scripts/trigger-eval.sh          # 3 reps/row; variance IS the signal
#
# Exit 0 = every case hit. Exit 1 = at least one miss.
#
# Honest limits, so nobody over-reads the number:
#   - It measures ROUTING (did the right skill fire), never OUTPUT QUALITY.
#   - Each run is one cold turn. It cannot see decay over a long session, which is a
#     real and separate failure mode.
#   - Fixtures are hand-written, so they measure the kit against our guess at how users
#     talk. Rewrite a row the moment a real user phrases it differently.

set -uo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$root" || exit 2

command -v claude >/dev/null || { echo "claude CLI not found on PATH"; exit 2; }

fixtures="scripts/trigger-fixtures.tsv"
filter="${1:-}"
REPS="${REPS:-1}"
CASE_TIMEOUT="${CASE_TIMEOUT:-300}"
pass=0; miss=0
declare -a failures=()

# Everything that could write, spend, schedule, or spawn. Skill stays reachable; nothing
# else that matters does. Denied here rather than merely left off an allow-list, because
# a non-interactive run has nobody to refuse a permission prompt.
DENY='{"permissions":{"deny":["Bash","Edit","Write","NotebookEdit","Task","Agent","WebFetch","WebSearch","TaskCreate","TaskUpdate","TaskStop","CronCreate","CronDelete","RemoteTrigger","ScheduleWakeup","PushNotification","DesignSync","EnterWorktree","ExitWorktree","Workflow","SendMessage","Monitor","Artifact"]}}'

command -v timeout >/dev/null || { echo "GNU 'timeout' not found (brew install coreutils)"; exit 2; }

printf '%-52s %-26s %s\n' "PROMPT" "EXPECTED" "FIRED"
printf '%.0s-' {1..110}; printf '\n'

while IFS=$'\t' read -r prompt expected; do
  case "$prompt" in ''|'#'*) continue ;; esac
  [ -n "$filter" ] && [[ "$expected" != *"$filter"* ]] && continue

  for _ in $(seq 1 "$REPS"); do
    # Deny by settings, not by --allowed-tools: that flag is an AUTO-APPROVE list, not a
    # restriction, so naming Skill there does not take anything away. The deny list is
    # what actually stops a fixture mutating the repo or firing something consequential.
    # `timeout` bounds the case — the CLI has no turn cap, so a confused run is otherwise
    # unbounded.
    raw="$(timeout "$CASE_TIMEOUT" claude -p "$prompt" \
            --output-format stream-json --verbose \
            --settings "$DENY" \
            --disallowed-tools 'Bash Edit Write Read Grep Glob Agent Task WebFetch WebSearch NotebookEdit' \
            2>/dev/null)"; rc=$?

    # A failed run must never score as a pass. Empty output with expected=NONE would
    # otherwise look identical to "ran fine and correctly routed nowhere" — that is the
    # green-because-nothing-ran failure, and it is the one that survives longest.
    if [ "$rc" -ne 0 ] || [ -z "$raw" ]; then
      miss=$((miss + 1))
      failures+=("$expected — RUN FAILED (exit $rc) — \"$prompt\"")
      printf '%-52.52s %-26.26s ERR  run failed (exit %s)\n' "$prompt" "$expected" "$rc"
      continue
    fi

    # Every Skill invocation in the turn, deduped, in order.
    fired="$(printf '%s' "$raw" \
      | grep -oE '"name":"Skill","input":\{"skill":"[^"]+"' \
      | sed -e 's/.*"skill":"//' -e 's/"$//' -e 's/^compound-v://' \
      | awk '!seen[$0]++' | paste -sd, -)"
    [ -z "$fired" ] && fired="NONE"

    # Hit = the expected skill is among those fired. For expected=NONE, hit = nothing
    # fired: over-triggering on a trivial ask is exactly as wrong as under-triggering.
    hit=0
    if [ "$expected" = "NONE" ]; then
      [ "$fired" = "NONE" ] && hit=1
    else
      IFS=',' read -ra want <<< "$expected"
      for w in "${want[@]}"; do
        case ",$fired," in *",$w,"*) hit=1 ;; esac
      done
    fi

    if [ "$hit" -eq 1 ]; then
      pass=$((pass + 1)); mark="ok  "
    else
      miss=$((miss + 1)); mark="MISS"
      failures+=("$expected — got '$fired' — \"$prompt\"")
    fi
    printf '%-52.52s %-26.26s %s %s\n' "$prompt" "$expected" "$mark" "$fired"
  done
done < "$fixtures"

total=$((pass + miss))
printf '\n%s/%s fired correctly' "$pass" "$total"
[ "$total" -gt 0 ] && printf ' (%s%%)' "$((pass * 100 / total))"
printf '\n'

if [ "${#failures[@]}" -gt 0 ]; then
  printf '\nMisses — each one is either a description that needs a trigger phrase or a\nfixture that needs rewriting. Decide which before editing anything:\n'
  printf '  %s\n' "${failures[@]}"
fi

[ "$miss" -eq 0 ]
