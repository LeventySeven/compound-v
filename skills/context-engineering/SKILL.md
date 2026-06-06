---
name: context-engineering
description: Curate the smallest high-signal token set for an agent or long task — manage context rot, retrieval, compaction, and KV-cache. Use when context is filling up, a long-running task spans many turns, you're designing an agent harness or system prompt, deciding what to load vs. retrieve, or the agent is "getting dumber," slower, or more expensive as the session grows.
---

# Context Engineering

Context is a finite resource with diminishing returns. The goal is **the smallest set of high-signal tokens that maximizes the desired outcome** — not the shortest context, the *highest-signal* one. Minimal does not mean short: you still give the agent everything it genuinely needs. You just stop paying for tokens that don't change the answer.

## When to use

- Context is filling up — the working window is past ~40% and growing, or you're seeing the agent repeat itself, lose earlier decisions, or slow down.
- A task spans more turns than fit in one window (multi-file refactor, research, long debugging session).
- You're designing an agent harness, a sub-agent, or a system prompt and deciding what goes in.
- You're choosing between pre-loading data and retrieving it on demand.
- Cost is climbing and you suspect cache misses.

Skip it for a short, single-shot task that comfortably fits — context engineering is overhead, and a one-pass answer doesn't need it.

## Why context degrades: rot and the attention budget

As tokens grow, the model's ability to **accurately recall** any one fact *decreases*. The cause is architectural: attention scales as n² pairwise relationships across n tokens, so a fixed attention budget spreads thinner with every token you add. This is a gradient, not a cliff — but it means a bloated context is actively *worse* at the task, not just more expensive. Recall measurably degrades as the window fills — Chroma's *Context Rot* benchmark shows loss even on a trivial retrieval task, ~40% down by ~170K tokens on some tasks (and far sooner with low-signal filler).

The practical consequence: every token you add spends from a shared budget. Spend it on signal.

The flip side: context is also a **capability lever**, not only a cost. Loading the *right* large body of context — a whole codebase, a domain corpus — can make the model dramatically better at the task, comparable to a jump in model scale, because it's learning in-context. So the goal isn't "less," it's *all signal, no noise*: pay for the tokens that buy capability, cut the ones that don't.

## Just-in-time retrieval beats pre-loading

Don't dump everything the agent *might* need into the prompt. Keep **lightweight identifiers** — file paths, queries, URLs, IDs — and load the actual content at runtime with tools. This mirrors how people work: you don't memorize the filesystem, you `ls` and `grep` when you need to. It also enables progressive disclosure — the agent discovers what's relevant by exploring, instead of drowning in an exhaustive dump that's mostly irrelevant to *this* question.

The honest tradeoff: runtime exploration is slower than reading pre-computed data, and a poorly-equipped agent can waste context chasing dead ends. So use a **hybrid** when up-front data buys real speed. Claude Code is the canonical example: it naively drops `CLAUDE.md` into context up front (small, always relevant) while using `glob`/`grep` for everything else just-in-time. The rule is **do the simplest thing that works** — pre-load the small, always-needed stuff; retrieve the rest.

## Order context by volatility (static prefix → dynamic boundary)

Lay out context so the **stable parts come first and the volatile parts come last**, split by an explicit boundary. Everything before the boundary is byte-identical across requests and can be served from cache; everything after changes per turn and can't.

- **Static prefix (cacheable):** base instructions, tool descriptions, the verification checklist, durable conventions. No timestamps, no per-request data — anything dynamic here silently breaks the cache for the whole prefix.
- **Dynamic suffix (not cached):** cwd/OS, today's date, git status, the live conversation, retrieved files.

Claude Code does this literally, splitting its system prompt on a `__SYSTEM_PROMPT_DYNAMIC_BOUNDARY__` sentinel — blocks before it are eligible for cross-session caching, blocks after are not. Putting the always-useful stuff (like the verification checklist) in the static prefix means it's present at *zero marginal cost* every turn.

## The compaction ladder (climb only as far as you need)

When context grows, apply the cheapest effective lever first. Don't summarize the whole transcript when only tool outputs are fat.

