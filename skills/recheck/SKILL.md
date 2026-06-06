---
name: recheck
description: Dispatch one read-only Opus pass over a finished batch of work to catch misalignment, bugs, security holes, and over-engineering before it ships, returning severity-tagged findings and a verdict. Use after an implementer reports DONE, before finishing or merging, or whenever you want a finished change independently verified — phrases like "review this", "check the diff", "is this ready", "did the agent actually do it right".
---

# Recheck

One Opus 4.8 reviewer reads the actual diff, runs the tests itself, and reports discrete findings with a verdict. It is **read-only** — it never edits — and it runs a fixed pass ordered cheapest-disqualifying-first so a wrong feature is caught before anyone grades its style.

## When to use

- An implementer batch reports `DONE` / `DONE_WITH_CONCERNS` (compound-v:batched-implementation hands off here).
- Before compound-v:finishing or any merge/PR.
- Any time you need a finished change verified by something other than the agent that wrote it.
- Skip it for a typo, rename, or config flip — a Trivial-tier change goes straight to compound-v:verification-before-completion. Recheck is for changes with logic in them.

## Two rules that make this work

**Read-only.** The reviewer gets read + run-tests tools, never Edit/Write. A reviewer that can edit can introduce its own bugs, and the bug it adds is the one nobody reviews. Every serious coding agent enforces this on its reviewer (Amp's `oracle` is read-only; Codex's review prompt never patches). The **implementer** applies fixes; recheck only finds them.

**Don't trust the report — verify independently.** The implementer's summary may be optimistic, incomplete, or wrong. Read the actual VCS diff yourself (`git diff <base>..<head>`). Re-run the tests yourself. "Agent reports success" is not evidence; fresh output is. The same caution applies to the model's stated reasoning — a chain-of-thought can be edited to nonsense and still yield the right answer, so "show your reasoning" is not a correctness check. Judge the behavior and the diff, not the explanation.

## The pass — cheapest-disqualifying-first, short-circuit

Run these in order. If a step disqualifies the work, **stop and report** — don't spend effort grading code quality on a feature that's wrong or off-plan.

1. **Goals / principles alignment.** Does this serve the real objective (the spec + the user's CLAUDE.md + the three-compounds gate: does it grow taste, distribution, or a primitive)? Is it overkill — complexity, abstraction, or machinery the task never asked for? *Misaligned or over-built → stop, report, don't go further.*

2. **Plan alignment.** Does the diff match the approved plan? Watch both directions: scope creep (features nobody requested) and under-build (a planned requirement missing). *Diverged → report before any correctness review.*

3. **Bugs.** Read the diff. Logic errors, unhandled edge cases, error paths that swallow or mishandle, off-by-one, null/undefined, race conditions, resource leaks. Only flag bugs **introduced in this diff** — pre-existing bugs are out of scope (flag them separately at most, never as blockers for this batch).

4. **Vulnerabilities** (first-class — most review skills omit this entirely). Check for: injection (SQL/command/template), broken authz (missing ownership/permission checks), secrets in code or logs, unsafe deserialization, SSRF, path traversal, and — for agent/LLM code — the **lethal trifecta** (private data + untrusted content + exfiltration channel in one flow). A security hole is at least Important, usually Critical. Name the class and the exact triggering input (path traversal / CWE-22 via `../`, BOLA/IDOR, SQL/command injection, SSRF), and call out the second-order or at-scale version — a named, reproducible exploit is what gets it fixed.

5. **Re-test.** Actually run the test suite, the linter, and the typecheck/build. Read the full output and the exit code — count failures, don't trust "should pass". Confirm the tests are *real*: they exercise behavior, not mock-into-tautology assertions that pass no matter what the code does. Green only counts with fresh evidence in this pass.

6. **Patterns / anti-patterns.** Does it follow the codebase's existing conventions and the canonical pattern for what it's doing (use compound-v:searching-patterns when the right pattern is non-obvious)? Flag known anti-patterns. And ask the question over-engineering hides from: **is there a materially simpler version that's just as correct?** If yes, that simpler-possible is a finding — and rate it **Important**, not a throwaway Minor, when the extra machinery is unused/dead code, violates an explicit simplicity requirement, or carries latent risk (memory blowup, a cross-user leak if it were wired up, a maintenance trap). Minor only when it's genuinely cosmetic.

## Output

A list of findings, each:

```
[Critical|Important|Minor] path/to/file.ext:line
  issue: one sentence — what is wrong
  why:   one sentence — the concrete impact / the input that triggers it
  fix:   one sentence — what would resolve it (the implementer applies it, not you)
```

Then exactly one verdict:

- **APPROVED** — no Critical or Important findings; ship it.
- **FIX_REQUIRED** — at least one Critical/Important; the implementer fixes, then re-check.
- **ARCHITECTURE_CONCERN** — the approach itself is wrong (failed step 1 or 2, or fixes keep failing); escalate to a re-plan rather than patching.

**Anti-sycophancy.** Report only newly-introduced, discrete, non-speculative issues. No praise padding, no "great job", no "you might consider…" hedging. "It is not enough to speculate that a change *may* disrupt another part of the codebase" — if you can't name the trigger, it isn't a finding. Severity must be honest and calibrated by **impact, not by category label** — a "smell" / "style" / "nit" tag does not cap a finding at Minor if its real-world consequence is large. Don't inflate a true nit to Critical; don't bury a high-impact issue as Minor. A clean diff gets a one-line APPROVED, not a manufactured list.

**Signal-density cap.** At most ~10-12 findings per pass. Returning 40 small findings buries the critical one. If there are more than a dozen real problems, the right finding is ARCHITECTURE_CONCERN.

## The loop and its cap

Findings go back to the **same implementer** to fix (it has the context; it holds the edit tools). Then re-check. **Cap at 3 fix↔recheck cycles** — this N=3 is convergent across production agents (Devin stops after 3 CI failures, Cursor after 3 lint loops, WARP `MAX_RETRIES=3`). Still failing at cycle 3 is a signal, not a reason for cycle 4: return ARCHITECTURE_CONCERN and question the design or the plan.

## Optional: cross-model reviewer

You run all-Opus by default. If quality matters more than uniformity on a hard change, add **one** reviewer from a different model family for this pass. A single different-family reviewer closes ~74.7% of a same-model quality gap (+4.8% on the hardest problems) at minimal cost — different families catch errors neither catches alone. This is a toggle for high-stakes diffs, not the default.

## Red flags

| Smell | Why it's wrong |
|---|---|
| Approving from the implementer's summary | You reviewed prose, not code. Read the diff. |
| Letting recheck edit the code | The reviewer's own bug ships unreviewed. Read-only; implementer fixes. |
| Grading code style on a misaligned feature | Wasted effort on the wrong thing. Steps 1-2 short-circuit first. |
| "Tests pass" without running them this pass | Stale or imagined. Re-run; read the exit code. |
| Skipping the vulnerability step | The omission most review skills make; security holes ship silently. |
| A wall of Minor nits, no verdict | Buries real issues and gives the implementer nothing to act on. Cap findings; always give a verdict. |
| Praise padding / "you're absolutely right" | Sycophancy dilutes signal. Findings only. |
| Attempting fix cycle #4 | The architecture is the problem; escalate, don't grind. |
