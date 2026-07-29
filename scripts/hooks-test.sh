#!/usr/bin/env bash
# hooks-test.sh — prove the Stop gate blocks the one thing it claims to and nothing else.
#
# A Stop hook runs on every turn in every repo the plugin is installed in, so a false block
# costs a wasted turn and the user's trust in the whole kit. Each case below pins one guard;
# the ALLOW cases are the important half — three of them exist because the trigger as
# originally specified fired on the exact opposite of a completion claim.
#
# Pure bash: synthetic transcripts under scripts/fixtures/stop/, a synthetic hook-input JSON
# piped to the hook. No CLI, no network, no API — unlike trigger-eval.sh, this runs anywhere.
#
#   bash scripts/hooks-test.sh
#
# Exit 0 = every case behaved. Exit 1 = at least one miss.

set -uo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$root" || exit 2

command -v jq >/dev/null 2>&1 || { echo "jq not found — the gate no-ops without it, and so does this test"; exit 2; }

hook="hooks/stop-verify"
fx="scripts/fixtures/stop"
pass=0; miss=0
declare -a failures=()

# run <name> <expect: BLOCK|ALLOW> <transcript-or-path> [extra-input-jq-args...]
run() {
  local name="$1" expect="$2" tpath="$3"; shift 3
  local in out got
  in="$(jq -n --arg t "$tpath" --arg c "$root" "$@" \
        '{hook_event_name: "Stop", session_id: "test", transcript_path: $t, cwd: $c,
          stop_hook_active: ($ARGS.named.active // false)}')"
  out="$(printf '%s' "$in" | bash "$hook" 2>/dev/null)"; local rc=$?
  got="ALLOW"
  [ "$(printf '%s' "$out" | jq -r 'try .decision catch ""' 2>/dev/null)" = "block" ] && got="BLOCK"
  # A non-zero exit from a Stop hook is itself a failure mode: exit 2 blocks with no reason,
  # and anything else surfaces as a hook error. The gate must always exit 0.
  if [ "$rc" -ne 0 ]; then
    miss=$((miss + 1)); failures+=("$name — exited $rc (must always exit 0)")
    printf '%-42s %-6s MISS exit %s\n' "$name" "$expect" "$rc"; return
  fi
  if [ "$got" = "$expect" ]; then
    pass=$((pass + 1)); printf '%-42s %-6s ok\n' "$name" "$expect"
  else
    miss=$((miss + 1)); failures+=("$name — expected $expect, got $got")
    printf '%-42s %-6s MISS got %s\n' "$name" "$expect" "$got"
  fi
}

printf '%-42s %-6s %s\n' "CASE" "EXPECT" "RESULT"
printf '%.0s-' {1..64}; printf '\n'

# The one failure the gate exists to catch.
run "claim + edits + no command"            BLOCK "$fx/block-claim-no-command.jsonl"
# Turn scoping: last turn's command does not pay for this turn's claim.
run "bash in a PREVIOUS turn only"          BLOCK "$fx/block-bash-in-previous-turn.jsonl"

# Convergence. The same blocking transcript must pass once the harness says it already
# blocked — this is what caps the gate at one block per turn so a session can always end.
run "stop_hook_active on a blocking turn"   ALLOW "$fx/block-claim-no-command.jsonl" --argjson active true

# Everything the gate must NOT block.
run "a command actually ran"                ALLOW "$fx/allow-command-ran.jsonl"
run "\"still working on it\""               ALLOW "$fx/allow-still-working.jsonl"
run "russian \"not working yet\""            ALLOW "$fx/allow-ru-negation.jsonl"
run "suite, then a trailing edit"           ALLOW "$fx/allow-suite-then-trailing-edit.jsonl"
run "no edits in the turn"                  ALLOW "$fx/allow-no-edits.jsonl"
run "edits but no completion claim"         ALLOW "$fx/allow-no-claim.jsonl"
run "conditional \"done once you...\""      ALLOW "$fx/allow-conditional-claim.jsonl"

# Fail-open. A gate that crashes must let the turn end, never wedge it.
run "transcript path does not exist"        ALLOW "$fx/no-such-file.jsonl"

# The kill switch needs the env var, so it is run explicitly rather than through run().
if [ -n "$(COMPOUND_V_STOP_GATE=off bash "$hook" \
      < <(jq -n --arg t "$fx/block-claim-no-command.jsonl" \
          '{hook_event_name:"Stop",transcript_path:$t,stop_hook_active:false}') 2>/dev/null)" ]; then
  miss=$((miss + 1)); failures+=("kill switch — still emitted a decision")
  printf '%-42s %-6s MISS emitted a decision\n' "kill switch (env)" "ALLOW"
else
  pass=$((pass + 1)); printf '%-42s %-6s ok\n' "kill switch (env)" "ALLOW"
fi

# Malformed stdin must not produce a block or a non-zero exit.
out="$(printf 'not json at all' | bash "$hook" 2>/dev/null)"; rc=$?
if [ "$rc" -eq 0 ] && [ -z "$out" ]; then
  pass=$((pass + 1)); printf '%-42s %-6s ok\n' "malformed stdin" "ALLOW"
else
  miss=$((miss + 1)); failures+=("malformed stdin — exit $rc, output '$out'")
  printf '%-42s %-6s MISS exit %s\n' "malformed stdin" "ALLOW" "$rc"
fi

# The block must name a command to run, or it is a wall rather than a gate.
reason="$(jq -n --arg t "$fx/block-claim-no-command.jsonl" --arg c "$root" \
          '{hook_event_name:"Stop",transcript_path:$t,cwd:$c,stop_hook_active:false}' \
          | bash "$hook" 2>/dev/null | jq -r 'try .reason catch ""')"
case "$reason" in
  *'bash scripts/check.sh'*) pass=$((pass + 1)); printf '%-42s %-6s ok\n' "block names a concrete command" "REASON" ;;
  *) miss=$((miss + 1)); failures+=("block reason did not name this repo's command: '$reason'")
     printf '%-42s %-6s MISS\n' "block names a concrete command" "REASON" ;;
esac

# The manifest is what actually wires the gate up; a valid-JSON check is not enough.
keys="$(jq -r '.hooks | keys_unsorted | join(",")' hooks/hooks.json 2>/dev/null)"
if [ "$(jq -r '.hooks.Stop[0].hooks[0].command' hooks/hooks.json 2>/dev/null)" = '"${CLAUDE_PLUGIN_ROOT}/hooks/stop-verify"' ]; then
  pass=$((pass + 1)); printf '%-42s %-6s ok  (%s)\n' "hooks.json registers Stop" "WIRED" "$keys"
else
  miss=$((miss + 1)); failures+=("hooks.json does not register hooks/stop-verify under Stop")
  printf '%-42s %-6s MISS (%s)\n' "hooks.json registers Stop" "WIRED" "$keys"
fi

for h in hooks/session-start hooks/user-prompt-submit hooks/stop-verify; do
  if [ -x "$h" ]; then pass=$((pass + 1)); printf '%-42s %-6s ok\n' "$h is executable" "MODE"
  else miss=$((miss + 1)); failures+=("$h is not executable — the harness cannot run it")
       printf '%-42s %-6s MISS\n' "$h is executable" "MODE"; fi
done

printf '\n%s/%s cases behaved\n' "$pass" "$((pass + miss))"
if [ "${#failures[@]}" -gt 0 ]; then
  printf '\nMisses:\n'; printf '  %s\n' "${failures[@]}"
fi
[ "$miss" -eq 0 ]
