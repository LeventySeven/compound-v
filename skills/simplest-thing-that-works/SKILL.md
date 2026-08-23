---
name: simplest-thing-that-works
description: Pick the mechanism a goal actually needs — anywhere from a rule or a SQL query up to a full multi-agent system — capping the machinery without capping the goal. Opt-in (manual): invoke when the user asks which mechanism to use or how simple the thing can be — "what's the simplest way to do this", "script, rule, one call, or agent?", "do we even need AI for this?", "am I over-engineering this?" — names this skill, or another Compound V skill hands off here; frame-the-goal routes here once "works" is a check. Do not auto-trigger.
---

# Simplest Thing That Works

For any goal, the right mechanism is the simplest one that **provably** passes its success check — and "simplest" means the simplest mechanism that *solves it*, which for a hard goal is a capable system, not a toy.

The default is the lowest rung that works, and the burden of proof sits on complexity: you climb a rung only when you can name a concrete case the cheaper rung fails. This isn't a bias toward small — it's a bias toward *fit*. Under-building a hard goal is the same defect as over-building a trivial one; both ignore what "works" actually demands.

## When to use

- The goal is framed and you're choosing the mechanism: "what's the simplest way to do X", "script, rule, one call, or agent?"
- A plan smells heavy — multi-agent, a vector DB, a fine-tune — and nothing has yet proven the cheaper thing fails.
- A genuinely hard goal needs a *capable-but-minimal* system and you're guarding against both under- and over-building.
- Someone reached for AI reflexively and you haven't asked whether the goal needs a model at all.

**Skip it when** "works" isn't defined yet — you can't pick the simplest thing that *works* until "works" is a check (**REQUIRED:** use compound-v:frame-the-goal first). Skip the rung-by-rung walk when the mechanism is obvious and trivial (a one-line lookup needs no ladder). Sizing the *effort of the coding task* — not the mechanism for the goal — is the router's tier table (**REQUIRED:** use compound-v:using-compound-v).

## The mechanism ladder — default the lowest rung that works

Climb only when the rung below **provably** fails the check. Most goals stop far lower than the reflex picks.

1. **Existing tool / rule / lookup / SQL / regex** — a config change, a heuristic, a query. "No AI needed" is a common, correct answer.
2. **Deterministic code** — plain logic with no model in the path. Predictable, testable, free.
3. **One model call** — a single LLM call where genuine open-ended judgment is the irreducible core.
4. **Tool-augmented call** — one call plus tools/retrieval when the model needs facts or actions it can't hold.
5. **Workflow** — a fixed chain of steps (prompt-chaining, routing) when the task decomposes predictably.
6. **Agent** — a model in a loop with tools when the path can't be predicted in advance.
7. **Multi-agent / full AI system** — a constellation or compound system when one agent provably can't carry the goal.

**Who to model, and it is not the big-tech specialist.** The person whose judgment this skill is trying to borrow is the founder-CTO who scaled something and got out the other side — because they made every one of these calls under a deadline, with nobody to escalate to, on a system they also had to operate. That is a different intuition from deep expertise in one layer, and it is the one that transfers to a small team: they know which corners are load-bearing and which are decoration, because they have paid for both. An agent has read more code than any of them and has made none of those calls. The corpus is where that judgment comes from, and it arrives as **shapes and traps** rather than as a method — describe what a good answer looks like, do not script how to reach it.

**Climb to the top rungs for the moat, never for the plumbing.** Rungs 6–7 are where a product becomes hard to copy, so a genuinely novel capability is the right place to spend a multi-agent system. The same machinery around a job that could have been a query is just cost with a story attached. The test is whether the complexity is *the thing people would come for*; if not, it belongs lower.

**Two axes, and the ladder is only one of them.** The rungs answer *how much machinery*. They do not answer *what arrangement* — "a scheduled job reads a table and sends a message" is rung 2, and the rung number tells you nothing about the parts or their order. The arrangement is the **shape**, and a shape is only worth carrying paired with its **trap**: the second-order cost that is invisible on day one. That pairing is the whole transferable content of experience, and it is precisely what a coding agent lacks — it has read more code than any of us and has been burned by none of it. The curated shape table lives in **compound-v:searching-patterns**; reach for it before inventing an arrangement, and add to it only when a shape will recur.

**The three-way test — a mechanism has to pass all of it at once.** Dropping any one is the failure, and each has its own failure mode:

- **Simple** — you can hold it in your head and say it in a sentence. If explaining it needs a diagram, it is not the answer yet.
- **Effective** — it provably passes the goal's check on the real input distribution, not the demo slice.
- **Scalable** — the next 10× does not force a rewrite. This is the one that silently gets dropped, and it is why *simplest* is not *smallest*: the smallest thing that passes today is often the thing you throw away at the first order of magnitude.

Two rules make this honest:

