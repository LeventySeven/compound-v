# Compound V — Sources

The grounding spine for the kit. Every load-bearing numeric/factual claim across the skills maps
here to a **public primary source** — a real URL — or is marked a judgment call that needs none.
This file is what makes the **"Grounded — if a claim isn't grounded, it says so"** non-negotiable
(`using-compound-v`, `README.md`) checkable. It also satisfies the format constitution's grounding
rule (`references/skill-format.md`).

## How to read this

Three categories, one per claim:

- **PRIMARY** — an empirical/factual claim attributed to a real-world result; a public primary
  source (URL) is given. This is the bar the kit holds itself to.
- **JUDGMENT-CALL / CANONICAL** — a UI/recipe constant or a well-known historical illustration that
  is vendor-neutral common knowledge or an internal recipe knob. **No citation needed** (e.g.
  `16px`, `0.96` press-scale, `200–300ms`, `N=3` cap, `<40%` context, the compaction-ladder
  thresholds). These ARE the skill, not claims about the world.
- **REMOVED / SOFTEN** — a claim that was wrong, unverified at its source, or being cut. Marked so it
  is not re-cited.

A `skill:line` column locates each claim in the shipped skill. Line numbers are approximate and drift
as skills are edited.

---

## recheck

| Claim (short) | skill:line | Category | Source / note |
|---|---|---|---|
| Cross-model reviewer closes **~74.7%** of a same-model quality gap | `recheck` | **REMOVED** | **Do not cite.** The "cross-model reviewer" section was cut: the decimal was unsourced and contradicts the all-Opus identity the README repeats. If ever re-added: one sentence, no decimal, with a real cite. |
| Reviewer must be **read-only** (the canonical safe reviewer mutates nothing) | `recheck:19` | PRIMARY | Convergent across production coding agents whose review/oracle paths are read-only by construction. Attribute as "production reviewers are read-only." Mechanism corroborated by Cognition (below). |
| Clean-context reviewer is *smarter* (attention math / Context Rot) and reasons backward from the diff | `recheck:19-21` | PRIMARY | Cognition, "Multi-Agents: What's Actually Working" — https://cognition.ai/blog/multi-agents-working. |
| Devin Review catches **avg 2 bugs/PR, ~58% severe** (logic/edge/security) | `recheck` (vuln-step) | PRIMARY | Cognition, "Multi-Agents: What's Actually Working" — https://cognition.ai/blog/multi-agents-working. The grounded replacement for the removed 74.7% line. |
| **N=3** fix↔recheck cap | `recheck:62` | PRIMARY (borderline recipe-knob) | Production agents converge on ~3 retries (CI-failure loops, lint-fix loops, retry caps). Owning skill is `systematic-debugging`; recheck cross-refs it. |
| Lethal trifecta = private data + untrusted content + exfiltration channel | `recheck:33` | PRIMARY | Simon Willison, "The lethal trifecta for AI agents" — https://simonwillison.net/2025/Jun/16/the-lethal-trifecta/. |
| Signal-density cap **~10-12 findings/pass**; **N=3** cycle cap | `recheck:58,62` | JUDGMENT-CALL | Recipe knobs (signal-density + convergence). No citation needed beyond the N=3 row above. |

---

## evals

