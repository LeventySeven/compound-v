---
name: architecting-ai-systems
description: Design the architecture of a system around a frontier model — harness thickness, the one hard primitive to build, the retrieval shape, whether to build a reward-generating environment, what to delete on the next model release. Opt-in (manual): invoke only when the user explicitly asks to design or architect an AI system or product — e.g. "help me design the AI architecture for my project", "wrapper or primitive?", "how should I build the system around the model" — or names this skill. Do not auto-trigger on incidental "make it smarter" mentions; this is a deliberate deep-dive the user reaches for.
---

# Architecting AI Systems

Architect the compound system AROUND a frontier model so the harness — not the swappable model — is your durable edge, and resolve how-thick-a-harness by building for the capability roughly 18 months out, not today's.

The model is a component you rent and will swap. What you engineer around it — the retrieval, the validators, the environment, the one hard primitive — is what compounds across model generations and what a funded competitor needs months to rebuild. Get the shape right and a better base model *helps* you; get it wrong and the next release deletes you.

## When to use

- You've decided to build (startup-taste said go) and now you're choosing the system shape: one thin call vs. a thick compound, wrapper vs. primitive.
- You're picking the one hard primitive to build — a sync engine, a retrieval+synthesis pipeline, a reward-generating environment — and letting the product fall out of it.
- You're choosing a retrieval architecture and someone reflexively said "vector RAG."
- You're deciding what plumbing to throw away on the next model release, or whether the harness you have is now the ceiling.
- The question is "what do we build around the model" or "will the next model help me or delete me" — that's this skill even when nobody says "architecture."

**Skip it when** the decision is the agent's *internal* shape (loop / tools / sub-agents → **REQUIRED:** use compound-v:designing-agents), its *token budget* (KV-cache, compaction, JIT-vs-preload → **REQUIRED:** use compound-v:context-engineering), or the *build/no-build verdict itself* (**REQUIRED:** use compound-v:startup-taste — it owns the wrapper test, primitive-in-one-sentence, own-your-ceiling, and verifier-first gates; come here for the buildable HOW once it says build). Once the architecture is committed and the running system starts drifting, double-firing, or racing, that's the sibling **REQUIRED:** use compound-v:ai-system-reliability.

## The default: a thick compound harness, sized to 18 months out

The reflex split is wrong on both ends. A **thin wrapper** (paste context, call model, return) gives the model no edge a competitor can't clone in a weekend, and a base-model upgrade deletes you. **Training your own foundation model** burns your iteration speed and the next frontier release laps you anyway. The middle path wins: engineer a **composite architecture around a frontier model** — context injection, validators, error recovery, a fine-tuned fixer for the last mile — and let the model stay swappable underneath (Malte Ubl, Vercel, "Lessons from building v0 and the d0 agent"; the compound-system thesis, Zaharia/Frankle et al., "The Shift from Models to Compound AI Systems," BAIR 2024).

How thick is the live tension, and it has one resolver. **Build for the capability ~18 months out, not today's.** AI task horizon — the length of task a model finishes autonomously at >50% — is doubling roughly every seven months (METR, "Measuring AI Ability to Complete Long Tasks," arXiv 2503.14499). So the workflow that's *almost* working today is exactly the one to architect around now, because the infra, evals, and domain context can't be built overnight; waiting until it works means a competitor already built them. The corollary tells you what to make *thin*: any layer the next model will simply absorb is a layer you shouldn't pour concrete into. Build the durable scaffolding (verifiable environments, retrieval, state, conventions); skip the elaborate cognitive scaffolds and role-play planners scale will wash away.

## Build the one hard primitive; the product is its consequence

Don't build "a product." Build the **one hard primitive** and let the product fall out of it — Linear built a sync engine, Perplexity a retrieval+synthesis pipeline, Cursor speculative editing, each before any UI (Tuomas Artman, "Linear's sync engine"; Aravind Srinivas, Perplexity, YC "How To Build The Future"). The disqualifying test: **if you can't state the primitive in one sentence, you don't have one yet** ("the search result, from links to a cited answer").