1. **Observation masking — do this first; it's strictly better.** Keep the full history of *actions and reasoning*, but replace older *observations* (tool outputs) with placeholders, retaining only the most recent ~10 turns of full observations. Measured result: **52% cheaper with a +2.6% solve-rate improvement** — not a tradeoff, a free win. Old tool outputs are rarely re-read, but old reasoning still informs current decisions. This is the highest-ROI single knob there is.
2. **Tool-result clearing — free and mechanical.** Replace consumed `tool_result` bytes with a literal marker like `"[cleared to save context]"`, while **keeping the `tool_use` record** so the agent still knows *what action it took*. Zero inference cost — it's a string swap, not a model call. In practice this alone took one workload from 335K peak tokens to 173K.
3. **Summarizing compaction — costs one model call, so do it later.** Near the window limit, summarize the conversation and reinitialize with the summary. Preserve **architectural decisions, unresolved bugs, and implementation details**; discard redundant tool chatter. Tune by **maximizing recall first, then precision**. A workable stacked recipe: clear tool-uses at ~50K input tokens (keep the 6 most recent, never clear memory results), compact at ~180K.
4. **Carry critical state deterministically — never trust the summary to hold it.** A summary is prose; it will drop things. Keep a `NOTES.md` / `todo.md` / progress file *outside* the context, and re-read it after a reset. Structured state (the plan, TODOs, open questions, hard constraints) must be carried by code, not entrusted to summary prose — full rewrites of a memory doc corrupt unrelated fields, so prefer targeted updates.

A useful side effect: re-injecting the plan/TODOs at the *recent end* of context counteracts lost-in-the-middle — the model's attention is strongest at the edges, so the current objective belongs there.

## KV-cache discipline (where the cost actually is)

Agent traffic runs roughly **100:1 input-to-output tokens**, so the input cache matters ~100× more than output length. Cached input can be ~10× cheaper than uncached. To keep the cache warm:

- **Static prefix** — no timestamps or dynamic content in the cached region (see volatility ordering above).
- **Append-only context** — never edit or reorder a previous turn; any change downstream of a cached span invalidates it. Add, don't rewrite.
- **Deterministic serialization** — sorted JSON keys, stable formatting, so prefixes are byte-identical request to request.
- **To disable a tool, mask its logits — don't remove it from the tool list.** Removing a tool changes the prefix and busts the cache for everything after it. Keep the tool list constant; suppress unwanted tools at decode time.

## Sub-agents are context firewalls

A sub-agent runs in its own window and returns **only its final summary** — all its intermediate reads, searches, and tool spew stay isolated and never touch the parent's context. So delegate the token-heavy, noisy work (deep exploration, large searches, browser sessions) to a sub-agent and get back a distilled ~1–2K-token digest.

The discipline that makes this work: **findings cross the boundary, raw documents do not.** The parent holds the high-level plan and synthesizes; sub-agents do the messy gathering. (For *when* to fan out vs. stay single-threaded, use compound-v:dispatching-parallel-agents — over-spawning has its own context cost.)

## Right-altitude system prompts

When you do put instructions up front, aim between two failure modes: too *brittle* (hardcoded if-else logic that overfits and rots) and too *vague* (high-level prose that assumes shared context the model doesn't have). Strike specific-enough-to-guide yet flexible-enough-to-give-strong-heuristics. Delineate sections with Markdown headers or XML tags. Start from a minimal prompt on the best model, then add instructions and examples to fix observed failure modes — don't pre-write guards for problems you haven't seen.

## Encode what transfers across models; defer what scale washes away

The harness is the durable asset; the model is swappable — so spend effort on what *survives* a model upgrade and let the model handle what it'll soon do unaided. **Encode** the things that transfer across generations: verifiable environments and checks, the plan/state/conventions, agent-addressable structure, and representations that turn a fuzzy task into one the model is already strong at. The sharpest version of that last one: **make a non-coding task look like a coding task** — hand the agent files plus `bash`/`grep` over prose-described data instead of a bespoke tool-for-every-step, because coding-agent training generalizes to anything shaped like filesystem ops. **Don't encode** elaborate cognitive scaffolds, role-play personas, or hand-built planners that the next model will simply absorb — that work gets washed away. The test when unsure whether to build a mechanism: would it still earn its place against a clearly smarter model? If no, defer it.

## The quick checklist

- Target the smallest high-signal set; cut tokens that don't change the outcome.
- Keep working context under ~40%; when it climbs, climb the compaction ladder (mask → clear → compact), cheapest first.
- Retrieve just-in-time via lightweight identifiers; pre-load only the small, always-needed stuff.
- Order by volatility: static cacheable prefix, dynamic suffix, explicit boundary.
- Keep the cached prefix static, the context append-only, serialization deterministic; mask tools, don't delete them.
- Carry the plan/state in an external file, not in summary prose; recite it at the recent end of context.
- Push noisy, token-heavy work into sub-agents that return only findings.
- Hard-code only what survives a model upgrade (verifiable checks, state, structure); let the model handle what scale will soon do unaided.
