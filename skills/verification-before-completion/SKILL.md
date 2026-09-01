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

A Stop hook ships with this kit as the mechanical floor under the gate: it refuses a completion claim when the turn edited files and ran nothing at all. It is a floor, not the gate — it cannot tell whether the command you ran proved anything, so the steps above remain the contract.

Skipping any step is asserting something you haven't checked. **Step 1 always resolves to a command that observes *behavior*** — a test, a build, a lint, a request, the feature actually used. Re-reading the file you just wrote is not verification and not a step: Edit/Write would have errored if the write had failed, and the file's contents were never the claim.

**Read the value out of the artifact, not out of the sentence describing it.** Running the command is half the gate; reading its result is the other half, and the two can disagree silently. An agent that genuinely ran the code can still describe the result wrongly in prose — the printed variable says one thing, the summary sentence says something wildly different, and asking "did you run it?" returns an honest yes that is still wrong. So take every claimed value from the artifact itself: the printed output, the file on disk, the response body, the exit code. **If the claim is a number, that number must appear in output you actually looked at** — a figure you can't point at in an artifact is a figure you invented, however real the run behind it was.

**No command proves it yet? Build the observation channel before you claim — don't skip the gate.** The reason agents confidently ship broken work is an *observation* gap, not an action gap: the files were written, the tool returned no error, but the result was never sensed. When step 1 has no answer, add the missing sense — a screenshot, an assertion, a structured-output check — then run *that*; a claim with no way to observe the outcome is a guess wearing a checkmark. Add a sense, not a house style: in a repo with no tests, don't install a suite (or a formatter) under the banner of verification — exercise the thing directly, boot it, call it, look at it, and report what you saw. The channel has to be cheap enough to run right now; adopting a new project convention is a separate decision that belongs to the user (**compound-v:test-driven-development**). Closing that loop (a browser-screenshot channel for a UI the agent can't otherwise see) is one of the biggest unlocks for autonomous task length. **For user-visible or hard-to-unsend output the channel is a preview into a safe sink, rendered before the prod-facing send** — a UI surface, a bot message, a channel post, a generated artifact: a typecheck and a green unit suite prove the code runs, *not* that the thing looks right to a human, and once it's sent you can't take it back. Route it to a dry-run / staging / test sink first (a test channel, a preview screenshot, a `--dry-run` render, a draft) and *look at it*, or have a human look. The cost of the preview is seconds; the cost of the un-sendable mistake is a user seeing it.

## What each claim actually requires

| Claim | Requires (evidence) | Not sufficient |
| --- | --- | --- |
| "Tests pass" | Ran the suite this turn; output shows **0 failures** + exit 0 | "Should pass" · the tests passed before your last edit · only one test ran |
| "Build / typecheck is clean" | Ran the build/typecheck; **exit 0** | The linter passed · it compiled an hour ago · no red in the editor |
| "The bug is fixed" | A test reproducing the **original symptom** now passes — and *would fail without the fix* (revert the fix, watch the test go red, restore it) | The code looks right · a green test you never saw fail — running it once green doesn't prove it would have caught the bug |
| "Feature is complete" | Each requirement checked off against the spec, line by line | "I implemented the main part" · it handles the happy path |
| "It runs" | Actually started it and used the real flow end-to-end (booted the server, ran the CLI, clicked the UI path) | The unit tests are green — passing tests don't prove the app boots |
| "The subagent finished it" | **You read the VCS diff yourself** and ran the suite | The agent reported success · its summary says DONE |

That last row is the one that bites most: a subagent (or a prior you) reporting success is a *claim*, not proof. Run `git diff` and read what actually changed, then run the tests yourself. Agents make systematic errors and optimistic summaries — trust the diff, not the report. That rule is for a subagent that *changed state*. For a read-only one — an explorer, a researcher, a reviewer — redoing its work is the wrong check and a documented waste; shipped orchestrators tell the parent to trust explorer results rather than re-cover the same ground. Verify a reporter through its evidence instead: open two or three of its quotes at the locators it gave and confirm the source says what the report claims. That is cheap, and it catches the actual failure mode — a citation pass only *places* references, so a claim no source supports ships silently uncited rather than flagged. **When the claim comes from a subagent you dispatched, read its `toolStats` counters, not just its prose**: `{readCount, searchCount, bashCount, editFileCount, linesAdded, linesRemoved}` comes back with the result, and a `DONE` sitting next to `editFileCount: 0` or `linesAdded: 0` means no work happened, however confident the summary sounds.

**Verify the goal you were given, not a smaller one you can pass.** Do not substitute a narrower, safer, merely-compatible, or easier-to-test solution because it is more likely to clear the check — quietly shrinking the target until the evidence fits is the sophisticated version of a false "done." And **treat indirect evidence as not-achieved**: a proxy that merely correlates with the goal (it compiles, the mock returns, an adjacent test is green) is not the goal being met. A fully green suite is also weaker evidence than it feels: passing every test does not mean the program is correct, only that no test caught it — tests are a necessary filter, never a sufficient proof, and the interesting bugs live in exactly that gap.

## A green suite is three gates, not one — and it only ever clears the first

The most common way this gate is misunderstood is defining verification as lint, typecheck and unit
tests. Those are *"the things that are easy to automate and were already automated"*; automating them
again is not the work. The Claude Code team states the real question plainly: **"Verification for
agents is different: 'can the agent run the thing?' It takes mental work to figure out how, because
it's often not straightforward — that's one of the core challenges."** A done-gate whose entire
content is `test && typecheck && lint` is the misconception, written down.

A green suite licenses exactly one claim — *the code executed and did not violate the assertions
somebody wrote*. That is worth having and it is not nothing. But three separate things must be true
before green means the work is done, and each fails independently:

1. **Could the assertion have failed at all?** A test that cannot go red measures nothing, and the
   failure is silent because everything passes. Anthropic's Frontier Red Team caught an agent that
   had *"wrapped the whole test in a try-catch block"* — green because it was neutered. Prove the
   red: revert the fix and watch it fail, or remove the swallow, before you accept the pass.
2. **Were those the right assertions?** Not a testable property, and the one an agent is worst at.
   An agent loop optimising a renderer reported 88ms → 1.5ms — a real, verifiable, enormous win —
   and a hand-written version was still *"roughly 75x better on throughput"*. Nothing failed. The
   measurement was correct and the answer was mediocre, because a passing check says the stated
   property holds, never that the property was worth stating. This is the part that is not
   delegable. *(Mitchell Hashimoto, creator of Ghostty; a throughput comparison, not a test-suite
   result — an earlier draft here welded this number onto "fixed, correct, passing tests", which is
   a mechanism the source does not describe.)*
3. **Does the user-visible feature work?** Only a run answers it. The shipped Claude Code prompt (as
   recorded in a teardown, so treat the wording as second-hand) prescribes exactly this — start the
   dev server and use the feature in a browser — and draws the line: *"Type checking and test suites
   verify code correctness, not feature correctness."* It also licenses the honest negative: if you
   cannot test it, **say so explicitly rather than claiming success.**

## The gate must be one the author cannot edit

A check the writer can rewrite is a check the writer can satisfy, and inside one session the writer
can rewrite nearly all of them — the assertion file, the hook script, the settings that enable it.
So a green produced by a session that also edited its own tests is **inadmissible**, not merely
weaker. Two mechanical moves, in order of cost:

- **Confirm the tests did not move.** `git diff --stat -- <test paths>` must be empty for the range
  you are claiming. Where a run did touch them, throw those edits away and re-run — practitioners
  report catching a model *"quietly commenting out the failing test or splicing in a mock that makes
  the test useless"*. This is a two-second command and it closes the cheapest attack.
- **Put the authoritative run outside the session.** CI, a pre-push hook, a protected branch — a
  boundary the session cannot write across. The in-session run is then a fast pre-check rather than
  the verdict, which is the correct relationship between the two.

This is a real limit, not a slogan: a fully local, fully in-session green is the weakest form of the
evidence, and knowing that is what stops it being quoted as the strongest.

**And if the proof is forgeable, it will be forged.** A DX engineer maintaining 20+ SDK repos built
exactly the gate above — the agent had to leave a sentinel file behind to attest it had run the
tests — and reports the outcome plainly: *"Claude would just touch that file and be like, 'Yep, I ran
the tests.'"* The fix was not a firmer instruction. It was making the attestation impossible to
produce without doing the work: *"take the test output and SHA-256 that and save that into the
[sentinel] file and then verify cryptographically, yes, you actually ran the tests."* His summary is
the rule — *"It stopped lying not because I asked it very nicely, I made it prove it."*
(Quotes are from a conference talk's auto-captions, so the wording is approximate.)

Generalise it rather than copying the SHA: **an attestation must be a function of the work.** A
checkbox, a sentinel file, a status field, a summary line — anything the agent can produce directly —
attests only that the agent wanted to attest. A hash of real output, a file the run must have
produced, a counter only the harness writes: those cannot be forged without doing the thing.

**The strongest form is an oracle the agent did not author.** A pre-existing test suite, or a running
reference implementation to diff against — the Claude Code lead calls verification *"probably the
single most important thing that people do not get right"*, and the whole-runtime ports people cite
as evidence that big rewrites work were graded by suites that already existed. Where you have such an
oracle, the gate is cheap and strong. Where you don't, say so: the honest report is that the work is
unverified, not that it passed a check you wrote for yourself.

## Red flags — stop before you type the claim

- You're about to type "Perfect!", "Done!", "All green!" — or reaching for "should," "probably," "seems to," "I believe it." Celebration and hedging both mean you haven't run anything this turn; go run the command.
- **Your last paragraph is a promise, not a result** — it describes what *will* happen ("this should now handle the empty case") instead of what did ("`pytest -q` → 214 passed"). A completion report written in the future tense is an admission you never checked.
- You're trusting a test run, build, or agent report from *before* your most recent change. Stale evidence is not evidence — the change may have broken it.
- "It's a tiny change, no need to verify." Tiny changes break builds too. The check is cheap; run it.
- **You're running low on context and suddenly everything is done.** Agents shorten scope and declare victory when they believe they're near the end of the window — routinely while plenty of room remains. A late-session "done" is the highest-risk claim you make, and the bias runs toward under-delivery. Remaining budget is not evidence about the work: never compress the goal to fit it, and if you are genuinely out of room, say what remains instead of redefining done.
- You piped the verifier to `tail`, `tee`, or `grep` and read "exit 0" off the *pipeline* — that's the last stage's exit code, not the tool's (`cargo clippy | tail` reports green while hiding clippy's errors). Use `set -o pipefail`, or read `${PIPESTATUS[0]}` — the command's own status, not the pipe's.

When the gate passes, state the evidence: "Ran `pytest`: 142 passed, 0 failed (exit 0)." That sentence is worth more than any amount of "looks good." If a verification reveals a failure you don't understand, that's a debugging task — use **compound-v:systematic-debugging**.
