---
name: ai-system-reliability
description: Make a built AI system reliable at scale — supervisor/specialist constellations, the simulator-as-regression, the "make the missing capability enforceable" failure reflex, and the state-corruption landmines at the seams (idempotency, concurrency, durable resume). Opt-in (manual): invoke only when the user explicitly asks for help making an AI system reliable, chaining it past one model's ceiling, or fixing drift / double-fires / races at scale — or names this skill. Do not auto-trigger; this is a deliberate deep-dive.
---

# AI System Reliability

In a built AI system, reliability is the product and the seams between subsystems are where state silently corrupts — so engineer the system-level architecture (constellations, durable resume, idempotency) that catches the failure instead of replaying it.

## When to use

- The system is shipped and now **drifts, double-fires, races, or plateaus** at one model's per-step ceiling — capability is fine, but it isn't dependable enough to keep users.
- You need **95%-reliable beating 70%-capable**: users leave after two failures, so you'd trade raw capability for dependability (Amjad Masad, Replit, "The Future of Software Creation").
- You're chaining a **supervisor/specialist constellation** to compound past what one model does in a single pass, or wiring **durable execution, failover, budgets, or fan-out** at scale.
- A **weird failure** just happened and you want it to become a permanent regression case, not a one-off patch.
- You're reviewing a durable/concurrent AI system for the **state-corruption landmines at the seams** (async re-fires a non-idempotent call, two logs disagree on resume, `MAX(seq)+1` races, TOCTOU on the budget, a reask rewrites a destructive call).

Skip it when: you're rooting out **one specific bug's cause** — that's `compound-v:systematic-debugging` (this skill is the system-level *reflex* and the recurring seam-landmines, not a single trace); the worry is **adversarial/untrusted input** rather than correctness — that's `compound-v:agent-security`; or you're still deciding the **shape** of the system around the model — that's the sibling `compound-v:architecting-ai-systems`, which commits the shape this skill then keeps from corrupting itself.

