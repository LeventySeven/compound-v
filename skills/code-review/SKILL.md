---
name: code-review
description: On-demand and pre-merge reviewer for a specific change — point it at a pull request, a branch, or your uncommitted diff, or let it run automatically as the gate before anything is merged; it returns confidence-gated, severity-tagged findings at a depth that matches the change, and can post them to GitHub or apply the fixes. Use when someone hands you a change to review — "review this PR", "review my diff", "look over this branch", "is this change ok", "code review #123" — AND automatically before merging or landing a PR/branch ("merge this PR", "is this ready to merge", "land #123", "merge these PRs"): anything about to hit the base branch gets reviewed first, even when no one names a review. Outside the build pipeline, where compound-v:recheck owns the in-loop gate.
---

# Code Review

Fire one review at a diff, scale its depth to the diff's size, and let only findings you're confident in survive.

This is the **on-demand** reviewer: a user points you at a PR, a branch, or the working set and asks for a review. compound-v:recheck is the **in-pipeline gate** — the fixed pass an implementer batch hands off to before the next batch. Same honesty bar, different trigger and different reach: code-review scopes its own target, scales from a single quick pass up to a deep multi-agent sweep, confidence-gates what it reports, and can post to GitHub or apply the fixes. When you're already inside the build loop, use recheck and stop reading.

## When to use

- A user points you at a change: "review this PR", "review my diff", "look over branch X", "is #123 ready".
- You want a diff reviewed *outside* the batched-implementation→recheck loop — a colleague's PR, a long-lived branch, your own working set before you open the PR.
- **Before a PR or branch is merged — automatically.** Anything about to land in the base branch gets reviewed first, even when no one explicitly asks ("merge this PR", "land #123", "merge these PRs"). compound-v:finishing runs this as its pre-merge gate and won't merge over an unresolved Critical/Important finding.
- Skip it for a typo, rename, or config flip → compound-v:verification-before-completion. And inside the build pipeline, recheck owns the review — don't run both on the same batch.

## Step 1 — scope the target, then decide if it's even worth reviewing

Resolve exactly what diff you're reviewing before reading a line of it:

- **A PR** → `gh pr diff <n>` for the patch, `gh pr view <n>` for title/body/state. (Use `gh`, not web fetch.)
- **A branch** → `git diff $(git merge-base main HEAD)..HEAD` — diff against the merge-base, not raw `main`, so unrelated upstream commits don't pollute the review.
- **The working set** (nothing committed yet) → `git diff HEAD`.

Then a cheap **eligibility check** — bail early and say why if the change is closed, a draft, an automated/bot PR, trivially obvious, or already carries your review. Reviewing what doesn't need it is its own kind of overkill.

Read the touched directories' `CLAUDE.md` / `AGENTS.md` for house rules — those are the contract the diff is held to, and a local convention overrides any external "correct" pattern (compound-v:searching-patterns).

## Step 2 — match depth to the diff (route *down* when unsure)

compound-v:using-compound-v owns the tier law; this is the same law applied to a review. Pick the smallest depth that covers the diff:

| Depth | What it runs | Reach for it when |
|---|---|---|
| **low / medium** | one pass over the diff; report only high-confidence findings | a small, contained diff — a few files, clear intent |
| **high / max** | the parallel lenses below; broader coverage, may surface less-certain findings | a larger or cross-cutting change, or you want thoroughness over speed |
| **ultra** | a deep multi-agent sweep — more lenses, more passes, independent verification of each finding | a high-stakes or one-way-door change where a missed bug is expensive |

A bigger pass is not a better pass — `low` on a one-file fix is the right call, not a corner cut.

## Step 3 — the lenses (parallel fan-out at `high`+)

At `high` and above, read the diff through several independent lenses **in parallel** and merge their findings. Reading and analysis parallelize cleanly; keep any *write* single-threaded — multi-agent earns its keep as added review intelligence, never as parallel editors (compound-v:ai-system-reliability). A clean-context reviewer that reasons backward from the diff catches what the author's own context rationalizes away — the same clean-context review mechanism (and its measured bugs-per-PR) that **compound-v:recheck** documents.

1. **Conventions** — does the diff obey the relevant `CLAUDE.md` / `AGENTS.md` and the codebase's existing shape? (House rules are guidance for *writing* code, so not every line applies on review — judge intent.)
2. **Bugs in and around the diff** — first a shallow scan of the changed lines: logic errors, unhandled edge cases, off-by-one, null/undefined, error paths that swallow, races, resource leaks. Then widen to the **contract**: trace the callers and callees of every modified symbol and pull just those directly-connected files into context, since a change often breaks a dependency it never touches and that cross-file break is invisible if you read only the diff. Load the contract, not the whole repo (compound-v:context-engineering). Only what's **introduced here** — pre-existing bugs are out of scope.
3. **Historical context** — `git blame` / log on the touched code: does the change reintroduce a reverted fix or miss why the old code was the way it was?
4. **Prior art** — earlier PRs on these files and the review comments they drew; the same note may apply again.
5. **Inline guidance** — code comments in the modified files that the change now violates.

