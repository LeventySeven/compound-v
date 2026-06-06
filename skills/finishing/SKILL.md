---
name: finishing
description: Wrap up a completed branch — verify the full suite is green with fresh evidence, then present merge / PR / keep / discard options and execute the chosen one safely. Use when implementation is done and rechecked and you need to integrate or close out the work — phrases like "wrap this up", "merge it", "open a PR", "are we done here", "clean up the branch".
---

# Finishing

Confirm the work is actually green, then let the user choose how to land it — never auto-merge, never auto-discard.

## When to use

- All tasks are built and compound-v:recheck returned APPROVED.
- The user signals the work is done and asks how to integrate or close it out.
- Skip it when the work isn't finished or recheck hasn't returned APPROVED — finishing assumes a green, reviewed branch; route incomplete work back to compound-v:batched-implementation or compound-v:systematic-debugging instead.

## Step 1 — Verify green, fresh, yourself

Run the **full** test suite (plus lint/typecheck/build if the project has them) right now, in this turn. Read the exit code and the failure count — not "they passed earlier", not the implementer's word. This is the compound-v:verification-before-completion gate: no integration decision on top of unverified work.

If anything fails, **stop** — surface the failure and route back to fixing (compound-v:systematic-debugging). Don't present finish options on a red suite.

## Step 2 — Present the options, let the user pick

Offer a small structured menu, not an open-ended "what now?":

1. **Merge locally** into the base branch.
2. **Push and open a PR.**
3. **Keep the branch as-is** (leave it for later).
4. **Discard** the work.

Pick the base branch deliberately (the branch this work forked from, usually `main`/`master`). State it so the user can correct it.

## Step 3 — Execute the choice safely

**Merge / PR:** run the merge (or push + `gh pr create`), then **re-run the suite on the merged result** — a clean merge can still produce a broken combination.

**Discard or any destructive cleanup:** require a **typed confirmation** ("type `discard` to confirm"). A yes/no is too easy to fire by reflex; destroying work needs a deliberate keystroke.

**Worktree cleanup order** (the footgun): merge → **`cd` out of the worktree** → remove the worktree → then delete the branch. Removing a worktree while you're inside it fails silently, and deleting the branch before removing its worktree errors. Only remove worktrees you created (under a gitignored `.worktrees/` or similar) — never one the harness owns.

## Red flags

| Smell | Why it's wrong |
|---|---|
| Presenting options on an unverified suite | You might be shipping red. Run the full suite this turn first. |
| Auto-merging or auto-discarding | The user owns the integration decision. Present, then act on their pick. |
| Discarding on a bare yes/no | Too easy to fire by accident. Require a typed `discard`. |
| Deleting a branch before removing its worktree | Git errors out. Remove the worktree first. |
| Running `worktree remove` from inside the worktree | Fails silently. `cd` out first. |
| Skipping the post-merge re-test | A clean merge can still break the combined tree. |
