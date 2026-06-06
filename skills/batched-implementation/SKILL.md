---
name: batched-implementation
description: Execute a written implementation plan with fresh-context implementer subagents, batched ~2-3 related tasks each with a read-only recheck gate per batch. Use when you have an approved plan or task list to build out in this session and want isolated, reviewable execution — phrases like "implement the plan", "build these tasks", "run the implementer", "execute the spec".
---

# Batched Implementation

Run a plan as a small number of fresh-context implementer subagents (one per 2-3 related tasks, all Opus 4.8), recheck each batch, and keep going without stopping to ask permission.

## When to use

- You have an approved plan (from compound-v:writing-plans) or a concrete task list, and you're about to build.
- The work is the **Standard** tier (a feature, ~2-8 tasks). For a one-file change or a typo, skip this entirely and just do it inline → compound-v:verification-before-completion. Spawning a subagent for a one-liner is the overkill this kit exists to refuse.
- For **Large** work (multiple subsystems), decompose into sub-projects first; each runs its own Standard cycle.

## Why batches, not one-agent-per-task

Superpowers dispatches a fresh agent per task plus two sequential reviewers plus a final review — ~16 dispatches for a 5-task plan. The 1:1 ratio is justified only by fear of context pollution. Opus 4.8's window holds 2-3 related tasks comfortably, and keeping shared types/imports/helpers in one agent's head keeps them *coherent* (the same struct named the same way across the tasks that touch it). Batching cuts dispatches ~60% with no loss of isolation — each batch is still a clean context, and recheck (not a second reviewer) is the quality gate.

WARP's finding is the counterweight that makes this safe: for coupled, latency-sensitive work, one strong agent beats a planner→executor→critic fan-out. So group coupled tasks together; don't shatter a plan into atomized agents.

## The loop

**Setup (once):**
1. Confirm you're not on `main`/`master`. If you are, branch first (or set up an isolated worktree) — never implement directly on the default branch.
2. Read the plan file **once**. Extract every task with its full text and context. Build a TodoWrite with one entry per task.
3. Group tasks into batches of **2-3 by coupling** — tasks that share files, types, or a feature surface go together. A task that's independent of everything else can be its own batch.

**Per batch:**
1. Dispatch **one implementer subagent** (Task tool, `general-purpose`, Opus 4.8) for the batch.
   - **Paste the full task text** into the prompt. Never tell the subagent to "read task 3 from the plan file" — it costs a read and risks it grabbing the wrong context. The dispatch prompt is the contract; it must stand alone.
   - Include: the pasted tasks, scene-setting context (what exists, what the batch fits into), the relevant file paths, and **how to verify** (the exact test/lint/typecheck commands). An implementer told how to check its own work produces far less for recheck to catch.
   - Mandate the discipline: follow existing conventions, never assume a library is present without checking the manifest, write tests (compound-v:test-driven-development), keep changes minimal, and self-review before reporting.
2. Read the subagent's report. It must end in one of **four statuses**:

   | Status | What it means | What you do |
   |---|---|---|
   | `DONE` | Built, tested, self-reviewed, clean | Proceed to recheck. |
   | `DONE_WITH_CONCERNS` | Built, but flagged something | If the concern is correctness or scope, resolve it before recheck. If it's a benign observation, note it and proceed. |
   | `NEEDS_CONTEXT` | Missing info it couldn't infer | Supply the missing context, re-dispatch the same batch. |
   | `BLOCKED` | Can't proceed | Assess: too large → split the batch; plan is wrong → escalate to the user; genuinely ambiguous → ask. Don't re-dispatch unchanged. |

   The status is a clean state machine — act on it, don't re-parse the prose.
3. Hand the batch to **compound-v:recheck** (one Opus read-only pass over the batch's diff). Recheck returns findings + a verdict — one of three values; branch on all three (recheck can emit `ARCHITECTURE_CONCERN` on the *first* pass when the approach fails its goals/plan check, before any fix cycle, so don't treat it as only a 3-cycles-exhausted outcome).

   | Verdict | What you do |
   |---|---|
   | `APPROVED` | Mark the batch's tasks complete in TodoWrite. Next batch. |
   | `FIX_REQUIRED` | Hand the findings back to the **same implementer** to fix (the implementer edits; recheck never does), then re-check. Cap at **3 fix↔recheck cycles** — still failing at 3 means recheck returns `ARCHITECTURE_CONCERN`, not attempt #4. |
   | `ARCHITECTURE_CONCERN` | The approach itself is wrong. **Stop the loop** and escalate to re-plan (compound-v:writing-plans). Do **not** re-dispatch the same batch, and do **not** hand to finishing — finishing is reachable only from `APPROVED`. |

## Serial by default; parallel only when file-disjoint

Run implementers **serially**. Two implementers editing overlapping files in parallel produce merge conflicts and silent clobbers — the cost of untangling that erases the speedup.

The exception: batches that are **genuinely file-disjoint** (no shared files, no shared state) can run concurrently. When they qualify, dispatch them in one message and see **compound-v:dispatching-parallel-agents** for the fan-out + conflict-check-on-return discipline. When unsure whether two batches are disjoint, run them serially — it's the safe default.

## Continuous execution

Do not pause between batches to ask "should I continue?" — it wastes the user's turn. The only legal stops are: a `BLOCKED` you can't resolve, a recheck `ARCHITECTURE_CONCERN` (stop the loop, escalate to re-plan), a genuine ambiguity that changes scope, or all batches done and rechecked. Keep going until the plan is built and every batch is APPROVED, then hand off to **compound-v:finishing**.

## Red flags

| Smell | Why it's wrong |
|---|---|
| Implementing on `main`/`master` | No isolation; a bad batch dirties the default branch. Branch first. |
| Telling a subagent to read the plan file | It may grab the wrong section or stale context. Paste the full task text. |
| One subagent per single task | The 1:1 ratio you're here to avoid — batch coupled tasks 2-3 at a time. |
| Two implementers on shared files in parallel | Merge conflicts and clobbers. Serial unless file-disjoint. |
| Skipping recheck "because the batch was simple" | Recheck is the only quality gate in this loop; skipping it removes the gate. |
| Re-dispatching a `BLOCKED` batch unchanged | Same input → same block. Change the context, split the batch, or escalate. |
| Looping fix↔recheck past 3 cycles | The architecture or plan is wrong; recheck returns `ARCHITECTURE_CONCERN` — stop and re-plan, don't grind. |
| Proceeding or re-dispatching after an `ARCHITECTURE_CONCERN` | The approach is rejected; re-running the same batch reproduces it. Stop the loop and escalate to re-plan — never hand to finishing. |