And **own the layer that sets your quality ceiling.** If your core primitive runs on a third-party service, that service decides how good you're allowed to be — delete the dependency on paper, and if your value prop dies, you don't control your destiny. Perplexity hit the ceiling of a search API and built its own ~200B-URL index (near-zero URL overlap with competitors on the same queries); Cursor forked the editor because the extension API made speculative editing impossible (Michael Truell, "Building Cursor"). Spend your **innovation tokens** here and only here — you get roughly three novel-tech bets before operational complexity sinks you, so the AI primitive is the novel part and everything around it is boring, well-understood tech (Dan McKinley, "Choose Boring Technology").

## Which retrieval primitive — vector RAG is usually the wrong shape

When the system needs retrieval, the reflex "bolt on a vector DB" conflates document-filtering with passage-relevance and collapses multi-hop reasoning into one cosine score. Pick the shape from the task:

- **High-stakes / multi-hop:** run parallel model passes that decide what deserves attention, then synthesize and reverse-engineer citations — not one similarity score (Hebbia, "Goodbye, RAG").
- **Web-scale search:** link-prediction-as-pretraining plus a custom vector store that filters at scale (Will Bryk, Exa, "Beating Google at Search with Neural PageRank").
- **Enterprise search:** real-time, permission-aware per-person personalization over a people/role/doc knowledge graph (Arvind Jain, Glean, "How Glean Solved the Enterprise Search Problem").

This is the architecture *choice*. The token mechanics underneath it — JIT-vs-preload, cache, compaction — are **REQUIRED:** use compound-v:context-engineering, and before you write the retrieval code, **REQUIRED:** use compound-v:searching-patterns to look up how it's actually built.

## When the primitive is a reward-generating environment

Sometimes the right thing to build around the model is not a pipeline but an **environment that generates a verifiable reward**. Where a solution can be auto-checked — code compiles, math checks, "did the reply book the meeting" — RL goes vertical, and quality of the signal beats quantity of data (the bitter-lesson maxim: a few thousand verifiable examples beat millions of low-quality RLHF ones). The engineering order is **build the verifier first**, because the system's ceiling is set by whether reward can be auto-checked at all (Jason Wei, "Asymmetry of Verification and Verifier's Law").

Two disciplines make this hold. **Incentivize, don't teach** — design the reward surface and let scale surface the capability rather than scripting the procedure step by step; this is the mental model behind o1 and R1 (Hyung Won Chung, "Don't Teach. Incentivize."). And the real unlock for long autonomous runs is the **realistic environment that harvests real-world signal as reward**, not better prompts: serve checkpoints to production and harvest accept/reject (OpenAI Codex, "From Coding Autocomplete to Autonomous Agents"; Cursor, "Improving Composer through real-time RL"). The named failure mode is **reward-hacking** — the model games the proxy (emitting broken tool calls to dodge a negative signal). Design against it before you ship the loop (Lilian Weng, "Reward Hacking in Reinforcement Learning"). To build and align the verifier/judge itself, **REQUIRED:** use compound-v:evals — say "then build the verifier" and point there; don't re-teach judge construction.

## Worked example — v0: four composite layers, no model swap

The reflex for "build a great code-generation product" is either a thin wrapper on the best model or "we'll train our own." Vercel's v0 did neither. Starting from a Claude Sonnet baseline, they engineered a composite architecture around the *same* model and drove error-free generation up by a ~30-point jump with zero model training, no model swap (Malte Ubl, Vercel CTO, "Lessons from building v0 and the d0 agent"; Guillermo Rauch, "Building the Generative Web with AI"). The four layers, each one the harness doing work the model couldn't:

1. **RAG context injection** — pull the right framework/API context in at generation time so the model isn't guessing.
2. **Stream-time fixing** — repair errors as the output streams, before they reach the user.
3. **Deterministic AST / icon validation** — a non-model check that catches structural mistakes a model won't reliably self-catch.
4. **A fine-tuned AutoFixer** — a small specialized model for the last-mile failures the frontier model leaves behind.

