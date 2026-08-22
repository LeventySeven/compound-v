---
name: handoff
description: Open, continue, or close the state file for work that will outlive one session. Use when starting multi-session or unattended work, before ending a session with work unfinished, or when the user says continue or resume (in any language) and a run may already be in progress.
---

# Handoff

One state file per repo: `.claude/STATE.md`. Never a second "plan" or "analysis" sibling — a
handoff split across two documents is a handoff that will go stale in one of them.

The single exception is **compound-v:get-shit-done**'s `.claude/slices.json`, and it is an exception
because it is not prose: it holds only the machine-checkable status vector (which slices exist,
which have passed their check), which is exactly the thing a long run quietly rewrites in its own
favour. The split is strict and it is what keeps both files honest — no prose in the JSON, no status
bits in the Markdown, and **Next** naming a slice id rather than restating it. Two files that can
disagree is the failure above; two files that *cannot* overlap is not.

## If `.claude/STATE.md` already exists

1. `git log --oneline -20` and `git status --porcelain`.
2. Read the file.
3. Continue from **Next**. Do not re-plan what it already settled. Do not retry anything under
   **Do not**. **Done** is trustworthy only as far as the commit that last moved it, so let step 1
   arbitrate: what a commit in `git log` backs needs no re-verification, but a dirty tree or commits
   newer than this file's rewrite timestamp are work that happened and was never recorded — which is
   exactly what a session killed mid-step leaves behind. Re-verify that tail; don't trust it and
   don't redo it.
4. If the goal is still open and the work is unattended, quote the **Goal** line back to the user.
   If their harness has a goal or watchdog mechanism, that text is what arms it — a skill cannot
   arm one on their behalf.

## If it does not exist

1. Copy this skill's `STATE.md` template into `<repo>/.claude/STATE.md` and fill it in.
2. If the work is risky or spans days, branch first: `git switch -c run/<slug>`.
3. Commit it alone: `chore: open run state`.
4. Say in one line: the branch, and the **Goal** text the run is aimed at.

## While working

- One completed step = one commit, and that commit also updates **Done** and its evidence line. Under **compound-v:batched-implementation** the step is the *batch*, not the task: the implementer's intermediate per-task commits are exempt and must not move **Done**, because they have not been rechecked yet and **Done** records what is verified, not what is written. The batch's trailered commit is the one that moves it.
  Outside that one exemption, never commit code without moving the state file.
- **One writer owns this file.** When batches fan out in parallel (**compound-v:batched-implementation**), the workers never touch it — the orchestrator writes **Done** itself, one returned batch at a time, in the order verdicts land. File-disjointness between workers buys nothing here: they are disjoint in the code and identical in the path they would both write, and that is the collision, not the exception to it. If two runs genuinely have to be live at once, give each its own branch and its own state file there; a fixed name plus "whoever finishes last wins" is not concurrency safety.
- Append to **Do not** whenever an approach fails. That section is what stops a fresh session
  repeating a dead end — it is the part git history cannot recover.
- Anything blocked goes in **Open decisions**, naming the exact thing a human must supply.
- No calendar estimates. Size by steps and by what must be verified.

## Before a session ends with work unfinished

Rewrite **Next** as one concrete action for a reader with zero context: the file, the function,
the command. Commit. Then say in one line how to resume.

## When the work is done

Delete `.claude/STATE.md` in the final commit — and `.claude/slices.json` with it, if the run opened
one. Git history is the record. Both are run scaffolding; leaving either behind is how the next
session inherits a stale ledger and trusts it.

## Budget

Keep it under 30 lines — the same argument `writing-plans` makes at its 200-line cap. A state file
longer than that stops being re-read in full, and a handoff nobody reads to the end is one whose
tail silently stops existing. If your harness re-injects it at session start, that injection
truncates too, which only sharpens the limit.

This file is **run scaffolding, not a document**: it does not count against the one-new-document-per-change
cap in `using-compound-v`, and it is deleted when the run ends.