- **The burden of proof is on the higher rung.** Find the simplest solution; add complexity only when it demonstrably improves outcomes — don't build agents for everything. This is the AI restatement of the XP rule: "do the simplest thing that could possibly work," plus YAGNI.
- **Never cap the goal — only the machinery.** A complex system that works grew from a simple system that worked (Gall's Law), so for a hard goal you climb *because the goal forces it*, then keep every rung you don't need off the build. Anti-underkill needs its own test, or the burden of proof only ever runs downward: **measure the cheap rung on the real input distribution at real scale, not the demo slice.** Under-building rarely surfaces as a visible failure — it surfaces as accuracy that decays as inputs grow, while the small cases keep passing. One repo-level validator stripped back to a single well-prompted agent lost ~58% of its accuracy on average, worst on the largest codebases. When the goal genuinely demands rungs 6–7, build them — and stability scales up with them (**REQUIRED:** use compound-v:make-it-stable, and at full-system scale **REQUIRED:** use compound-v:ai-system-reliability).

**Rungs compose; you are not picking one.** Landing on a high rung does not retire the low ones — it makes them the cheapest way to shrink the high one's job. Run the deterministic part deterministically and hand the model only the slice that needs judgment: a repo-level code-translation validator computes six semantic analyses of source and target in a single one-shot call *before any agent is involved*, then passes that bundle down. Deleting only that pre-pass cost ~40% accuracy **and** ~4% more agent turns, ~6% more input tokens and ~7.5% more time. The cheap rung was not a fallback for the easy cases; it was the expensive rung's orientation, and it paid for itself on both accuracy and cost.

The single biggest cost lever is *which rung*, not micro-optimizing an expensive one — a goal solved by a SQL query costs nothing a tuned agent can match. Cost is a mechanism choice; once a rung is chosen, its token mechanics are **REQUIRED:** use compound-v:context-engineering.

**Why a default, not a rule:** the ladder is a strong prior, not a law. A model with good judgment should skip rungs when the goal obviously lands higher — you don't trial a regex for "resolve billing disputes end-to-end." The default exists to stop the *reflex* jump to complexity, not to force a literal climb through every rung.

## Routing into the AI specialists

Rungs 3–7 are AI features, and their internal shape is already owned. Once the goal lands on a model, the agent-vs-workflow choice and how-many-agents live in **REQUIRED:** use compound-v:designing-agents (this skill starts one rung *below* it — "does this need a model at all?" — and hands off). When the mechanism is a whole compound system around a model — harness thickness, the one hard primitive, which retrieval shape — that's **REQUIRED:** use compound-v:architecting-ai-systems. Before writing the unfamiliar mechanism, look up how it's actually built: **REQUIRED:** use compound-v:searching-patterns. And whether to build *at all* is upstream of mechanism entirely — **REQUIRED:** use compound-v:startup-taste owns that verdict.

## Worked example — "categorize incoming support emails"

The reflex answer is "fine-tune a classifier" or "build an agent." Walk the ladder against the framed check (correct category on a held-out set of real emails):

- **Rung 1 — rules.** A keyword/sender table ("refund/charge → Billing", "reset/login → Account") is tried first. In this scenario, assume it covers the large majority of routine traffic correctly (measure it on a held-out set to know). That tier ships today: zero model cost, fully deterministic, instantly debuggable. Climbing higher for that majority would be pure overkill — the cheaper rung did **not** provably fail it.
- **Rung 3 — one model call, for the tail only.** The minority the rules can't place (ambiguous, multi-topic) is the case that *proves* rung 1 fails. So only that slice escalates to a single classification call, with a check on its output. You did not replace the rules; you added one rung exactly where the lower one broke.
- **Rung 6 — agent, only if the goal grows.** If the goal were "categorize *and* draft a resolution that may need a refund lookup, a policy check, and a reply," that's a multi-step path you can't pre-script — now an agent legitimately earns its place, and you climb because *the goal forced it*, not for fun. At that point its loop/tool shape is compound-v:designing-agents and its reliability is compound-v:make-it-stable.

The whole skill in one line: the simplest thing that works for the bulk of traffic was *no AI*, for the tail was *one call*, and for the hard version was *an agent* — each rung chosen because the one below it provably couldn't carry that part of the goal, and not one rung higher.

## Red flags

| Symptom | The actual problem |
| --- | --- |
| Reached for an agent / vector DB / fine-tune before naming a case the simpler rung fails | Burden of proof is on complexity. Default the lowest rung; climb only on proof. |
| Picking the mechanism before "works" is a check | You can't pick the simplest thing that *works* yet. (compound-v:frame-the-goal first.) |
| Hard goal shaved down to a toy because "simplest" | Anti-underkill: simplest = simplest that *solves it*. Climb as high as the goal forces. |
| Optimizing the cost of an expensive rung instead of dropping a rung | The rung is the cost lever, not the micro-optimization. |
| Resolving agent/workflow/topology here | That's compound-v:designing-agents — this picks whether a model is needed at all. |
| Walking literally every rung for an obviously-high goal | The ladder is a prior, not a law. Skip to the rung the goal lands on. |
