---
name: dispatching-parallel-agents
description: Fan work out to multiple sub-agents only when the pieces are genuinely independent — file-disjoint, no shared state. Use when you have several independent tasks (multi-file edits, parallel research, batch processing) and are deciding whether to parallelize, how to brief each agent, and how to combine results. If the work is coupled, don't split it.
---

# Dispatching Parallel Agents

Parallel sub-agents multiply throughput *and* isolate context — but only when the work is actually independent. The default failure isn't too little parallelism, it's splitting coupled work: isolated agents make divergent assumptions and return pieces that don't fit together. Fan out when the seams are clean; otherwise keep it single-threaded.

## When to fan out

Parallelize when **all** of these hold:

- **Genuinely independent** — task B doesn't need task A's output. (If B consumes A, that's a pipeline, not a fan-out — see below.)
- **File-disjoint** — agents write to non-overlapping files. Two agents editing the same file means last-write-wins, silently — one agent's work just vanishes. Partition by file or use separate worktrees.
- **No shared mutable state** — no shared in-memory structure, no contended resource they'd race on.
- **Each piece is worth a fresh context** — it produces enough output (or noise) that isolating it in its own window is a real win.

Good fits: editing N unrelated modules, researching N independent sub-questions, processing a batch of independent items, gathering context across disjoint areas of a repo.

**Don't parallelize coupled work.** For interactive, tightly-linked work, one strong agent that holds the whole picture beats a fan-out that fragments it — three agents each guessing at the shared design produce incompatible results that cost more to reconcile than they saved. Multi-agent only pays when there's a real shared-state mechanism (file partitioning, a shared task list, external artifacts) *or* the tasks are truly disjoint. When unsure, stay single-threaded.

## The two patterns

**Orchestrator–workers** — you (the orchestrator) decompose the task, dispatch one worker per independent piece, and synthesize the results yourself. Use when you can't predict the subtasks up front and want to decide them based on the input. The orchestrator plans and merges; it does **not** do the primary work itself while workers run.

**Evaluator–optimizer** — one agent produces, another evaluates against clear criteria and feeds back, in a bounded loop. Use when you have a verifiable signal and iteration measurably improves the result (this is the shape of a review/recheck loop). Always bound the loop — cap the iterations and return the best-so-far on a soft-fail, or it can spin forever on something that never fully satisfies the criteria.

## Pipeline by default; barrier only when you must merge

Don't block on all workers if you don't have to. If results feed a next stage one at a time, **pipeline** them — start downstream work as each finishes. Use a **barrier** (wait for everything) only when the next step genuinely needs all results together, like a synthesis that reasons over the full set. A premature barrier turns N parallel agents back into the latency of the slowest one for no reason.

## Brief each worker to stand alone

A sub-agent starts with a **fresh, isolated context** — it does *not* see your conversation, the files you've read, or the skills you've invoked. The only thing that crosses the boundary is the prompt string you give it. So every brief must be self-contained. Include:

1. **One clear objective** — one job per worker; don't bundle. Keep tasks distinct and non-overlapping so two workers never redo or collide on the same thing.
2. **All the context it needs** — paths (absolute), the relevant facts, constraints, the spec. It can't ask you mid-run, and it can't see what you saw.
3. **How to verify its own work** — the test command to run, the check to pass. A worker that can confirm its result returns something trustworthy.
4. **The return contract** — ask for a tight summary (aim for ≤500 words / ~1–2K tokens): what it did, what it found, what's left, anything that surprised it. Findings cross the boundary; raw dumps do not.

Two structural limits to design around: sub-agents **cannot spawn sub-agents** (one level of nesting — fan out from the orchestrator, not recursively), and many workers each returning verbose results will themselves flood the orchestrator's context, so enforce the condensed-summary contract.

## Don't over-spawn

More workers means more overhead and more reconciliation, not linearly more value. Prefer **fewer, more capable workers** over many narrow ones; add a worker only when it does something genuinely distinct. A 50-CEO lookup splits cleanly into a handful of workers handling batches — not fifty one-each. Match the count to the real independent seams in the work, and route down to a single agent (or no sub-agent at all) when the task doesn't actually have them.

## Red flags

| Symptom | What it means |
|---|---|
| Two workers touch the same file | Not file-disjoint — one will silently overwrite the other. Re-partition or serialize. |
| A worker needs another worker's output | It's a pipeline dependency, not a fan-out. Sequence them. |
| Briefs reference "the file we just looked at" | The worker can't see it — fresh context. Inline the content or the absolute path. |
| Spawning a worker per tiny item | Over-spawn. Batch items per worker; prefer fewer capable workers. |
| Blocking on all workers before any next step | Premature barrier. Pipeline unless the next step truly needs the full set. |
| Splitting a tightly-coupled design across agents | Coupled work — they'll diverge. Keep it single-threaded. |
