---
name: verification-before-completion
description: Run the command that proves a claim and read its output before asserting the work is done, fixed, or passing. Use whenever you're about to say something works, claim a fix or feature is complete, report tests/build green, or trust that a subagent finished — evidence before assertions, always.
---

# Verification Before Completion

**Verification means proving the code works, not confirming it exists.** If you haven't run the verifying command *in this turn*, you can't claim it passed. "Should pass," "looks right," and "I fixed it" are predictions, not evidence — and the cheapest way to break a user's trust is to confidently report a green that was actually red. The same holds for every report you *receive*: a worker's summary describes what it intended to do, not necessarily what it did. This is one half of the generation–verification loop — the model generates, then something *verifies*, and that evidence at the end is the whole leash that lets work proceed without re-reading every line. When the verifier fails, feed its output *back into context* and act on it — the failure message is the next input to reason from, not a wall you read once and re-guess past.

## The gate (run before any completion claim)

1. **Identify** the command whose output would actually prove the claim.
2. **Run** it fresh and in full — not a remembered result from earlier, not a subset.
3. **Read** the full output: the summary line, the exit code, the failure count.
4. **Confirm** the output actually says what you're about to claim.
5. **Then** make the claim — quoting the evidence, not paraphrasing your hope.

Skipping any step is asserting something you haven't checked. **Step 1 always resolves to a command that observes *behavior*** — a test, a build, a lint, a request, the feature actually used. Re-reading the file you just wrote is not verification and not a step: Edit/Write would have errored if the write had failed, and the file's contents were never the claim.

**Read the value out of the artifact, not out of the sentence describing it.** Running the command is half the gate; reading its result is the other half, and the two can disagree silently. An agent that genuinely ran the code can still describe the result wrongly in prose — the printed variable says one thing, the summary sentence says something ~10,000× different, and asking "did you run it?" returns an honest yes that is still wrong. So take every claimed value from the artifact itself: the printed output, the file on disk, the response body, the exit code. **If the claim is a number, that number must appear in output you actually looked at** — a figure you can't point at in an artifact is a figure you invented, however real the run behind it was.

**No command proves it yet? Build the observation channel before you claim — don't skip the gate.** The reason agents confidently ship broken work is an *observation* gap, not an action gap: the files were written, the tool returned no error, but the result was never sensed. When step 1 has no answer, add the missing sense — a screenshot, an assertion, a structured-output check — then run *that*; a claim with no way to observe the outcome is a guess wearing a checkmark. Closing that loop (a browser-screenshot channel for a UI the agent can't otherwise see) is one of the biggest unlocks for autonomous task length. **For user-visible or hard-to-unsend output the channel is a preview into a safe sink, rendered before the prod-facing send** — a UI surface, a bot message, a channel post, a generated artifact: a typecheck and a green unit suite prove the code runs, *not* that the thing looks right to a human, and once it's sent you can't take it back. Route it to a dry-run / staging / test sink first (a test channel, a preview screenshot, a `--dry-run` render, a draft) and *look at it*, or have a human look. The cost of the preview is seconds; the cost of the un-sendable mistake is a user seeing it.

## What each claim actually requires

| Claim | Requires (evidence) | Not sufficient |
| --- | --- | --- |
| "Tests pass" | Ran the suite this turn; output shows **0 failures** + exit 0 | "Should pass" · the tests passed before your last edit · only one test ran |
| "Build / typecheck is clean" | Ran the build/typecheck; **exit 0** | The linter passed · it compiled an hour ago · no red in the editor |
| "The bug is fixed" | A test reproducing the **original symptom** now passes — and *would fail without the fix* (revert the fix, watch the test go red, restore it) | The code looks right · a green test you never saw fail — running it once green doesn't prove it would have caught the bug |
| "Feature is complete" | Each requirement checked off against the spec, line by line | "I implemented the main part" · it handles the happy path |
| "It runs" | Actually started it and used the real flow end-to-end (booted the server, ran the CLI, clicked the UI path) | The unit tests are green — passing tests don't prove the app boots |
| "The subagent finished it" | **You read the VCS diff yourself** and ran the suite | The agent reported success · its summary says DONE |

That last row is the one that bites most: a subagent (or a prior you) reporting success is a *claim*, not proof. Run `git diff` and read what actually changed, then run the tests yourself. Agents make systematic errors and optimistic summaries — trust the diff, not the report. **When the claim comes from a subagent you dispatched, read its `toolStats` counters, not just its prose**: `{readCount, searchCount, bashCount, editFileCount, linesAdded, linesRemoved}` comes back with the result, and a `DONE` sitting next to `editFileCount: 0` or `linesAdded: 0` means no work happened, however confident the summary sounds.

**Verify the goal you were given, not a smaller one you can pass.** Do not substitute a narrower, safer, merely-compatible, or easier-to-test solution because it is more likely to clear the check — quietly shrinking the target until the evidence fits is the sophisticated version of a false "done." And **treat indirect evidence as not-achieved**: a proxy that merely correlates with the goal (it compiles, the mock returns, an adjacent test is green) is not the goal being met. A fully green suite is also weaker evidence than it feels: passing every test does not mean the program is correct, only that no test caught it — tests are a necessary filter, never a sufficient proof, and the interesting bugs live in exactly that gap.

## Red flags — stop before you type the claim

- You're about to type "Perfect!", "Done!", "All green!" — or reaching for "should," "probably," "seems to," "I believe it." Celebration and hedging both mean you haven't run anything this turn; go run the command.
- **Your last paragraph is a promise, not a result** — it describes what *will* happen ("this should now handle the empty case") instead of what did ("`pytest -q` → 214 passed"). A completion report written in the future tense is an admission you never checked.
- You're trusting a test run, build, or agent report from *before* your most recent change. Stale evidence is not evidence — the change may have broken it.
- "It's a tiny change, no need to verify." Tiny changes break builds too. The check is cheap; run it.
- **You're running low on context and suddenly everything is done.** Agents shorten scope and declare victory when they believe they're near the end of the window — routinely while plenty of room remains. A late-session "done" is the highest-risk claim you make, and the bias runs toward under-delivery. Remaining budget is not evidence about the work: never compress the goal to fit it, and if you are genuinely out of room, say what remains instead of redefining done.
- You piped the verifier to `tail`, `tee`, or `grep` and read "exit 0" off the *pipeline* — that's the last stage's exit code, not the tool's (`cargo clippy | tail` reports green while hiding clippy's errors). Use `set -o pipefail`, or read `${PIPESTATUS[0]}` — the command's own status, not the pipe's.

When the gate passes, state the evidence: "Ran `pytest`: 142 passed, 0 failed (exit 0)." That sentence is worth more than any amount of "looks good." If a verification reveals a failure you don't understand, that's a debugging task — use **compound-v:systematic-debugging**.