This skill is **system-level**. For PER-STEP reliability inside one loop (the 0.9^n compounding, verify-each-step, don't-trust-CoT, bound-the-loop), that all lives in `compound-v:designing-agents` — keep the line sharp and don't restate it here.

## Reliability is the product: chain past the per-model ceiling

A single frontier model has a fixed per-step ceiling; you raise the *system's* ceiling by chaining roles, not by waiting for a better model. The default architecture, from teams running customer-facing agents in production:

1. **Self-error-detection.** Models catch their own mistakes more reliably than they avoid making them — so add a check after the act, not just a better prompt before it.
2. **Supervisor / specialist constellation.** A primary model is supervised by specialist models, with human escalation as the last rung. Sierra runs self-error-detection → supervisor chain; Hippocratic AI runs a "constellation" — a primary model watched by specialist models plus human escalation — precisely because one model can't be trusted alone in a high-stakes domain (Clay Bavor, Sierra, "Making Customer-Facing AI Agents Delightful"; Munjal Shah, Hippocratic AI, "Building the First Safety-First LLM for Healthcare").
3. **Simulator-as-regression.** Every fix becomes a permanent regression case via a conversation simulator — the failure you just fixed can never silently return. This *feeds* your eval suite: **REQUIRED:** use `compound-v:evals` to turn the captured failure into a judge/eval case — that skill owns judge construction and align-to-human; here you only generate the case.

Constellation topology has a default too: **parallelize the reading/searching/analysis, keep every write single-threaded.** Two agents writing the same state concurrently is a merge conflict you chose to create; multi-agent should *add intelligence* (a review or supervisor loop), not add parallel writers (Walden Yan, Cognition, "Don't Build Multi-Agents"; Anthropic, "How We Built Our Multi-Agent Research System"). **REQUIRED:** for the fan-out mechanics use `compound-v:dispatching-parallel-agents`.

For a **long-horizon agent spanning many context windows**, durable resume is also a harness contract, not just an engine checkpoint: each session begins with no memory, so end every session in a clean, mergeable state with structured handoff artifacts (a progress log, descriptive commits, a spec checklist), and start the next by reading them and running a basic end-to-end check *before* building more. Skip this and a later session looks around, sees that progress was made, and declares the job done — the silent failure.

## The failure reflex: make the missing capability enforceable

When the system fails, the wrong response is "tell the model to try harder." The right one is a reflex: **ask which capability the agent lacked, then make the fix enforceable in the harness** so that class of failure is structurally prevented, never re-explained. This is how a team ships 1M+ LOC with zero pre-merge-reviewed human code — every failure becomes a constraint the harness enforces, not a note in a runbook (Ryan Lopopolo, OpenAI Frontier, "Extreme Harness Engineering"; "Harness engineering: leveraging Codex in an agent-first world").

Two operational levers carry the reflex day to day:

- **Reinforce the objective on every tool return**, not once up front — stated once, the goal decays out of attention as the trace grows; restated on each tool result (current goal, status, what just failed), it stays live (Armin Ronacher, "Agent Design Is Still Hard").
- **Isolate failure-prone work in throwaway sub-agents** that report only the outcome, so a noisy or failing attempt can't pollute the main context (Ronacher, same). **REQUIRED:** the firewall mechanism — what crosses the boundary, what stays — is `compound-v:context-engineering`; reference it, don't re-teach it.

And treat every weird failure as a **research lead, not a bug ticket** — nets and agents fail *silently* by default, so the build loop has to be instrumented to surface and explain anomalies, not just pass when nothing visibly throws (Sholto Douglas & Trenton Bricken on Dwarkesh Patel; Andrej Karpathy, "A Recipe for Training Neural Networks").

## The serving/inference system is a reliability moat

At scale the durable edge is the serving stack itself, not the weights: native low-precision training to kill train/serve mismatch, attention/KV-cache engineering for order-of-magnitude memory cuts, and stateful prefix caching. Character.AI's stack (int8-native training, multi-query/hybrid attention, cross-layer KV-sharing for 20x+ KV-cache reduction, a 95%-hit prefix cache cutting serving cost ~33x) is the proof that correctness-and-cost of serving is where the moat lives (Character.AI engineering, "Optimizing AI Inference at Character.AI"). Its correctness half is unforgiving: serving one model across heterogeneous backends demands strict implementation equivalence, and a violation degrades output almost invisibly — a real run of inference bugs evaded standard evals precisely because the model recovers well from isolated mistakes, so the fix is to run quality evals *continuously on true production traffic*, not just pre-deploy. Note this is the *reliability/durability* angle on serving; the **KV-cache mechanics** themselves belong to `compound-v:context-engineering`.

## Correctness invariants that prevent silent drift

These are the default contracts a reliable AI system holds at its seams. They aren't all-caps rules; each one closes a specific silent-failure path (verified in the Verso agent framework, LeventySeven):

- **Errors are data, not exceptions.** A tool may `raise` freely; the framework catches it and feeds back a typed `{ok, data, error}` envelope as a model-legible observation. An exception that reaches the loop crashes a run the model could have self-corrected from.
- **Terminate on a named `StopReason`, never by sniffing text.** "Done" is a structured tool call (`done(result)`) and an enum (`END_TURN / DONE / MAX_STEPS / ERROR`), so why-a-run-ended is programmatic. Matching the string "done" in prose is a whole class of false stops.
- **Compaction masks, never silently truncates.** Overflow replaces *old tool outputs* with a placeholder while keeping all reasoning/user/assistant turns and the message structure — lossy truncation hands the next window a hole it hallucinates over. This is the correctness invariant only; the **compaction ladder mechanics** are `compound-v:context-engineering`.
- **Classify failures, then retry-same vs failover-to-different on the right axis.** Map each provider exception to a `FailureKind`: transient/rate-limit → retry the *same* candidate with capped backoff + jitter; context-window error → fail *over* to a different model; auth/content-policy → raise immediately (blind retry is harmful). Same-model retry just repeats a deterministic failure — a different model is a new experiment.
- **A fallback that silently drops `tools` is a correctness bug.** The dangerous failover is a provider that *accepts* the request but ignores the `tools` field, returns prose instead of a tool call, and breaks the loop with no error. Guard it at construction (`require_parameters` rejecting any candidate that can't use tools), not at runtime.

## The seam landmines: where durable AI state actually corrupts

These recurred across subsystems in an adversarial pass that verified each against a freshly-cloned upstream system (DBOS, Google AX, Instructor, Tower, Helicone, Verso failures corpus, LeventySeven). They are the concrete teeth of the failure reflex — the seam between two correct-in-isolation subsystems is where the bug lives.

- **Async-default re-fires a non-idempotent step on crash** *(the worked example below — the default everyone copies and the one that corrupts state silently)*.
- **Two co-authoritative logs disagree on resume.** Using *both* an event log (replay-to-messages) and a step-memo journal as jointly authoritative means a crash between the synchronous append and the async memo-write leaves them disagreeing; resume double-writes a `tool_result`. Pick *one* source of truth — replay the event log alone (AX-style) or resume from the memo map alone (DBOS-style); don't stitch two correct models without a reconciliation step.
- **App-level `MAX(seq)+1` races under concurrent append.** A sequence-allocation pattern copied from a single-writer system (SQLite serializes writes) into a concurrent one (Postgres) lets two appenders read the same MAX and collide; `ON CONFLICT DO NOTHING` then silently drops an event. Never allocate ordering in app code — use a DB-native `IDENTITY`/`SEQUENCE`/`INSERT ... RETURNING`. Port the *guarantee*, not the line.
- **Crash-resume re-fires a non-idempotent external write.** The transaction-piggyback trick gives exactly-once only for tools touching the *same* DB; Stripe/email/GitHub have no shared transaction, so a crash in the gap between "side effect fired" and "checkpoint written" double-fires them. The honest contract for external effects is **at-most-once with idempotency keys**, surfaced as a constraint, not buried.
- **Reask rewrites the whole tool call.** A structured-output reask loop sitting *before* tool dispatch regenerates the *entire* call on a validation failure — recipient, body, amount can all change, not just the missing field — and it looks valid. Propagate tool idempotency metadata into the parser: default `allow_reask=False` / `on_fail=EXCEPTION` when the tool is non-idempotent or destructive.
- **Multi-attempt cost isn't charged to the budget.** A reask loop fires N model calls but charges only the final call's usage, so the budget cap is breached silently with no `budget_exhausted` event. The retry *loop* owns the aggregate charge — sum usage across all attempts.
- **TOCTOU on the budget.** `admit()` reads spend and checks `spent + charge <= limit`; `charge()` runs later. Two concurrent runs both pass `admit()` before either charges — overspend by a full call. The GIL protects a single dict write, not the read-check-increment. Make admit-and-charge atomic (per-key `asyncio.Lock`, or a single Redis `INCRBYFLOAT`); don't defer it to the "scaled" backend.
- **`threading.Lock` in asyncio.** A blocking OS mutex ported into an event loop stalls *every* coroutine on each read/write of shared state — serializing the I/O the component existed to spread. Use `asyncio.Lock` + `async with`; when porting across concurrency models, translate the synchronization primitive, not just the algorithm.
- **A workaround that masks, not fixes, a deeper bug.** A defensive patch over a symptom can hide a worse latent failure that only surfaces when the patch is removed — a top-k workaround once inadvertently masked a deeper miscompile, so removing it after a believed root-cause fix exposed a far harder, configuration-dependent corruption. When you delete a workaround, re-verify the original symptom is gone *for the reason you think*, not merely absent.
- **TTFB-not-wall-clock as the health signal.** A load-balancer fed full stream-completion time demotes a provider that streams a long, *correct* reasoning trace — routing *away* from the provider doing the most work. For a stream consumer the health signal is time-to-first-token; re-derive what a copied metric *means* in your position (consumer vs proxy) before adopting it.

A note on reward loops: if your reliability strategy includes a verifiable-reward or self-improving loop, **reward hacking is a default failure mode of any proxy reward** — the model will exploit the metric (e.g. emitting broken tool calls to dodge a negative signal). Design against it before you trust the loop (Lilian Weng, "Reward Hacking in Reinforcement Learning").

## Worked example — the async-default re-fire

You ship a durable agent. To make checkpoints fast, the default checkpoint mode is **async**: the step completes, then a background task writes the checkpoint. A crash lands in the gap between step-completion and that background write.

On resume, the engine re-fires the step — and here is the corruption, not a clean retry:

- **The LLM call is not idempotent.** A non-deterministic model returns a *different* result the second time, so the event log now holds **two divergent records for one logical step**. The state isn't retried, it's forked.
- **A non-idempotent tool fires twice.** If that step sent an email or charged a card, the user gets two. No error is thrown; the system looks healthy.

The fix is the failure reflex, made enforceable in the harness: **flip the default to sync — write-before-advance.** Async becomes an explicit per-step opt-in, and `@tool(destructive=True)` auto-forces sync regardless. The reason it's safe to make sync the default is economic: the latency win is invisible at agent timescales (a ~1ms checkpoint write against a >100ms LLM call), while the corruption cost is real and silent. Three independent critics found this same default unsafe (verified against DBOS, LangGraph's `Durability` literal, and AX's two-log model; Verso failures corpus, LeventySeven).

The general lesson the example teaches: at every seam where a side effect and a checkpoint aren't in one transaction, the *safe default* is the slow-but-correct one, and "fast" is an opt-in a destructive tool can override. Most state corruption in durable AI systems is one of these unsafe defaults copied from a system with a different concurrency model.

## Red flags

| Symptom | The actual problem |
| --- | --- |
| "We'll fix reliability when the model gets better" | You raise the *system's* ceiling by chaining a constellation, not by waiting — 95%-reliable beats 70%-capable. |
| Response to a failure is "make the prompt try harder" | Skipping the failure reflex. Ask which capability was missing and make the fix enforceable in the harness. |
| Fast/async durability is the default | A crash re-fires a non-idempotent LLM call or tool — divergent log, double side effect. Sync by default; async opt-in; destructive forces sync. |
| Both an event log and a memo journal are authoritative on resume | Two correct models stitched without reconciliation disagree on crash. Pick one source of truth. |
| `MAX(seq)+1` / app-level ordering under concurrent writers | Single-writer pattern in a concurrent system. Allocate ordering in the DB, not app code. |
| A reask loop sits before dispatch on a destructive tool | It silently rewrites recipient/amount, not just the bad field. No reask on non-idempotent/destructive calls. |
| Budget checked in one step, charged in another | TOCTOU — two concurrent runs both pass admit. Make admit-and-charge atomic. |
| `threading.Lock` inside async code | Blocking mutex stalls the whole event loop. Use `asyncio.Lock`. |
| Load-balancer routes on wall-clock completion time | Demotes the provider doing the most (correct) work. Route on TTFB for a stream consumer. |
| A tool exception crashes the run | Errors should be data — return `{ok, data, error}` the model can self-correct from. |