The lesson is the whole skill in one case: the **harness, not the model, was the moat**. Every layer survives a frontier model upgrade — a better Sonnet makes all four *better*, not obsolete — which is exactly the test for whether you built a primitive or a wrapper (Anthropic Applied AI, "Effective harnesses for long-running agents" — same model plus a better harness moved Opus 4.5 from 50.2% to 55.4% on SWE-bench Pro via context management and tool orchestration alone).

## What to make thin, and what to delete each release

Hold the counterweight, because the same thesis that says "build the harness" says "don't over-build it." A too-thick harness becomes the *ceiling* — over-built plumbing caps a smarter model's overhang, and hand-crafted abstractions get erased the moment a better model lands (the Bitter Lesson, Richard Sutton — don't build the edge more compute will delete; applied to agent frameworks by Gregor Zunic, browser-use, "The Bitter Lesson of Agent Frameworks": ~99% of the value lives in the RL'd model). So:

- **Keep the harness model-forward and mostly self-written**, and **delete scaffolding on every model release** — the "product overhang" is when the capability already existed and only your scaffolding didn't (Boris Cherny, Anthropic, "Building Claude Code"). The frontier framing is the same shift from predefined scaffolds to reasoning-model-led workflows — the harness becomes the box and the model chooses how to proceed inside it. Prefer one universal interface (Bash) over dozens of bespoke tools, and **start from maximal capability and restrict, not the reverse**: a too-thick harness fails not because the model is weak but because the action space you handed it is incomplete, so it can't route around a broken path.
- **Code-over-tools:** give the agent a sandbox and let it call tools as code rather than exposing every tool as a direct call — measured ~98% token reduction on a realistic workflow (Anthropic, "Code Execution with MCP").
- **Keep intelligence in a model-agnostic harness, not fine-tuned weights** — spend millions fine-tuning and the next base release erases the edge; compound systems are "vaccinated against the Bitter Lesson" (Zaharia/Frankle et al., BAIR). The clean expression of the seam: the provider is **one thin Protocol** (`complete(messages, tools, *, system) -> response`) and the app layer sits above it, so swapping a model is a one-line change, never a rewrite (the LLM-OS / thin-provider-abstraction pattern; cf. LiteLLM's provider config).
- **Build the non-composable core; compose proven engines; defer owned ones.** Build only the irreducible primitive (the loop, the context bundle, the one coercion engine you genuinely can't buy); *compose* solved problems (durability, memory, evals) behind interfaces you lock now; and *defer* owning an engine until dogfood proves the gap. Resolving the final form of eight engines on paper before anything runs is the over-engineering this skill exists to prevent — the tactical↔durable seam (same loop, one `durable=True` flag) lets the tactical parts stay simple and the durable parts get durable without a rewrite.

## Red flags

| Symptom | The actual problem |
| --- | --- |
| Swap the model in your head and the product is basically the same | You built a wrapper. A base-model upgrade deletes you, not helps you. Find the primitive. (You skipped the go/no-go gate: **REQUIRED:** use compound-v:startup-taste.) |
| Can't state the core primitive in one sentence | You don't have a primitive yet — you have a feature on top of someone's API. (You skipped the go/no-go gate: **REQUIRED:** use compound-v:startup-taste.) |
| "We'll fine-tune / train our own model" before the harness exists | Burns iteration speed; the next frontier release laps you. Build the composite around a frontier model. |
| Reflexively reaching for vector RAG | Conflates filtering with relevance, flattens multi-hop. Pick the retrieval shape from the task. |
| Building an RL loop before the verifier exists | The verifier sets the ceiling and catches reward-hacking. Build it first. (You skipped the go/no-go gate: **REQUIRED:** use compound-v:startup-taste.) |
| Architecting only for what the model can do *today* | You'll have rebuilt it before launch. Size the harness to ~18 months out (METR doubling ~7mo). |
| A thick hand-built scaffold the next model will absorb | That layer is now your ceiling. Keep the harness thin and model-forward; delete it each release. |
| Core primitive runs on a third-party service | That service caps your quality. Own the layer that sets your ceiling, or you don't control your destiny. (You skipped the go/no-go gate: **REQUIRED:** use compound-v:startup-taste.) |