| Claim (short) | skill:line | Category | Source / note |
|---|---|---|---|
| Mastra drove agent memory toward SOTA across LongMemEval | `evals:51` | PRIMARY | Mastra research page — https://mastra.ai/research/observational-memory. Correct facts: baseline **60.2%** (gpt-4o full-context), LongMemEval has **six** categories (single-session-user / -assistant / -preference, knowledge-update, temporal-reasoning, multi-session), SOTA **94.87%** (gpt-5-mini). Earlier "67% / five buckets / absence-awareness" was wrong — do not re-cite. |
| NurtureBoss: a few categories dominated; fixing the top one (date/scheduling) produced a large jump | `evals:33` | **SOFTEN (directional)** | The precise "3 issues = 60%+ / 33% → 95%" figures are not stated verbatim at the source; the public breakdown differs. Keep directional only. Candidate primary: Hamel Husain, "A Field Guide to Rapidly Improving AI Products" — https://hamel.dev/blog/posts/field-guide/. |
| Teams with a data viewer iterate dramatically faster | `evals:69` | **SOFTEN** | Hamel field-guide (https://hamel.dev/blog/posts/field-guide/) says "game-changer," not "10x." Keep directional. |
| Critiques as few-shot raise judge↔human agreement | `evals:42` | **SOFTEN (no exact decimal)** | Repeated across the Hamel/Shreya canon but no single page states a "15-20%" delta. Cite Hamel "Your AI Product Needs Evals" — https://hamel.dev/blog/posts/evals/ — and say "materially raises agreement." |
| CoCounsel ships at a very high pass bar | `evals:79` | **SOFTEN** | The "999/1000" figure could not be verified; keep directional. Source thread: Jake Heller, "Context Engineering: Lessons from Scaling CoCounsel" (YC talk). |
| CoCounsel: "evals are way easier when you can say `matches word X`" | `evals:22` | PRIMARY | Jake Heller, CoCounsel context-engineering talk (YC). |
| Error analysis is the #1-ROI activity; open-code → axial → count | `evals:24-35` | PRIMARY | Hamel Husain, "A Field Guide to Rapidly Improving AI Products" — https://hamel.dev/blog/posts/field-guide/. |
| Binary pass/fail not 1-5 Likert; align judge to human; **target >90%** agreement; P/R when imbalanced | `evals:41,44` | PRIMARY | Hamel "Your AI Product Needs Evals" — https://hamel.dev/blog/posts/evals/ + Shreya Shankar eval canon. |
| Read **30-100** traces; align on **25-50** examples; grow the set toward hundreds-to-1,000 | `evals:28,44,79` | JUDGMENT-CALL | Recipe knobs (sample sizes for the loop). Directionally from Hamel; the exact ranges are practitioner defaults. No citation needed. |
| Shipping an LLM feature with no eval = #1 cause of failed AI products | `evals:8` | PRIMARY | Hamel field-guide thesis — https://hamel.dev/blog/posts/field-guide/; restated as `startup-taste`'s verifier-first gate. |

---

## context-engineering

This is the kit's best-grounded skill — every load-bearing number was verified exact against its
public primary source.

| Claim (short) | skill:line | Category | Source / note |
|---|---|---|---|
| Token usage *alone* explains **~80%** of agent-performance variance (token + tool-call + model ≈ **95%**); multi-agent uses **~15×** more tokens than chat | `context-engineering:10` | PRIMARY | Anthropic, "How we built our multi-agent research system" — https://www.anthropic.com/engineering/multi-agent-research-system (verbatim: "token usage by itself explains 80% of the variance"; "three factors explained 95% of the performance variance"; "multi-agent systems use about 15× more tokens than chats"). |
| Observation masking: **52% cheaper, +2.6% solve-rate** | `context-engineering:47` | PRIMARY | arXiv 2508.21433, "The Complexity Trap" (JetBrains; NeurIPS 2025; Qwen3-Coder 480B) — https://arxiv.org/abs/2508.21433. |
| Masking is "as good as summarization at a fraction of the cost" (not "strictly better") | `context-engineering:47` | **SOFTEN (framing, not number)** | The source's thesis is masking is *as good as* summarization at a fraction of the cost ("matching, sometimes slightly exceeding"), NOT strictly better. The 52%/+2.6% numbers are correct; only a superlative would overstate. https://arxiv.org/abs/2508.21433. |
| Tool-result clearing took one workload **335K → 173K** peak tokens | `context-engineering:48` | PRIMARY | Anthropic Claude Cookbooks / API tool-use context-management (`clear_tool_uses_20250919`) — https://github.com/anthropics/claude-cookbooks. |
| Context Rot: recall **~40% down by ~170K tokens** on some tasks | `context-engineering:22` | PRIMARY | Chroma, "Context Rot" technical report — https://research.trychroma.com/context-rot (attributed inline in the skill). |
| Attention scales as **n²** pairwise relationships; "attention budget" | `context-engineering:22` | PRIMARY | Anthropic, "Effective context engineering for AI agents" — https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents (verbatim). |
| Agent traffic ~**100:1** input:output; cached input ~**10×** cheaper ($0.30 vs $3/MTok) | `context-engineering:56` | PRIMARY | Manus, "Context Engineering for AI Agents: Lessons from Building Manus" — https://manus.im/blog/Context-Engineering-for-AI-Agents-Lessons-from-Building-Manus (verbatim "around 100:1", "10x difference"). |
| Mask tool logits don't remove; append-only; deterministic JSON; todo.md recitation vs lost-in-the-middle | `context-engineering:50,52,59-61` | PRIMARY | Manus blog (all verbatim) — https://manus.im/blog/Context-Engineering-for-AI-Agents-Lessons-from-Building-Manus. |
| Sub-agent returns a distilled **~1–2K-token** digest | `context-engineering:65` | PRIMARY | Anthropic "Effective context engineering" (verbatim "often 1,000–2,000 tokens") — https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents. |
| Claude Code splits its prompt on a dynamic boundary; drops `CLAUDE.md` up front, glob/grep JIT | `context-engineering:32,41` | PRIMARY | Anthropic "Effective context engineering for AI agents" (Claude Code as the worked example) — https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents. |
| Working context **< 40%**; clear at ~50K, compact at ~180K; keep last **~10** turns / **6** recent tool-uses | `context-engineering:12,49,80` | JUDGMENT-CALL | Compaction-ladder recipe knobs (tuning defaults, not empirical claims). The optimal-window ≈ last 10 turns does trace to arXiv 2508.21433. No citation needed. |

---

## startup-taste

| Claim (short) | skill:line | Category | Source / note |
|---|---|---|---|
| Wrapper-class apps sit far lower on retention than category leaders | `startup-taste:39` | **SOFTEN (directional)** | Stated directionally in the skill (not a pinned figure). The earlier "60–85% vs ~14% DAU/MAU" decimals are not cited to a public source — keep directional. |
| Perplexity built its own index → near-zero URL overlap with competitors | `startup-taste:60` | PRIMARY (directional) | Source: Aravind Srinivas, "How To Build The Future: Aravind Srinivas" (YC). The precise "1.4%" decimal is not pinned to a public line; skill says "near-zero." |
| v0 took one model to error-free via four engineering layers (a large jump, no model upgrade) | `startup-taste:69` | PRIMARY (directional) | "Lessons from building Vercel v0 and the d0 agent" — https://www.youtube.com/watch?v=_f2WpsmW76Y. The exact "65→94%" figure is not pinned; skill says "a large jump." |
| Jobs cut Apple **350 products → 10** | `startup-taste:30` | JUDGMENT-CALL | Well-known historical illustration; directionally exact. Optional cite: Jobs WWDC 1997 — https://www.youtube.com/watch?v=_LsvdlaF5_k. |
| Granola cut **half its features** to expose the core interaction | `startup-taste:30` | JUDGMENT-CALL / illustration | "How to Build a Beloved AI Product: Granola" — https://www.youtube.com/watch?v=IcbuTTVUY7M. |
| Figma built a WebGL renderer + multiplayer protocol for **~4 years**; the tool was then inevitable | `startup-taste:42` | JUDGMENT-CALL / illustration | Dylan Field / Figma, Latent Space — https://www.latent.space/p/figma. |
| **4,000** good verifiable examples beat **4M** low-quality ones | `startup-taste:66` | JUDGMENT-CALL (maxim) | Stat-shaped "bitter-lesson taste residue" (quality + verifiability > quantity). The specific 4K/4M is illustrative, not a measured result. |
| Perplexity outgrew the Bing API; Cursor forked VS Code (extension API blocked speculative edit) | `startup-taste:60` | PRIMARY | Aravind Srinivas (YC) + Michael Truell, Cursor talks. Historical/architectural fact about owning the ceiling layer. |
| Building stopped being the long pole ~2026 (quarter-in-2021 → weekend now) | `startup-taste:10` | JUDGMENT-CALL | The kit's stated thesis/stance (estimate hygiene), not a measured datum. No citation needed. |
| Verifier-first: no eval = #1 cause of failed AI products | `startup-taste:65-66` | PRIMARY | Hamel field-guide — https://hamel.dev/blog/posts/field-guide/ (same as `evals:8`). |

---

## product-taste

The numeric checklist here is the **opposite** of ungrounded — these are testable,
industry-canonical UI constants. They need no citation; they ARE the skill. The two named-product
anchors carry sources.

| Claim (short) | skill:line | Category | Source / note |
|---|---|---|---|
| Dialogs scale from **~0.8** (not 0); buttons depress to **~0.96** | `product-taste:39-40` | JUDGMENT-CALL / CANONICAL | Canonical UI craft constants. Corroborated by Rauno Freiberg's interface checklist — https://github.com/raunofreiberg/interfaces. No citation needed. |
| **16px** minimum input font (iOS auto-zoom threshold) | `product-taste:41` | JUDGMENT-CALL / CANONICAL | Verifiable platform fact (iOS zooms inputs < 16px). Rauno interfaces checklist — https://github.com/raunofreiberg/interfaces. No citation needed. |
| `tabular-nums` on timers/columns; pause off-screen; full-row hit targets | `product-taste:40,42,43` | JUDGMENT-CALL / CANONICAL | Canonical interface rules (Rauno `interfaces`). No citation needed. |
| Animate only **`transform`/`opacity`** (GPU composite path); **60fps** | `product-taste:56,50` | JUDGMENT-CALL / CANONICAL | Browser-rendering common knowledge (compositor-only properties). No citation needed. |
| Durations **200–300ms**, `ease-out` for enter/exit | `product-taste:56` | JUDGMENT-CALL / CANONICAL | Canonical motion-design constant. No citation needed. |
| Latency: **<200ms** instant / **>500ms** slow / **<50ms** the bar (Linear) / Cursor tab ~**260ms** | `product-taste:62-64` | JUDGMENT-CALL + PRIMARY anchors | The perceptual cliffs (<200/<500/<50) are canonical HCI constants — no citation. Named anchors: Linear (Karri Saarinen, "How We Redesigned the Linear UI" — https://linear.app/now/how-we-redesigned-the-linear-ui); Cursor ~260ms tab completion (Cursor talks). |
| Linear collapsed **98 color variables → 3** | `product-taste:74` | PRIMARY | Karri Saarinen, "How We Redesigned the Linear UI" — https://linear.app/now/how-we-redesigned-the-linear-ui (also "Inside Linear" talk — https://www.youtube.com/watch?v=4muxFVZ4XfM). |
| Teenage Engineering's fixed palettes as a generative force | `product-taste:74` | PRIMARY (illustration) | "Config 2024: A Look Inside Teenage Engineering." Illustration. |
| Snapchat runs at several deliberate taps/second (reduce cognitive load, not clicks) | `product-taste:69` | JUDGMENT-CALL (illustration) | Well-known product example; illustrative. No hard citation needed. |
| Older Safari renders `outline` without following `border-radius` (use `box-shadow`) | `product-taste:31` | JUDGMENT-CALL / CANONICAL | Canonical front-end knowledge (focus-ring fix). No citation needed. |
| Designers measurably improve; an 8-year-old's output ≠ a master's (taste is objective) | `product-taste:8` | JUDGMENT-CALL (stance) | The skill's argued stance that taste is learnable, not a cited datum. Thematic source: Chris Olah, "Research Taste" — https://colah.github.io/notes/taste/. |

---

## designing-agents

The strongest-grounded skill in the AI-design group; spine verified near-verbatim against primary
sources.

| Claim (short) | skill:line | Category | Source / note |
|---|---|---|---|
| Workflow vs agent definitions; the six workflow patterns; "add complexity only when it demonstrably improves outcomes" | `designing-agents:11-14,32-39,8` | PRIMARY | Anthropic, "Building effective agents" — https://www.anthropic.com/engineering/building-effective-agents (exact quotes). |
| A working coding agent is **under ~400 lines**, **~190 after three tools**; "an LLM + a loop + tools, no secret" | `designing-agents:66,68` | PRIMARY | ghuntley, "How to build a coding agent" ("just ~300 lines in a loop") — https://ghuntley.com/agent/. Exact line counts are the kit's own from the build. |
| Per-step reliability: **0.9^100 ≈ 0** (≈0.003%); need ~**99.9%/step**; each nine ~an order of magnitude harder | `designing-agents:76` | PRIMARY (math) + JUDGMENT | The arithmetic is standard. The "march of nines" framing is Karpathy, Dwarkesh interview — https://www.dwarkesh.com/p/andrej-karpathy. |
| Invest as much in the agent-computer interface (ACI) as in HCI; keep tools dumb/deterministic | `designing-agents:70,84` | PRIMARY | Anthropic "Building effective agents" (ACI section) — https://www.anthropic.com/engineering/building-effective-agents. |
| Skip high-level agent SDKs; target the provider API directly | `designing-agents:72` | PRIMARY | Anthropic "Building effective agents" ("reduce abstraction layers… use LLM APIs directly"); corroborated by Cognition. |
| CoT is not a faithful trace; "show your reasoning" is not a correctness check | `designing-agents:80,110` | PRIMARY | Anthropic, "Reasoning models don't always say what they think" — https://www.anthropic.com/research/reasoning-models-dont-always-say-what-they-think. |
| Read-only subagents "mostly resemble tool calls rather than true multi-agent collaboration" | `designing-agents:39` | PRIMARY | Cognition, "Multi-Agents: What's Actually Working" — https://cognition.ai/blog/multi-agents-working (verbatim). |
| Swarm demos (200k-LOC browser, C compiler) have a verifiable success criterion; real software scales human taste | `designing-agents` (stance) | PRIMARY | Cognition, "Multi-Agents: What's Actually Working" — https://cognition.ai/blog/multi-agents-working. |
| "You're a senior software engineer" / "think for longer" = gimmicky prompt-engineering | (cross-kit red flag) | PRIMARY | Cognition, "Multi-Agents: What's Actually Working" — https://cognition.ai/blog/multi-agents-working. |

---

## batched-implementation

| Claim (short) | skill:line | Category | Source / note |
|---|---|---|---|
| Superpowers spends **~16 dispatches for a 5-task plan** (fresh agent/task + 2 reviewers + final) | `batched-implementation:18`, `README.md` | PRIMARY | Direct audit of the public superpowers skill set — https://github.com/obra/superpowers. |
| Batching **2-3 tasks/agent** cuts dispatches **~60%** with no loss of isolation | `batched-implementation:8,18,27` | JUDGMENT-CALL (recipe) | The 2-3 batch size and ~60% are the kit's own design recipe derived from the ~16→~4 comparison. Not an external empirical claim. No citation needed. |
| For coupled, latency-sensitive work, one strong agent beats planner→executor→critic fan-out | `batched-implementation:20` | PRIMARY | Convergent finding from production orchestration practice; corroborated by Cognition (below). |
| Writes stay single-threaded; agents contribute *intelligence*, not *actions*; serial unless file-disjoint | `batched-implementation:52-56` | PRIMARY | Cognition, "Don't Build Multi-Agents" + "Multi-Agents: What's Actually Working" — https://cognition.ai/blog/dont-build-multi-agents, https://cognition.ai/blog/multi-agents-working. |
| **N=3** fix↔recheck cycle cap | `batched-implementation:49` | PRIMARY (borderline recipe) | Same N=3 as `recheck`/`systematic-debugging` (see recheck table). |

---

## systematic-debugging

| Claim (short) | skill:line | Category | Source / note |
|---|---|---|---|
| **3-attempt rule** before questioning the design ("production agents converge on ~3 across CI retries, lint-fix loops") | `systematic-debugging:45-47` | PRIMARY (borderline recipe-knob) | This is the **owning skill** for the N=3 claim. Convergent across production coding agents (CI-failure loops, lint-fix loops, retry caps). recheck and batched-implementation cross-ref here. |
| Don't thrash the environment before diagnosing; write a failing reproduction first | `systematic-debugging:33,41` | JUDGMENT-CALL | Standard debugging discipline (root-cause-before-fix); cross-refs `test-driven-development`. No empirical claim. No citation needed. |

---

## test-driven-development

| Claim (short) | skill:line | Category | Source / note |
|---|---|---|---|
| The test is **"five tokens"** of instruction and the model spins on it (Willison) | `test-driven-development:10` | PRIMARY | Simon Willison, "Engineering practices that make coding agents work" (talk) — https://www.youtube.com/watch?v=owmJyKVu5f8. Agentic-coding writing also at https://simonwillison.net/tags/ai-assisted-programming/. |
| TDD bounds the work / is the verifiable signal (the leash for autonomous agents) | `test-driven-development:12-13` | JUDGMENT-CALL (stance) | The kit's reframing of TDD for agents; reasoning, not a cited datum. No citation needed. |
| Tests-after "ratify whatever you wrote, bugs included" | `test-driven-development:92` | JUDGMENT-CALL | Standard TDD rationale. No citation needed. |

---

## using-compound-v

| Claim (short) | skill:line | Category | Source / note |
|---|---|---|---|
| The three compounds: **taste, distribution, a primitive** (master gate) | `using-compound-v:13-14` | JUDGMENT-CALL (kit thesis) | The kit's founding stance, distilled from practitioner founder talks and the top-1% founder canon. Reinforced at `startup-taste:18`, `recheck:27`. Not a single-source empirical claim. No citation needed. |
| Lethal trifecta (flag vulns incl.) | `using-compound-v:18` | PRIMARY | Simon Willison — https://simonwillison.net/2025/Jun/16/the-lethal-trifecta/ (same as `recheck:33`). |
| Tier routing / "overkill is a defect" | `using-compound-v:8,21-28` | JUDGMENT-CALL | The kit's anti-overkill law (constitution Ruling B). No citation needed. |
| README: **1,347 skill lines** across 17 skills | `README.md` | PRIMARY (in-repo, honest within rounding) | Verify in-repo: `wc -l skills/*/SKILL.md \| tail -1`. Honest within rounding. |
| README: **17 skills** | `README.md` | PRIMARY (in-repo) | Verify in-repo: `ls -d skills/*/ \| wc -l`. |
| README: **190 lines of on-demand reference** (interface-checklist + skill-format) | `README.md` | PRIMARY (in-repo) | Verify in-repo: `wc -l references/*.md \| tail -1`; these load only on demand. |

---

## dispatching-parallel-agents

| Claim (short) | skill:line | Category | Source / note |
|---|---|---|---|
| **~4** is the practical optimal for a typical task; beyond a handful, workers step on each other ("Claude Code cyber psychosis") | `dispatching-parallel-agents:45` | PRIMARY (directional) | YC Light Cone (the "cyber psychosis" coinage). The ~4 figure is directional, not a measured optimum. |
| Each sub-agent is a context firewall; fan-out buys isolation, not just throughput | `dispatching-parallel-agents:10` | JUDGMENT-CALL | Owned by `context-engineering` (sub-agents-as-firewalls). No separate citation needed. |

---

## agent-security

| Claim (short) | Category | Source / note |
|---|---|---|
| The lethal trifecta (private data + untrusted content + exfiltration) as the core threat | PRIMARY | Simon Willison — https://simonwillison.net/2025/Jun/16/the-lethal-trifecta/. |
| Threat taxonomy: memory-poisoning, tool-misuse, privilege-compromise, excessive-agency, indirect injection | PRIMARY | Google, "Securing Your AI Agents" — https://cloud.google.com/transform/securing-your-ai-agents. |
| Source-trust hierarchy (system > developer > user > tool > page) as the constructive defense | PRIMARY | Source-trust primitive convergent across production deep-research agents. |
| Sandbox model-written code (AST-walk before exec; microVM > container); SSRF/RCE defenses; secret-redaction; deploy-endpoint auth-gate | PRIMARY | Convergent across production agent frameworks (SSRF proxies, deploy-endpoint auth-gates, secret-redaction). |
| Reviewer can question an insecure pattern the user asked for | PRIMARY | Cognition, "Multi-Agents: What's Actually Working" — https://cognition.ai/blog/multi-agents-working. |

---

## Primary-source index (deduplicated)

The recurring public primary URLs, for quick verification:

- **Anthropic — Building effective agents:** https://www.anthropic.com/engineering/building-effective-agents
- **Anthropic — Effective context engineering for AI agents:** https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents
- **Anthropic — How we built our multi-agent research system (~80% variance, ~15× tokens):** https://www.anthropic.com/engineering/multi-agent-research-system
- **Anthropic — Reasoning models don't always say what they think:** https://www.anthropic.com/research/reasoning-models-dont-always-say-what-they-think
- **Anthropic — Claude Cookbooks (tool-use context management, 335K→173K):** https://github.com/anthropics/claude-cookbooks
- **Cognition — Don't Build Multi-Agents:** https://cognition.ai/blog/dont-build-multi-agents
- **Cognition — Multi-Agents: What's Actually Working (2 bugs/PR, ~58% severe; clean-context reviewer; verifiable-criterion):** https://cognition.ai/blog/multi-agents-working
- **Manus — Context Engineering for AI Agents (100:1, 10×, cache discipline):** https://manus.im/blog/Context-Engineering-for-AI-Agents-Lessons-from-Building-Manus
- **Chroma — Context Rot (~40% by ~170K):** https://research.trychroma.com/context-rot
- **arXiv 2508.21433 — The Complexity Trap (observation masking 52%/+2.6%):** https://arxiv.org/abs/2508.21433
- **Mastra — Observational Memory (60.2%→94.87%, six LongMemEval categories):** https://mastra.ai/research/observational-memory
- **Hamel Husain — Your AI Product Needs Evals:** https://hamel.dev/blog/posts/evals/
- **Hamel Husain — A Field Guide to Rapidly Improving AI Products:** https://hamel.dev/blog/posts/field-guide/
- **Simon Willison — The lethal trifecta:** https://simonwillison.net/2025/Jun/16/the-lethal-trifecta/
- **Simon Willison — Engineering practices that make coding agents work (talk, "five tokens"):** https://www.youtube.com/watch?v=owmJyKVu5f8
- **Karpathy — Dwarkesh interview ("march of nines"):** https://www.dwarkesh.com/p/andrej-karpathy
- **ghuntley — How to build a coding agent:** https://ghuntley.com/agent/
- **Linear — How We Redesigned the Linear UI (98→3 colors, <50ms):** https://linear.app/now/how-we-redesigned-the-linear-ui
- **Rauno Freiberg — interfaces (16px, 0.8/0.96, tabular-nums — canonical UI constants):** https://github.com/raunofreiberg/interfaces
- **Vercel — Lessons from building v0 and d0 (~65%→94%):** https://www.youtube.com/watch?v=_f2WpsmW76Y
- **Aravind Srinivas / Perplexity (owned index, near-zero URL overlap):** YC "How To Build The Future: Aravind Srinivas"
- **Jake Heller / CoCounsel (matches-word-X, very high pass bar):** YC "Context Engineering: Lessons from Scaling CoCounsel"
- **Dylan Field / Figma (~4yr renderer, taste-as-moat):** https://www.latent.space/p/figma
- **Google — Securing Your AI Agents:** https://cloud.google.com/transform/securing-your-ai-agents
- **Superpowers skill set (audited for the leanness comparison):** https://github.com/obra/superpowers

### Removed / do-not-cite

- **recheck cross-model "74.7% / +4.8%"** — section cut; unsourced. Do not re-cite.
- **evals Mastra "67% / five buckets / absence-awareness"** — verified wrong; use 60.2% / six
  categories / 94.87% from the Mastra source above.
- **evals NurtureBoss "33% → 95%" / "60%+ from three"** — unverified at the cited source; keep
  directional only.
