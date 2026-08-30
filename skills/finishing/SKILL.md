---
name: finishing
description: Wrap up a completed branch — verify the full suite is green with fresh evidence, then land it safely: merge, PR, keep or discard. Use when implementation is done and rechecked and you need to integrate or close out the work — "wrap this up", "merge it", "open a PR", "are we done here", "clean up the branch".
---

# Finishing

Confirm the work is actually green, then land it the way the user chose — or, when nobody is there to be asked, the way that can be undone.

## When to use

- All tasks are built and the branch is **reviewed** — compound-v:code-review clears it before any merge either way, and where the work was built here in more than one batch that pass is also the whole-branch drift read (Step 1); in-session compound-v:recheck verdicts cover the batches, not the branch.
- The user signals the work is done and asks how to integrate or close it out.
- Skip it when the work isn't finished or it hasn't passed review — finishing assumes a green, reviewed branch; route incomplete work back to compound-v:batched-implementation or compound-v:systematic-debugging instead.

## Step 1 — Verify green, fresh, yourself

Run the full suite this turn and read the exit code yourself — the **compound-v:verification-before-completion** gate, applied to integration: no merge/PR decision rides on "they passed earlier" or the implementer's word. A red suite is **not** a finishing situation: **stop**, surface the failure, and route back to **compound-v:systematic-debugging** — never present the options below on red, because every one of them assumes a green branch. Formatting is the one exception to that strictness: iterate at most **3 times** to get lint/format clean, then ship and disclose what's still off rather than burning the run on cosmetics — and if the repo has no formatter configured, do not add one.

**Green is necessary, not sufficient — the change must be reviewed before it lands.** Run **compound-v:code-review** before any merge and resolve every Critical/Important finding first; an unreviewed change does not get merged, however green it is. In-session **compound-v:recheck** verdicts do not substitute — they cover the batches, not the branch. When the branch was built in more than one batch, point that review at the *assembled* branch and hunt cross-batch drift specifically (a contract two batches each half-changed, a convention that shifted mid-run) — the one thing a reviewer that only ever saw a single batch's diff structurally cannot see.

**Green ≠ "the change worked" when the change targets a metric.** If the work was meant to move cost, latency, quality, or some observable behavior, a passing suite only proves it didn't break — it does *not* prove the intended effect landed. Finish that work by **measuring the effect with a real post-ship run**, not by asserting it ("should be ~30% cheaper now" is a prediction, not a result). If the measurement is genuinely blocked (needs prod traffic, a scheduled batch, real users), say so and **track/schedule it** — a deferred measurement is an open item, never silently "done." And **sanity-check any auto-generated metric before you relay it**: a number off by a timezone, a confound, or a selection bias is worse than no number, because it reads as evidence.

**Green says nothing about which *default* is live.** The temporary machinery a branch introduces — a feature flag, an env-var default, a short-circuited guard, a stub endpoint, a hardcoded account — is live code sitting on a chosen setting, not dead code a reviewer trips over, and where each test sets the path it needs the suite passes on either setting: the shipping default is the one path nothing exercises. So before you land, list every toggle this branch added and state its shipping value out loud. A flag someone added temporarily and forgot is the shim a contractor walls into a house: it surfaces later as a first-run user staring at an empty screen while every test is green. Aim to land at most one; if a toggle must stay, name who removes it and when.

## Step 2 — Pick the landing path

**Only offer a menu when the user is actually there to answer it.** In an unattended or scheduled run the user is not watching in real time and cannot answer mid-task, so "Want me to…?" simply blocks the work. There, take the **reversible** default — commit, push, open the PR, leave the branch standing — and report what you did. Stop and wait for explicit confirmation only on the irreversible paths: merging into the default branch, force-pushing, or discarding work. When the user *is* present, offer a small structured menu, not an open-ended "what now?":

1. **Merge locally** into the base branch.
2. **Push and open a PR.**
3. **Keep the branch as-is** (leave it for later).
4. **Discard** the work.

Pick the base branch deliberately (the branch this work forked from, usually `main`/`master`). State it so the user can correct it.

## Step 3 — Execute the choice safely

**Merge / PR:** run the merge (or push + `gh pr create`), then **re-run the suite on the merged result** — a clean merge can still produce a broken combination. If the merge hits a **conflict**, **stop and surface it** — resolve it deliberately, or hand it back. The PR path needs the branch pushed first (`git push -u origin <branch>`) and `gh` authenticated; check both before `gh pr create` rather than after it fails. Green locally is not green in CI. After the PR is open, surface the remote check status (`gh pr checks --watch`) rather than declaring done at `gh pr create` — a merged-result suite you ran can still diverge from the repo's CI, and the branch isn't landable until those checks pass.

**The PR body is an artifact, not a title — put the evidence inside the repo's two native sections, don't invent a competing layout.** Under `#### Summary`, at most three bullets on what changed and why, plus the review verdict (`APPROVED`) and any follow-up you deliberately deferred. Under `#### Test plan`, a checklist whose items are the **actual commands you ran and their result lines** — `pytest -q → 214 passed`, never "tests pass". A reviewer should be able to trust the branch from the body alone.

**Discard or any destructive cleanup:** require a **typed confirmation** ("type `discard` to confirm") — a yes/no is too easy to fire by reflex, and this is the one path the unattended default above may never take on its own. Make that confirmation *informed* by first surfacing the work that would vanish unrecoverably: **unpushed commits** (`git log --branches --not --remotes --oneline`, or `git log <base>..HEAD`), which no status check will show you.

**Retire the per-change scaffolding in the landing commit.** `using-compound-v` requires that the durable part — the decision and what was rejected — folds into the living doc or an ADR when the work lands, and that the scaffolding then goes. This is the step that executes it: the per-build plan and its design spec have no readers once the work is merged, and left behind they become the "repo full of specs nobody reads" the document rule exists to prevent — the same reason `compound-v:handoff` deletes its run scaffolding in the final commit. Fold, delete, and say in one line what you folded and where. **Whatever you delete, drop or repoint the links that named it** — the PRD links to the plan and the design spec by rule (`compound-v:writing-prd`), so a silent delete leaves the product's stable source of truth pointing at nothing, and a stale durable doc an agent trusts as fact is worse than no doc. Keep a plan only when something still open points at it, and say what.

**Worktree cleanup order** (the footgun): merge → **`cd` out of the worktree** → remove the worktree → then delete the branch. Both ends bite, but only one is loud: deleting the branch first errors out (`cannot delete branch 'feat' used by worktree at …`, exit 1) and self-corrects. Removing the worktree from inside it *succeeds* — exit 0, directory gone — and strands your shell in a deleted cwd, where `pwd` still prints the old path while every later command dies with an unrelated-looking `fatal: Unable to read current working directory`. The dangerous case is the one that returns success, which is why the `cd` comes first. Only remove worktrees you created (under a gitignored `.worktrees/` or similar) — never one the harness owns.
