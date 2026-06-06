---
name: systematic-debugging
description: Find the root cause before changing any code — reproduce, trace to the source, form one hypothesis, then fix. Use when hitting a bug, test failure, crash, or any unexpected behavior, before proposing or trying a fix, and escalate to questioning the design when fixes keep failing.
---

# Systematic Debugging

Find the root cause before you touch a fix. A fix aimed at a symptom you don't understand either misses, or papers over the real defect and spawns two more.

The failure mode this prevents: pattern-matching the error to a plausible-looking change, applying it, and — when it doesn't work — applying another, and another. Each blind attempt mutates the code, muddies the evidence, and moves you further from the cause. One understood fix beats five guesses.

## When to use

- Any bug, test failure, crash, hang, or "it works on my machine but not in CI."
- Output that's wrong in a way you can't immediately explain.
- Before proposing a fix — if you're about to say "try changing X," stop and confirm you know *why* X is the cause.

For a one-line obvious typo (wrong variable name the compiler points at), just fix it. This skill is for anything where the cause isn't already staring at you.

## The four phases — in order

You don't always need all four, but you may not skip *ahead* of a phase you haven't satisfied. You cannot hypothesize a cause (Phase 3) before you've reproduced and traced (Phase 1).

### Phase 1 — Find the root cause
- **Read the actual error.** The full message, the full stack trace, the exit code. Not the gist — the literal text. The answer is often in a line people skip.
- **Reproduce it consistently.** A bug you can't trigger on demand, you can't verify you fixed. Find the exact inputs/steps. If it's flaky, make it deterministic before going further (e.g. control the timing/seed/ordering that makes it intermittent).
- **Check what recently changed.** `git diff`, `git log` on the touched files. Most new bugs entered with recent edits.
- **Trace backward from the symptom to its source.** Don't fix where the error *surfaces*; follow the data back to where it first goes wrong. In a multi-component flow, log (or inspect) the value at each boundary between components — the boundary where good input becomes bad output is your suspect. The error message location is a clue, not usually the cause.

### Phase 2 — Find a working reference
- If something *similar* works elsewhere in the codebase, compare against it **completely** — every difference, not the first one you spot. The bug is usually in a difference you dismissed as irrelevant.
- Make sure you understand the dependency/API you're using — read its real contract, don't assume its behavior.
- **Diagnose before mutating the environment.** When the failure looks like deps/build/env, do NOT reflexively install, uninstall, upgrade, or `rm -rf node_modules` first. Read the error, inspect the lockfile/config, understand *what's actually missing* — then act. Thrashing the environment destroys the evidence and often "fixes" it by accident, so you never learn the cause and it returns.

### Phase 3 — Form a single hypothesis
- State it explicitly: **"X is the root cause, because Y."** Writing it forces the causal claim into the open where you can check it.
- **One hypothesis, one variable at a time.** Changing three things at once and seeing it pass tells you nothing about which mattered — and one of the other two may now be a latent bug.
- If you genuinely don't know, say "I don't know" and go gather more evidence. A confident wrong hypothesis is worse than an admitted gap.

### Phase 4 — Fix and verify
- **Write a failing test that reproduces the bug first**, then fix until it passes (this is the bug-fix loop in **compound-v:test-driven-development**). The test is your proof the fix landed and your guard against regression.
- Make the **single** change your hypothesis predicts. Verify the symptom is gone and the suite stays green.
- If the fix doesn't work, that hypothesis was wrong. Revert it (don't leave failed attempts stacked in the code), return to Phase 1 with what you just learned, and count the attempt.

## The 3-attempt rule — stop digging, question the design

Track your fix attempts. The empirical cap before escalating is **three** (it shows up independently across production agents: CI retries, lint-fix loops, and iteration mediators all stop at ~3).

```dot
digraph debug {
  rankdir=TB;
  fix    [shape=box, label="apply the single\nhypothesized fix"];
  works  [shape=diamond, label="symptom gone +\nsuite green?"];
  done   [shape=doublecircle, label="done — verify\nfor real"];
  count  [shape=diamond, label="3rd failed\nattempt?"];
  again  [shape=box, label="revert it; back to\nPhase 1 with new evidence"];
  stop   [shape=octagon, label="STOP. Do NOT try fix #4.\nQuestion the architecture."];
  fix -> works;
  works -> done [label=yes];
  works -> count [label=no];
  count -> again [label="no (1st/2nd)"];
  count -> stop  [label=yes];
}
```

After three failed fixes, the problem is almost never the next tweak — your model of the system is wrong. **Do not attempt fix #4.** Stop and challenge a level-up assumption:

- Is my understanding of how this system works actually correct? (Re-read, re-trace — maybe the data doesn't flow the way I assumed.)
- Is the *design* the bug? A fix that keeps slipping away often means the abstraction is wrong, not the line.
- Am I fixing the right layer? The symptom may be downstream of a cause in a component I haven't looked at.
- Should I ask the user / surface the blocker? "I've tried A, B, C, each failed because Z — I think the issue is the design of W" is far more useful than a fourth guess.

A signal you've already crossed this line: you're adding defensive checks, retries, or `try/except` around a symptom you can't explain. That's not a fix — it's hiding the bug. Go back to root cause.

## Red flags

| Thought / behavior | What to do instead |
| --- | --- |
| "Let me just try changing this and see." | You're guessing. Reproduce and trace to the cause first (Phase 1). |
| "I'll reinstall deps / bump the version and hope." | Diagnose before mutating the environment — read the error and the lockfile first (Phase 2). |
| "It might be one of these few things, I'll fix all of them." | One hypothesis, one variable. Fixing several at once hides which was real and may add bugs. |
| Wrapping the symptom in a try/except or a retry to make it pass | That's concealment, not a fix. Find why it throws. |
| Attempt #4, #5, #6 on the same bug… | Stop. After 3, the design or your understanding is wrong — question that, don't tweak again. |
| "The error message is long, I'll skim it." | Read it fully — the exact cause is often in the part you'd skip. |