Security is a lens too, but its catalog lives in compound-v:agent-security (build-time defense) and the vulnerability pass in compound-v:recheck (detection) — don't restate it; when a lens trips a security concern, name the class and the triggering input and point the fix there.

## Step 4 — gate false positives by confidence

This is the step that makes an on-demand reviewer trustworthy instead of noisy. Gate cheapest-first: before scoring anything, **drop any finding whose cited line doesn't map to a real changed line in the diff** — a hallucinated location is a common false positive and catching it is free and deterministic. Then score every surviving candidate finding 0–100 for how sure you are it's a *real, diff-introduced* issue, and **drop anything below ~80** — the confidence-scored filter the official Claude Code reviewer uses to keep false positives off the PR. For a CLAUDE.md-derived finding, re-verify the rule actually says what you claim before it counts.

The confidence gate filters hallucinated findings *after* they're generated; the sharper fix is upstream. A free-text "review this diff" prompt defaults to *manufacturing* nits, because silence reads as failure — so make "nothing to report" an explicit, equally-valid outcome (a `finish_review(comments: 0)` action), not an absence of output. One production reviewer's switch from free text to a forced per-finding action with an explicit no-finding branch cut its hallucination ratio from ~9:1 to ~1:1 (Graphite/Diamond).

Default to *not* a finding. These are not findings:

- Pre-existing issues, and real issues on lines the diff didn't touch.
- Anything a linter / type-checker / compiler / CI would catch — imports, types, formatting, broken tests. Assume those run separately; don't review them. (Exception, at high/ultra or when no CI is wired up: run the static-analysis tools yourself and have the model triage each finding for whether it's real in *this* diff — the model as a filter on top of the tools, not a re-derivation of what CI already reports.)
- Nitpicks a senior engineer wouldn't raise; general "more tests / more docs" wishes not required by CLAUDE.md.
- A change the author clearly made on purpose, or one held to a rigor bar the surrounding code doesn't meet — a deliberate design choice is not a bug, and a clean-context reviewer is the one most likely to misread intent it can't see (OpenAI Codex review prompt).

Severity is calibrated by **impact, not by label** — a "nit"/"style" tag doesn't cap a true high-impact issue at Minor, and don't inflate a real nit to Critical. Cap the report at ~10–12 findings; if there are genuinely more, the headline finding is that the change needs rework, not a wall of line-notes.

## Output

A list of surviving findings, each:

```
[Critical|Important|Minor] (confidence NN) path/to/file.ext:line
  issue: one sentence — what is wrong
  why:   one sentence — the concrete impact / the input that triggers it
  fix:   one sentence — what would resolve it
```

Then one verdict: **APPROVED** (no Critical/Important — a clean diff gets a one-line approval, not a manufactured list), **FIX_REQUIRED** (at least one Critical/Important), or **ARCHITECTURE_CONCERN** (the approach itself is wrong — escalate to a re-plan, don't patch). No praise-padding, no "great job", no "you might consider" hedging; if you can't name the trigger, it isn't a finding.

## Posting and fixing — the review stays read-only

The review **finds**; it does not edit. A reviewer that can edit ships its own unreviewed bug (compound-v:recheck). The two outbound actions are explicit, separate phases that run *after* the findings exist — triggered by intent ("post these to the PR", "apply the fixes") or by the familiar `--comment` / `--fix` flags from Claude Code's own reviewer:

- **Post to GitHub (`--comment`)** — write the findings as inline PR comments via `gh`. Re-run the eligibility check first (state can change while you review). Keep each comment brief, no emojis, and cite the file + line with a permalink. If there are no surviving findings, say so and skip — don't post an empty review.
- **Apply the fixes (`--fix`)** — apply the surfaced findings to the working tree as a deliberate follow-on, **verifying each against the code before implementing it** and pushing back on a wrong one rather than typing it out (the receiving-findings discipline in compound-v:batched-implementation) — skipping any that are wrong or not worth it, then **re-run the relevant tests/linter/build and read the output** before claiming done (compound-v:verification-before-completion). This is a distinct apply phase, not the reviewer silently mutating code mid-review.

## Red flags

| Smell | Why it's wrong |
|---|---|
| Posting findings straight from the diff with no confidence gate | Unfiltered review is noise; the one false positive a senior engineer waves off costs you the credibility of the ten real ones. Gate at ~80. |
| Running `ultra` on a one-file fix "to be safe" | Overkill is a defect. Depth matches the diff; a bigger pass isn't a better pass. |
| Flagging a pre-existing issue or an unmodified line | Out of scope for *this* diff. Note it separately at most; never as a blocker for the change under review. |
| The reviewer edits the code while reviewing it | The edit it introduces is the one nobody reviews. Review read-only; `--fix` is a separate, explicit, re-verified phase. |
| Reviewing prose — the PR description or the author's summary instead of the patch | You reviewed the story, not the change. Read the actual diff. |
