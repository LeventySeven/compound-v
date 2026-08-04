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

An **Anchor** column locates each claim in the shipped skill: the skill name alone when it carries only one
claim of that kind, or `` `<skill>` → "phrase" `` where the phrase is text that appears verbatim in the current skill body and can be grepped for. Anchors are durable across skill edits in a way line numbers were not.

---

## recheck

| Claim (short) | Anchor | Category | Source / note |
|---|---|---|---|
| Cross-model reviewer closes **~74.7%** of a same-model quality gap | `recheck` | **REMOVED** | **Do not cite.** The "cross-model reviewer" section was cut: the decimal was unsourced, and the kit no longer pins a worker's model at all — implementer and reviewer both inherit the session model, because passing a model parameter can silently downgrade the worker. If ever re-added: one sentence, no decimal, with a real cite. |
| Reviewer must be **read-only** (the canonical safe reviewer mutates nothing) | `recheck` → "The reviewer gets read + run-tests tools" | PRIMARY | Convergent across production coding agents whose review/oracle paths are read-only by construction. Attribute as "production reviewers are read-only." Mechanism corroborated by Cognition (below). |
| Clean-context reviewer is *smarter* (attention math / Context Rot) and reasons backward from the diff | `recheck` → "A clean context reasons *backward* from the diff" | PRIMARY | Cognition, "Multi-Agents: What's Actually Working" — https://cognition.ai/blog/multi-agents-working. |
| Devin Review catches **avg 2 bugs/PR, ~58% severe** (logic/edge/security) | `recheck` → "an average of ~2 bugs/PR" | PRIMARY | Cognition, "Multi-Agents: What's Actually Working" — https://cognition.ai/blog/multi-agents-working. The grounded replacement for the removed 74.7% line. |
| **N=3** fix↔recheck cap | `recheck` → "Cap at 3 fix↔recheck cycles" | PRIMARY (borderline recipe-knob) | Production agents converge on ~3 retries (CI-failure loops, lint-fix loops, retry caps). Owning skill is `systematic-debugging`; recheck cross-refs it. |
| Lethal trifecta = private data + untrusted content + exfiltration channel | `recheck` → "private data + untrusted content + an exfiltration channel" | PRIMARY | Simon Willison, "The lethal trifecta for AI agents" — https://simonwillison.net/2025/Jun/16/the-lethal-trifecta/. |
| Signal-density cap **~10-12 findings/pass**; **N=3** cycle cap | `recheck` → "at most ~10-12 findings per pass" | JUDGMENT-CALL | Recipe knobs (signal-density + convergence). No citation needed beyond the N=3 row above. |
| A reviewer must **not flag changes the author clearly made on purpose**, nor hold the diff to a **rigor bar the surrounding code doesn't meet** — a deliberate design choice is not a bug | `recheck` → "a rigor bar the surrounding code doesn't meet" | PRIMARY | OpenAI Codex CLI review prompt — `codex-rs/core/review_prompt.md` (public openai/codex repo), review guidelines #8 ("the bug is clearly not just an intentional change by the original author") and #3 ("fixing the bug does not demand a level of rigor that is not present in the rest of the codebase"). |

---

## code-review

| Claim (short) | Anchor | Category | Source / note |
|---|---|---|---|
| **Confidence-scored, multi-agent** review — fan parallel review lenses across a PR/diff, then score each candidate finding and filter the low-confidence ones to keep false positives off the PR | `code-review` → "read the diff through several independent lenses" | PRIMARY | Anthropic Claude Code — official `code-review` plugin (`claude-plugins-official` marketplace): "Automated code review for pull requests using multiple specialized agents with confidence-based scoring to filter false positives." https://github.com/anthropics/claude-plugins-public/tree/main/plugins/code-review |
| Confidence filter at **~80 / 100** | `code-review` → "drop anything below ~80" | JUDGMENT-CALL (recipe-knob) | The threshold is a tunable knob (the official plugin filters below 80); the *mechanism* (confidence-gate to drop false positives) is the grounded part above. No separate citation needed. |
| Effort scale **low / medium / high / max / ultra** maps review depth to diff size; route *down* when unsure | `code-review` → "match depth to the diff" | JUDGMENT-CALL (recipe-knob) | The kit's tier law applied to a review — owning skill is `using-compound-v` (anti-overkill, `references/sources.md` → using-compound-v). Mirrors the depth tiers surfaced by Claude Code's own `/code-review` effort levels. |
| Parallelize the read/analysis lenses; keep any **write single-threaded** | `code-review` → "keep any *write* single-threaded" | PRIMARY | Walden Yan, Cognition, "Don't Build Multi-Agents" — https://cognition.ai/blog/dont-build-multi-agents. Same as `ai-system-reliability` → "keep every write single-threaded". |
| Reviewer stays **read-only**; `--fix` is a separate, re-verified apply phase | `code-review` → "the review stays read-only" | PRIMARY | Same read-only-reviewer grounding as `recheck` → "The reviewer gets read + run-tests tools" (production reviewers mutate nothing); the bug a reviewer introduces is the one nobody reviews. |
| Don't flag **intentional changes** / no **extra rigor** beyond the surrounding code | `code-review` → "held to a rigor bar the surrounding code doesn't meet" | PRIMARY | OpenAI Codex CLI review prompt (`codex-rs/core/review_prompt.md`), same rows as `recheck` → "a rigor bar the surrounding code doesn't meet". |
| GitHub comments: brief, no emojis, cite file+line with a permalink | `code-review` → "no emojis, and cite the file + line with a permalink" | JUDGMENT-CALL | Output-format recipe; matches the official `code-review` plugin's comment conventions (cited above). No separate citation needed. |

---

## evals

| Claim (short) | Anchor | Category | Source / note |
|---|---|---|---|
| Mastra drove agent memory toward SOTA across LongMemEval | `evals` → "a **60.2%** full-context baseline" | PRIMARY | Mastra research page — https://mastra.ai/research/observational-memory. Correct facts: baseline **60.2%** (gpt-4o full-context), LongMemEval has **six** categories (single-session-user / -assistant / -preference, knowledge-update, temporal-reasoning, multi-session), SOTA **94.87%** (gpt-5-mini). Earlier "67% / five buckets / absence-awareness" was wrong — do not re-cite. |
| NurtureBoss: a few categories dominated; fixing the top one (date/scheduling) produced a large jump | `evals` → "a **handful of failure types dominate**" | **SOFTEN (directional)** | The precise "3 issues = 60%+ / 33% → 95%" figures are not stated verbatim at the source; the public breakdown differs. Keep directional only. Candidate primary: Hamel Husain, "A Field Guide to Rapidly Improving AI Products" — https://hamel.dev/blog/posts/field-guide/. |
| Teams with a data viewer iterate dramatically faster | `evals` → "Build a one-screen data viewer" | **SOFTEN** | Hamel field-guide (https://hamel.dev/blog/posts/field-guide/) says "game-changer," not "10x." Keep directional. |
| Critiques as few-shot raise judge↔human agreement | `evals` → "few-shot examples for the LLM judge" | **SOFTEN (no exact decimal)** | Repeated across the Hamel/Shreya canon but no single page states a "15-20%" delta. Cite Hamel "Your AI Product Needs Evals" — https://hamel.dev/blog/posts/evals/ — and say "materially raises agreement." |
| CoCounsel ships at a very high pass bar | `evals` → "at a very high pass rate" | **SOFTEN** | The "999/1000" figure could not be verified; keep directional. Source thread: Jake Heller, "Context Engineering: Lessons from Scaling CoCounsel" (YC talk). |
| CoCounsel: "evals are way easier when you can say `matches word X`" | `evals` → "A cheap deterministic assertion beats an LLM judge" | PRIMARY | Jake Heller, CoCounsel context-engineering talk (YC). |
| Error analysis is the #1-ROI activity; open-code → axial → count | `evals` → "The #1-ROI activity: look at your data" | PRIMARY | Hamel Husain, "A Field Guide to Rapidly Improving AI Products" — https://hamel.dev/blog/posts/field-guide/. |
| Binary pass/fail not 1-5 Likert; align judge to human; **target >90%** agreement; P/R when imbalanced | `evals` → "Binary pass/fail, never a 1-5 Likert" | PRIMARY | Hamel "Your AI Product Needs Evals" — https://hamel.dev/blog/posts/evals/ + Shreya Shankar eval canon. |
| Read **30-100** traces; align on **25-50** examples; grow the set toward hundreds-to-1,000 | `evals` → "Pull 30-100 real interactions" | JUDGMENT-CALL | Recipe knobs (sample sizes for the loop). Directionally from Hamel; the exact ranges are practitioner defaults. No citation needed. |
| Shipping an LLM feature with no eval = #1 cause of failed AI products | `evals` → "the single most common cause of a failed AI product" | PRIMARY | Hamel field-guide thesis — https://hamel.dev/blog/posts/field-guide/; restated as `startup-taste`'s verifier-first gate. |
| The same aligned judge can be reused as a **runtime gate** via a generate→grade→revise loop (judge returns pass / needs-revision + critique; agent retries on needs-revision with the critique as a fix-list); the loop **must be bounded** (e.g. 3 attempts then accept-with-flag) because unbounded retry-until-pass spins forever | `evals` → "become a runtime gate, not just an offline scorer" | PRIMARY | Anthropic public anthropic-cookbook evaluator-optimizer pattern (evaluator emits PASS / NEEDS_IMPROVEMENT / FAIL + `<feedback>`); public `anthropic` SDK managed-agents `define_outcome` grader ("Eval→revision cycles before giving up. Default 3, max 20"; verdicts satisfied / needs_revision / max_iterations_reached). Corroborated by Datadog's CrewAI/AI-growth talk: a high-quality grader "triggers second-pass refinement when quality is below threshold." |
| Trajectory evals should pin **only the tool calls the task truly requires**; over-specifying the trajectory turns the eval into a brittle change-detector (breaks on a legitimate tool refactor; marks resourceful recovery as failure) — when the goal is reachable many ways, assert on the final result, not the path | `evals` → "For agents: path free, arguments graded" | PRIMARY | Scott Yak, Datadog — DeepLearning.AI "MCP Server Evals Deep Dive" (trajectory strictness EXACT / IN_ORDER / ANY_ORDER; assert on result when the path is non-unique). |

---

## context-engineering

This is the kit's best-grounded skill — every load-bearing number was verified exact against its
public primary source.

| Claim (short) | Anchor | Category | Source / note |
|---|---|---|---|
| Token usage *alone* explains **~80%** of agent-performance variance (token + tool-call + model ≈ **95%**); multi-agent uses **~15×** more tokens than chat | `context-engineering` → "Token spend *alone* explained ~80%" | PRIMARY | Anthropic, "How we built our multi-agent research system" — https://www.anthropic.com/engineering/multi-agent-research-system (verbatim: "token usage by itself explains 80% of the variance"; "three factors explained 95% of the performance variance"; "multi-agent systems use about 15× more tokens than chats"). |
| The instruction file (CLAUDE.md/AGENTS.md) is scoped to its directory subtree (deeper wins; root→cwd chain preloaded); hold only durable load-bearing facts; keep it small (always-loaded = paid every turn), single-source-of-truth, prune on a cadence; treat a persisted fact as a hint, verify on contradiction | `context-engineering` → "The file governs its directory subtree" | PRIMARY | AGENTS.md open spec — https://agents.md ("scope … is the entire directory tree"; "more-deeply-nested … take precedence"; content = run/test commands, code organization, conventions). Keep-small/prune anchored by Anthropic "Effective context engineering" (above); single-source-of-truth corroborated by Cognition, "Multi-Agents: What's Actually Working" — https://cognition.ai/blog/multi-agents-working. "Hint, not ground truth" = durable judgment-call. |
| Observation masking: **52% cheaper, +2.6% solve-rate** | `context-engineering` → "52% cheaper with a +2.6% solve-rate improvement" | PRIMARY | arXiv 2508.21433, "The Complexity Trap" (JetBrains; NeurIPS 2025; Qwen3-Coder 480B) — https://arxiv.org/abs/2508.21433. |
| Masking is "as good as summarization at a fraction of the cost" (not "strictly better") | `context-engineering` → "as good as full summarization at a fraction of the cost" | **SOFTEN (framing, not number)** | The source's thesis is masking is *as good as* summarization at a fraction of the cost ("matching, sometimes slightly exceeding"), NOT strictly better. The 52%/+2.6% numbers are correct; only a superlative would overstate. https://arxiv.org/abs/2508.21433. |
| Tool-result clearing took one workload **335K → 173K** peak tokens | `context-engineering` → "from 335K peak tokens to 173K" | PRIMARY | Anthropic Claude Cookbooks / API tool-use context-management (`clear_tool_uses_20250919`) — https://github.com/anthropics/claude-cookbooks. |
| Context Rot: recall **~40% down by ~170K tokens** on some tasks | `context-engineering` → "~40% down by ~170K tokens" | PRIMARY | Chroma, "Context Rot" technical report — https://research.trychroma.com/context-rot (attributed inline in the skill). |
| Agent traffic ~**100:1** input:output; cached input ~**10×** cheaper ($0.30 vs $3/MTok) | `context-engineering` → "roughly **100:1 input-to-output tokens**" | PRIMARY | Manus, "Context Engineering for AI Agents: Lessons from Building Manus" — https://manus.im/blog/Context-Engineering-for-AI-Agents-Lessons-from-Building-Manus (verbatim "around 100:1", "10x difference"). |
| Mask tool logits don't remove; append-only; deterministic JSON; todo.md recitation vs lost-in-the-middle | `context-engineering` → "Mask a tool's logits to steer a *trusted* agent off it" | PRIMARY | Manus blog (all verbatim) — https://manus.im/blog/Context-Engineering-for-AI-Agents-Lessons-from-Building-Manus. |
| Sub-agent returns a distilled **~1–2K-token** digest | `context-engineering` → "a distilled ~1–2K-token digest" | PRIMARY | Anthropic "Effective context engineering" (verbatim "often 1,000–2,000 tokens") — https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents. |
| Claude Code splits its prompt on a dynamic boundary; drops `CLAUDE.md` up front, glob/grep JIT | `context-engineering` → "__SYSTEM_PROMPT_DYNAMIC_BOUNDARY__" | PRIMARY | Anthropic "Effective context engineering for AI agents" (Claude Code as the worked example) — https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents. |
| Working context **< 40%**; clear at ~50K, compact at ~180K; keep last **~10** turns / **6** recent tool-uses | `context-engineering` → "clear tool-uses at ~50K input tokens" | JUDGMENT-CALL | Compaction-ladder recipe knobs (tuning defaults, not empirical claims). The optimal-window ≈ last 10 turns does trace to arXiv 2508.21433. No citation needed. |

---

## startup-taste

| Claim (short) | Anchor | Category | Source / note |
|---|---|---|---|
| Wrapper-class apps sit far lower on retention than category leaders | `startup-taste` → "a wrapper retains like a wrapper" | **SOFTEN (directional)** | Stated directionally in the skill (not a pinned figure). The earlier "60–85% vs ~14% DAU/MAU" decimals are not cited to a public source — keep directional. |
| Perplexity built its own index → near-zero URL overlap with competitors | `startup-taste` → "near-zero URL overlap with competitors on identical queries" | PRIMARY (directional) | Source: Aravind Srinivas, "How To Build The Future: Aravind Srinivas" (YC). The precise "1.4%" decimal is not pinned to a public line; skill says "near-zero." |
| v0 took one model to error-free via four engineering layers (a large jump, no model upgrade) | `startup-taste` → "four engineering layers — a large jump" | PRIMARY (directional) | "Lessons from building Vercel v0 and the d0 agent" — https://www.youtube.com/watch?v=_f2WpsmW76Y. The exact "65→94%" figure is not pinned; skill says "a large jump." |
| Jobs cut Apple **350 products → 10** | `startup-taste` → "Jobs cut Apple 350 products → 10" | JUDGMENT-CALL | Well-known historical illustration; directionally exact. Optional cite: Jobs WWDC 1997 — https://www.youtube.com/watch?v=_LsvdlaF5_k. |
| Granola cut **half its features** to expose the core interaction | `startup-taste` → "Granola cut half its features" | JUDGMENT-CALL / illustration | "How to Build a Beloved AI Product: Granola" — https://www.youtube.com/watch?v=IcbuTTVUY7M. |
| Figma built a WebGL renderer + multiplayer protocol for **~4 years**; the tool was then inevitable | `startup-taste` → "WebGL renderer + multiplayer protocol for ~4 years" | JUDGMENT-CALL / illustration | Dylan Field / Figma, Latent Space — https://www.latent.space/p/figma. |
| **4,000** good verifiable examples beat **4M** low-quality ones | `startup-taste` → "4,000 good verifiable examples beat 4M" | JUDGMENT-CALL (maxim) | Stat-shaped "bitter-lesson taste residue" (quality + verifiability > quantity). The specific 4K/4M is illustrative, not a measured result. |
| Perplexity outgrew the Bing API; Cursor forked VS Code (extension API blocked speculative edit) | `startup-taste` → "Cursor forked VS Code because the extension API" | PRIMARY | Aravind Srinivas (YC) + Michael Truell, Cursor talks. Historical/architectural fact about owning the ceiling layer. |
| Building stopped being the long pole ~2026 (quarter-in-2021 → weekend now) | `startup-taste` → "took a quarter in 2021 takes a weekend now" | JUDGMENT-CALL | The kit's stated thesis/stance (estimate hygiene), not a measured datum. No citation needed. |
| Validate an AI idea on a prompted frontier model before fine-tuning/collecting data ("Fire, Ready, Aim") | `startup-taste` → "validate the idea on a prompted frontier model" | PRIMARY | swyx, "The Rise of the AI Engineer" — https://www.latent.space/p/ai-engineer. |
| Verifier-first: no eval = #1 cause of failed AI products | `startup-taste` → "no eval system is the #1 cause of failed AI products" | PRIMARY | Hamel field-guide — https://hamel.dev/blog/posts/field-guide/ (same as `evals` → "the single most common cause of a failed AI product"). |
| Inaction is a hidden risk that feels safe; often easier to do a hard thing that matters than an easy thing that doesn't | `startup-taste` → "Inaction is a hidden risk that feels safe" | PRIMARY | Sam Altman, "What I Wish Someone Had Told Me" — https://blog.samaltman.com/what-i-wish-someone-had-told-me. |
| The best ideas are *noticed* by someone who has lived in a domain for years, not produced in a list-making session; provenance is a tell | `startup-taste` → "The best ideas are *noticed* by someone who has lived" | PRIMARY | Paul Graham, "How to Do Great Work" — https://paulgraham.com/greatwork.html. |
| Persistence vs obstinacy split on one axis: persistent = fixed on the goal, flexible on means; obstinate = fixed on means, driven by ego | `startup-taste` → "the persistent are fixed on the goal and flexible on means" | PRIMARY | Paul Graham, "The Right Kind of Stubborn" — https://paulgraham.com/persistence.html. |

---

## architecting-ai-systems

| Claim (short) | Anchor | Category | Source / note |
|---|---|---|---|
| AI task horizon (length of task finished autonomously at **>50%**) doubles roughly every **~7 months** | `architecting-ai-systems` → "doubling roughly every seven months" | PRIMARY | METR, "Measuring AI Ability to Complete Long Tasks" — https://arxiv.org/abs/2503.14499 (~7-month doubling of the >50%-success task horizon). |
| A better harness on the **same** model moved Opus 4.5 from **50.2% → 55.4%** on SWE-bench Pro via context management + tool orchestration alone | `architecting-ai-systems` → "from 50.2% to 55.4% on SWE-bench Pro" | PRIMARY | Anthropic Applied AI, "Effective harnesses for long-running agents" (Opus 4.5; harness-only gain, no model swap). |
| **Code-over-tools** (agent calls tools as code in a sandbox vs. each tool a direct call) — measured **~98% token reduction** on a realistic workflow | `architecting-ai-systems` → "measured ~98% token reduction on a realistic workflow" | PRIMARY | Anthropic, "Code Execution with MCP" — ~98% token cut on a realistic multi-tool workflow. |
| v0 took one model to error-free via four engineering layers (**a ~30-point jump, no model swap**) | `architecting-ai-systems` → "a ~30-point jump with zero model training" | PRIMARY (directional) | "Lessons from building Vercel v0 and the d0 agent" — https://www.youtube.com/watch?v=_f2WpsmW76Y. The exact `65→94%` figure is not pinned; skill says "a ~30-point jump." Same datum as `startup-taste` → "four engineering layers — a large jump". |
| Perplexity built its own ~200B-URL index → **near-zero URL overlap** with competitors on the same queries; owns the layer that sets its ceiling | `architecting-ai-systems` → "its own ~200B-URL index" | PRIMARY (directional) | Aravind Srinivas, "How To Build The Future: Aravind Srinivas" (YC). The precise "1.4%" decimal is not pinned to a public line; skill says "near-zero." Same datum as `startup-taste` → "near-zero URL overlap with competitors on identical queries". |
| Quality of the verifiable signal beats quantity of data — **a few thousand verifiable examples beat millions of low-quality RLHF ones** | `architecting-ai-systems` → "a few thousand verifiable examples beat millions" | JUDGMENT-CALL (maxim) | Stat-shaped bitter-lesson taste residue (quality + verifiability > quantity); illustrative, not a measured Qwen-3 result. Same maxim as `startup-taste` → "4,000 good verifiable examples beat 4M". |
| The compound-system thesis (engineer the system around a swappable frontier model; "vaccinated against the Bitter Lesson") | `architecting-ai-systems` → "vaccinated against the Bitter Lesson" | PRIMARY | Zaharia/Frankle et al., "The Shift from Models to Compound AI Systems," BAIR 2024 — https://bair.berkeley.edu/blog/2024/02/18/compound-ai-systems/. |
| The Bitter Lesson — don't build the edge more compute will erase; ~99% of agent-framework value lives in the RL'd model | `architecting-ai-systems` → "~99% of the value lives in the RL'd model" | PRIMARY | Richard Sutton, "The Bitter Lesson" — http://www.incompleteideas.net/IncIdeas/BitterLesson.html; applied to agent frameworks by Gregor Zunic, browser-use, "The Bitter Lesson of Agent Frameworks." |
| Innovation tokens — roughly **three** novel-tech bets before operational complexity sinks you; make the AI primitive the novel part, everything else boring tech | `architecting-ai-systems` → "roughly three novel-tech bets before operational complexity" | PRIMARY | Dan McKinley, "Choose Boring Technology" — https://mcfunley.com/choose-boring-technology. |

---

## product-taste

The numeric checklist here is the **opposite** of ungrounded — these are testable,
industry-canonical UI constants. They need no citation; they ARE the skill. The two named-product
anchors carry sources.

| Claim (short) | Anchor | Category | Source / note |
|---|---|---|---|
| Dialogs scale from **~0.8** (not 0); buttons depress to **~0.96** | `product-taste` → "scale in from **~0.8, not 0**" | JUDGMENT-CALL / CANONICAL | Canonical UI craft constants. Corroborated by Rauno Freiberg's interface checklist — https://github.com/raunofreiberg/interfaces. No citation needed. |
| **16px** minimum input font (iOS auto-zoom threshold) | `product-taste` → "**16px minimum** input font" | JUDGMENT-CALL / CANONICAL | Verifiable platform fact (iOS zooms inputs < 16px). Rauno interfaces checklist — https://github.com/raunofreiberg/interfaces. No citation needed. |
| `tabular-nums` on timers/columns; pause off-screen; full-row hit targets | `product-taste` → "**`tabular-nums`** on timers and numeric columns" | JUDGMENT-CALL / CANONICAL | Canonical interface rules (Rauno `interfaces`). No citation needed. |
| Animate only **`transform`/`opacity`** (GPU composite path); **60fps** | `product-taste` → "animate only **`transform` and `opacity`**" | JUDGMENT-CALL / CANONICAL | Browser-rendering common knowledge (compositor-only properties). No citation needed. |
| Durations **200–300ms**, `ease-out` for enter/exit | `product-taste` → "keep durations in the **200–300ms** range" | JUDGMENT-CALL / CANONICAL | Canonical motion-design constant. No citation needed. |
| Latency: **<200ms** instant / **>500ms** slow / **<50ms** the bar (Linear) / Cursor tab ~**260ms** | `product-taste` → "Cursor's tab completion lives at ~260ms" | JUDGMENT-CALL + PRIMARY anchors | The perceptual cliffs (<200/<500/<50) are canonical HCI constants — no citation. Named anchors: Linear (Karri Saarinen, "How We Redesigned the Linear UI" — https://linear.app/now/how-we-redesigned-the-linear-ui); Cursor ~260ms tab completion (Cursor talks). |
| Linear collapsed **98 color variables → 3** | `product-taste` → "Linear collapsed 98 color variables → 3" | PRIMARY | Karri Saarinen, "How We Redesigned the Linear UI" — https://linear.app/now/how-we-redesigned-the-linear-ui (also "Inside Linear" talk — https://www.youtube.com/watch?v=4muxFVZ4XfM). |
| The 98→3 collapse works because the palette is built in **LCH, not HSL**: LCH is perceptually uniform (same lightness looks equally light across hues), so one base/accent/contrast triple generates every theme incl. high-contrast a11y; HSL's lightness lies, forcing per-color hand-tuning | `product-taste` → "built in LCH, not HSL" | PRIMARY | Linear, "How We Redesigned the Linear UI" — https://linear.app/now/how-we-redesigned-the-linear-ui (extends the 98→3 row above). |
| Habituation blinds you to normalized flows; the worst flaws are the ones you've stopped seeing — view your own product as a first-time user / stay a beginner | `product-taste` → "habituation blinds you to broken flows" | PRIMARY | Tony Fadell, "The first secret of design is … noticing" (TED) — https://www.ted.com/talks/tony_fadell_the_first_secret_of_design_is_noticing. |
| Open menus/dropdowns on **`mousedown`** not `click` — firing on press-down shaves perceptible delay, makes the menu feel instant | `product-taste` → "Open menus/dropdowns on `mousedown`, not `click`" | PRIMARY | Rauno Freiberg, Web Interface Guidelines — https://github.com/raunofreiberg/interfaces. |
| Teenage Engineering's fixed palettes as a generative force | `product-taste` → "Teenage Engineering's fixed palettes as a generative force" | PRIMARY (illustration) | "Config 2024: A Look Inside Teenage Engineering." Illustration. |
| Snapchat runs at several deliberate taps/second (reduce cognitive load, not clicks) | `product-taste` → "Snapchat runs at several deliberate taps a second" | JUDGMENT-CALL (illustration) | Well-known product example; illustrative. No hard citation needed. |
| Older Safari renders `outline` without following `border-radius` (use `box-shadow`) | `product-taste` → "render `outline` without following `border-radius`" | JUDGMENT-CALL / CANONICAL | Canonical front-end knowledge (focus-ring fix). No citation needed. |
| Designers measurably improve; an 8-year-old's output ≠ a master's (taste is objective) | `product-taste` → "an eight-year-old's output is not interchangeable with a master's" | JUDGMENT-CALL (stance) | The skill's argued stance that taste is learnable, not a cited datum. Thematic source: Chris Olah, "Research Taste" — https://colah.github.io/notes/taste/. |
| Product judgment is domain-specific and does not transfer; strong practitioners are good at saying when they don't have it — so in an unlived domain, flag missing calibration rather than bluffing a crisp verdict | `product-taste` → "product judgment is domain-specific and doesn't transfer" | PRIMARY | Paul Adams (CPO, Intercom), "Product Judgment" — https://www.intercom.com/blog/product-judgment/. |

---

## designing-agents

The strongest-grounded skill in the AI-design group; spine verified near-verbatim against primary
sources.

| Claim (short) | Anchor | Category | Source / note |
|---|---|---|---|
| Workflow vs agent definitions; the six workflow patterns; "add complexity only when it demonstrably improves outcomes" | `designing-agents` → "only when it demonstrably improves outcomes" | PRIMARY | Anthropic, "Building effective agents" — https://www.anthropic.com/engineering/building-effective-agents (exact quotes). |
| A working coding agent is **under ~400 lines**, **~190 after three tools**; "an LLM + a loop + tools, no secret" | `designing-agents` → "under ~400 lines, most of it boilerplate" | PRIMARY | ghuntley, "How to build a coding agent" ("just ~300 lines in a loop") — https://ghuntley.com/agent/. Exact line counts are the kit's own from the build. |
| Per-step reliability: **0.9^100 ≈ 0** (≈0.003%); need ~**99.9%/step**; each nine ~an order of magnitude harder | `designing-agents` → "0.9^100 ≈ 0.003%" | PRIMARY (math) + JUDGMENT | The arithmetic is standard. The "march of nines" framing is Karpathy, Dwarkesh interview — https://www.dwarkesh.com/p/andrej-karpathy. |
| Invest as much in the agent-computer interface (ACI) as in HCI; keep tools dumb/deterministic | `designing-agents` → "Invest as much in the agent-computer interface" | PRIMARY | Anthropic "Building effective agents" (ACI section) — https://www.anthropic.com/engineering/building-effective-agents. |
| Skip high-level agent SDKs; target the provider API directly | `designing-agents` → "Skip the high-level agent SDKs" | PRIMARY | Anthropic "Building effective agents" ("reduce abstraction layers… use LLM APIs directly"); corroborated by Cognition. |
| CoT is not a faithful trace; "show your reasoning" is not a correctness check | `designing-agents` → "isn't a faithful trace of the computation" | PRIMARY | Anthropic, "Reasoning models don't always say what they think" — https://www.anthropic.com/research/reasoning-models-dont-always-say-what-they-think. |
| Read-only subagents "mostly resemble tool calls rather than true multi-agent collaboration" | `designing-agents` → "the working shape is **agent-as-tool**" | PRIMARY | Cognition, "Multi-Agents: What's Actually Working" — https://cognition.ai/blog/multi-agents-working (verbatim). |
| Swarm demos (200k-LOC browser, C compiler) have a verifiable success criterion; real software scales human taste | `designing-agents` → "all had a cheap, verifiable success criterion" | PRIMARY | Cognition, "Multi-Agents: What's Actually Working" — https://cognition.ai/blog/multi-agents-working. |
| When retrying a flaky LLM/agent step, retrying with the same model often reproduces the failure; failing over to a different model (cross-model fallback chain) fixes it | `designing-agents` → "retrying the same model often produces repeat failures" | PRIMARY | Warp engineering blog — https://www.warp.dev/blog/swe-bench-verified ("We originally attempted to retry with the same model, and found that this often produced repeat failures" → cross-model fallback chain: Sonnet → Claude 3.7 → Gemini 2.5 Pro → GPT-4.1). |
| **≈10** is a sane default turn ceiling for an agentic loop (bound the loop; on the last step force-finish) | `designing-agents` → "a hard turn ceiling (≈10 is a sane default)" | PRIMARY | OpenAI Agents SDK — run configuration's documented default `DEFAULT_MAX_TURNS = 10` (the framework's own shipped default max-turns value; raises `MaxTurnsExceeded` once exceeded). |
| Before adding agents, look at where cost/variance go: **three factors explain ~95% of agent-performance variance, token spend alone ~80%** — "spend more tokens on the hard part" beats "add another agent" | `designing-agents` → "three factors explain ~95% of the performance variance" | PRIMARY | Anthropic, "How we built our multi-agent research system" — https://www.anthropic.com/engineering/multi-agent-research-system (verbatim: "three factors explained 95% of the performance variance"; "token usage by itself explains 80% of the variance"). Same datum as the context-engineering row above. |

---

## batched-implementation

| Claim (short) | Anchor | Category | Source / note |
|---|---|---|---|
| Superpowers spends **~16 dispatches for a 5-task plan** (fresh agent/task + 2 reviewers + final) | `batched-implementation` → "~16 dispatches for a 5-task plan", `README.md` | PRIMARY | Direct audit of the public superpowers skill set — https://github.com/obra/superpowers. |
| Batching **2-3 tasks/agent** cuts dispatches **~60%** with no loss of isolation | `batched-implementation` → "cuts dispatches ~60% with no loss of isolation" | JUDGMENT-CALL (recipe) | The 2-3 batch size and ~60% are the kit's own design recipe derived from the ~16→~4 comparison. Not an external empirical claim. No citation needed. |
| For coupled, latency-sensitive work, one strong agent beats planner→executor→critic fan-out | `batched-implementation` → "one strong agent beats a planner→executor→critic fan-out" | PRIMARY | Convergent finding from production orchestration practice; corroborated by Cognition (below). |
| Writes stay single-threaded; agents contribute *intelligence*, not *actions*; serial unless file-disjoint | `batched-implementation` → "Serial by default; parallel only when file-disjoint" | PRIMARY | Cognition, "Don't Build Multi-Agents" + "Multi-Agents: What's Actually Working" — https://cognition.ai/blog/dont-build-multi-agents, https://cognition.ai/blog/multi-agents-working. |
| **N=3** fix↔recheck cycle cap | `batched-implementation` → "owns the three verdicts and the N=3 cap" | PRIMARY (borderline recipe) | Same N=3 as `recheck`/`systematic-debugging` (see recheck table). |
| When a convention matters, **paste the exemplar** (the file/snippet to imitate) into the dispatch prompt, not a bare "follow conventions" — a fresh-context agent regresses to model defaults for any convention it wasn't shown | `batched-implementation` → "paste the exemplar" | PRIMARY | Anthropic, "Building effective agents" — https://www.anthropic.com/engineering/building-effective-agents ("a good tool definition often includes example usage"; examples anchor behavior). Corroborated by the leaked OpenAI Codex system prompt's anti-default rules (no purple/dark-mode bias, no default `useMemo`/`useCallback`) — models default to generic patterns absent a local anchor. |
| A batch of **structurally similar** tasks risks a few-shot rut — a fresh-context implementer "falls into a rhythm" and adapts later tasks from earlier ones; the brief must name what *differs* per task | `batched-implementation` → "falls into a rhythm and adapts the third from the first two" | PRIMARY | Manus, "Context Engineering for AI Agents" — https://manus.im/blog/Context-Engineering-for-AI-Agents-Lessons-from-Building-Manus (verbatim: "the agent often falls into a rhythm—repeating similar actions… leads to drift, overgeneralization, or sometimes hallucination"; "don't few-shot yourself into a rut"). |

---

## writing-plans

| Claim (short) | Anchor | Category | Source / note |
|---|---|---|---|
| Build failures cluster at the **edges** — setup (environment/dependencies, first ~5%) and the finish (deploy/env-vars/prod-config, last ~5%) — while the middle application logic is reliable; front-load setup and deploy tasks | `writing-plans` → "The risk clusters at the edges" | PRIMARY | Amjad Masad (Replit CEO) on the a16z podcast — https://www.youtube.com/watch?v=g-WeCOUYBrk. |
| When a load-bearing assumption proves false mid-build, the implementer **stops and reports back** rather than improvising or looping, with an explicit attempt budget (surface after ~3 failed attempts) — an execution→planning backtrack | `writing-plans` → "after ~3 failed attempts at the same thing" | PRIMARY | Cognition Devin (published/leaked system prompt): "Return to PLANNING if you discover unexpected complexity" and "ask the user for help if CI does not pass after the third attempt." Google Antigravity agent formalizes the same EXECUTION→PLANNING backtrack. Shares the **N=3** budget with the recheck table. |
| A plan must **forbid editing a test to make it pass**: when a test fails the suspect is the code under test, not the test; change the test only if the task is explicitly about the test | `writing-plans` → "forbid editing a test to make it pass" | PRIMARY | Cognition Devin (published/leaked system prompt): "never modify the tests themselves, unless your task explicitly asks … Always first consider that the root cause might be in the code you are testing rather than the test itself." |
| Pair each verification criterion with the **negative constraint** that rules out the degenerate/cheat solution (tests pass AND no assertion weakened, no output hardcoded) — the code-side defense to the no-edit-the-test rule | `writing-plans` → "the negative constraint that rules out the cheat" | PRIMARY | a16z — Jacob Steinhardt (UC Berkeley) on specification gaming: coding agents that "pass tests" by hardcoding expected outputs; "a technically correct answer that violates the intent." a16z podcast, video KSgPNVmZ8jQ. |
| Plans must **flag destructive/irreversible actions up front** in the preamble (a User-Review flag) so the human signs off before the implementer executes autonomously | `writing-plans` → "a `## User Review Required` block" | PRIMARY | Google Antigravity's leaked `implementation_plan.md` template mandates a `## User Review Required` section as the plan's second block: "Document anything that requires user review or clarification, for example, breaking changes or significant design decisions. Use GitHub alerts (IMPORTANT/WARNING/CAUTION) to highlight critical items." |

---

## writing-prd

| Claim (short) | Anchor | Category | Source / note |
|---|---|---|---|
| The durable PRD section grammar — problem/context, goal, core functions, **non-goals**, architecture — is convergent across the canonical engineering-doc formats | `writing-prd` → "The durable sections" | PRIMARY | Google Engineering Practices "Design Docs / Context and Scope"; Rust RFC template (guide-level explanation, unresolved questions); ADR (alternatives considered); Amazon PR-FAQ. Cross-format convergence, not one source. |
| A PRD is **institutional memory** — the durable record of what the product is and why, captured once so a cold reader (human or fresh AI session) doesn't reverse-engineer it | `writing-prd` → "the durable record of what the product *is*" | PRIMARY | prd-pipeline — https://github.com/Timmy-Lane/prd-pipeline ("spec as institutional memory"). Its build machinery (tier routing, multi-critic grill, 9-pass gates, a CLI) is deliberately NOT adopted — that's per-build process, not PRD content. |
| **Prose over bullets** where precision matters (writing forces the thinking a bullet skips); ~2-page cap | `writing-prd` → "Prose where precision matters" | PRIMARY | Amazon working-backwards / PR-FAQ (narrative memos, no bullets). |
| On supersede, leave a **one-line forward pointer** rather than deleting (cheap decision genealogy), decoupled from any code lifecycle | `writing-prd` → "leave a one-line forward pointer" | JUDGMENT-CALL | Oxide RFD process (status frontmatter + decision genealogy), adapted as a light touch. |
| **Non-goals** carry the *support boundary* — what the product does for inputs past its scope (reject/escalate), because agents don't reliably ask when uncertain (they assume and proceed) | `writing-prd` → "an unsure agent won't ask, it'll assume and proceed" | PRIMARY | a16z — Jacob Steinhardt (UC Berkeley) on agent failure modes: "current agents do not robustly ask for clarification when uncertain; they tend to make assumptions and proceed"; specification gaming (agents "pass tests" by hardcoding outputs). a16z podcast, video KSgPNVmZ8jQ. Finn/offline-RL OOD citation considered and dropped as too-stretched. |
| Single-source-of-truth, edit-in-place, prune-on-cadence | `writing-prd` → "One PRD, edited in place" | (see context-engineering) | Reuses the AGENTS.md-spec + Anthropic "Effective context engineering" maintenance rules grounded in the context-engineering section; the PRD links to them, doesn't re-derive. |

---

## extracting-specs

| Claim (short) | Anchor | Category | Source / note |
|---|---|---|---|
| The real contract is the **observed behavior callers rely on, not the documented one** — when the docs and the callers disagree, the callers win | `extracting-specs` → "when the docs and the callers disagree, the callers win" | PRIMARY (principle) | Hyrum's Law — https://www.hyrumslaw.com/ ("With a sufficient number of users of an API … all observable behaviors of your system will be depended on by somebody"). The contract is the observed behavior, not the stated one. |
| Spec grammar = **Requirement** (triggered, WHEN→THEN scenario) + **Invariant** (always-true), kept flat rather than classified into type chapters; `entities` + `enforced` metadata make it machine-findable | `extracting-specs` → "a *triggered* behavior: WHEN" | JUDGMENT-CALL / CANONICAL | WHEN→THEN scenario grammar = BDD/Gherkin's Given-When-Then — https://cucumber.io/docs/gherkin/reference; the always-true Invariant = Design by Contract (Bertrand Meyer, Eiffel). The flat, enforcement-anchored packaging is the `spec-miner` agent pattern from affaan-m/ECC (Everything-Claude-Code), generalized here language-agnostic. |
| **Sample-and-expand** over reading the whole module (entry surfaces first, trace one level down, stop at boundaries / ~15-file budget) | `extracting-specs` → "Sample, then expand — don't read everything" | (see context-engineering) | The context-rot / attention-budget mechanics are owned and grounded by `context-engineering` (Chroma Context Rot; Anthropic attention-budget). This skill applies them to spec recovery; the ~15-file / 3-dry-files cutoffs are recipe knobs. No separate citation. |
| **Never invent behavior** — record an explicit `uncertainty` note rather than guessing a Requirement | `extracting-specs` → "Never invent behavior" | (see systematic-debugging) | Same honesty bar as `systematic-debugging`'s "say I don't know and gather evidence" + Karpathy, "never trust a result you can't explain." No separate citation. |
| **Flag-don't-fix** while mining; **mine what you touch, not the whole repo** (a spec that outpaces usage rots) | `extracting-specs` → "Mine what you're about to touch, not the whole repo" | JUDGMENT-CALL | Maintenance discipline; single-source / prune-on-a-cadence rules are owned by `writing-prd` (cross-ref). No citation needed. |

---

## systematic-debugging

| Claim (short) | Anchor | Category | Source / note |
|---|---|---|---|
| **3-attempt rule** before questioning the design ("production agents converge on ~3 across CI retries, lint-fix loops") | `systematic-debugging` → "production coding agents converge on it independently" | PRIMARY (borderline recipe-knob) | This is the **owning skill** for the N=3 claim. Convergent across production coding agents (CI-failure loops, lint-fix loops, retry caps). recheck and batched-implementation cross-ref here. |
| Don't thrash the environment before diagnosing; write a failing reproduction first | `systematic-debugging` → "Diagnose before mutating the environment" | JUDGMENT-CALL | Standard debugging discipline (root-cause-before-fix); cross-refs `test-driven-development`. No empirical claim. No citation needed. |
| AI/agent code fails silently — a passing-looking result you cannot account for is a bug lead, not a finish; never trust an output you can't explain | `systematic-debugging` → "never trust an output you can't explain" | PRIMARY | Andrej Karpathy, "A Recipe for Training Neural Networks" — http://karpathy.github.io/2019/04/25/recipe/ ("neural nets fail silently… never trust a result you can't explain"). |
| A nondeterministic agent/LLM bug that fires intermittently has no single reproducible stack trace; build a small graded example set and treat where it fails across runs as the repro and regression guard — the role a failing test plays for deterministic code | `systematic-debugging` → "Build a small graded example set" | PRIMARY | Hamel Husain, "Your AI Product Needs Evals" — https://hamel.dev/blog/posts/evals/ (from 30+ production builds; "no eval system" is the #1 reason AI products fail). Cross-refs `compound-v:evals`. |
| Classify a failure before spending a retry: deterministic reds (validation/type/missing-arg/auth) are guaranteed to recur on the same inputs so get zero retries; reserve the retry budget for transient faults (network blip, 503, rate limit) | `systematic-debugging` → "is guaranteed to fail again on the same inputs" | PRIMARY | Standard production resilience practice (transient-fault handling), e.g. Microsoft Azure Architecture Center "Transient fault handling": retry only faults expected to be short-lived; do not retry faults guaranteed to recur. |
| If you can't state what "correct" looks like, the bug is **underspecification, not a code defect** — pin the expected behavior first, or the symptom shifts as your notion of "right" drifts | `systematic-debugging` → "the bug is underspecification, not a code defect" | PRIMARY | Hamel Husain, "A Field Guide to Rapidly Improving AI Products" — https://hamel.dev/blog/posts/field-guide/ (*criteria drift*: evaluation criteria can't be fully fixed before you look at real outputs). |

---

## test-driven-development

| Claim (short) | Anchor | Category | Source / note |
|---|---|---|---|
| The instruction **"use red-green TDD" is ~five tokens** and every good coding agent already knows it and runs with it | `test-driven-development` → "is about five tokens" | PRIMARY | Simon Willison, "Engineering practices that make coding agents work" (Pragmatic Summit fireside) — https://www.youtube.com/watch?v=owmJyKVu5f8; recap https://simonwillison.net/2026/Mar/14/pragmatic-summit/. The five tokens are the *instruction*, not the test artifact (earlier phrasing conflated the two and added "spins on it without complaining," which is not in the source — corrected). |
| **Run the existing suite first**, before any task — confirms tests exist, forces the agent to learn how to invoke them, sets the testing frame | `test-driven-development` → "running the existing suite *first*, before any task" | PRIMARY | Simon Willison, "First run the tests" — https://simonwillison.net/guides/agentic-engineering-patterns/first-run-the-tests/. |
| **Green *and* clean, not just green** — read the output, not only the exit code; 0 failures can still emit stderr / deprecation / `act()` warnings that flag a real problem | `test-driven-development` → "green *and* clean, not just green" | ADAPTED | superpowers TDD "Output pristine (no errors, warnings)" check (github.com/obra/superpowers). |
| TDD bounds the work / is the verifiable signal (the leash for autonomous agents) | `test-driven-development` → "It is the verifiable signal" | JUDGMENT-CALL (stance) | The kit's reframing of TDD for agents; reasoning, not a cited datum. No citation needed. |
| Tests-after "ratify whatever you wrote, bugs included" | `test-driven-development` → "ratify whatever you wrote, bugs included" | JUDGMENT-CALL | Standard TDD rationale. No citation needed. |
| Testing intensity should scale **inversely with how easily a bug is observed**: test database and business-logic layers rigorously (corruption hides for weeks), test the visible frontend lightly (bugs show up in the browser) | `test-driven-development` → "intensity scales inversely with how easily a bug is observed" | PRIMARY | Andrew Ng, DeepLearning.AI talk on AI-era engineering. |
| When verifying tests, start with the **narrowest test** for the code you changed (fastest signal), then **widen to the full suite** to confirm nothing else broke | `test-driven-development` → "Start with the narrowest test for the code you changed" | PRIMARY | OpenAI Codex CLI agent instructions, published "Testing Philosophy." |
| The model writes the assertion for free; **choosing what to assert (spec fidelity) is the human judgment that now differentiates** — a flawless test against the wrong spec is a worthless suite | `test-driven-development` → "a flawlessly-written test against the wrong spec" | PRIMARY | Andrew Ng, DeepLearning.AI panel — AI writes tests trivially, so test-spec fidelity becomes the differentiating skill. (Same Ng talk grounding the test-intensity row above.) |
| Wait on a **condition**, not a fixed delay, for async work in tests (poll until true with a timeout cap; never a bare `setTimeout`/`sleep`) | `test-driven-development` → "never a bare clock delay" | JUDGMENT-CALL | Standard async-test discipline; the canonical fix for clock-based test flakiness (Testing Library's `waitFor`/`findBy` polling utilities replace arbitrary timeouts). No empirical decimal claimed. |

---

## using-compound-v

| Claim (short) | Anchor | Category | Source / note |
|---|---|---|---|
| The three compounds: **taste, distribution, a primitive** (master gate) | `using-compound-v` → "Does this grow taste, distribution, or a primitive?" | JUDGMENT-CALL (kit thesis) | The kit's founding stance, distilled from practitioner founder talks and the top-1% founder canon. Reinforced at `startup-taste` → "Does this grow taste, distribution, or a primitive?" and `recheck` → "the three-compounds gate". Not a single-source empirical claim. No citation needed. |
| Lethal trifecta (flag vulns incl.) | `using-compound-v` → "flag vulns (incl. the lethal trifecta)" | PRIMARY | Simon Willison — https://simonwillison.net/2025/Jun/16/the-lethal-trifecta/ (same as `recheck` → "private data + untrusted content + an exfiltration channel"). |
| Tier routing / "overkill is a defect" | `using-compound-v` → "Overkill is a defect, not a safety margin" | JUDGMENT-CALL | The kit's anti-overkill law (constitution Ruling B). No citation needed. |
| **Route a change against the docs that already exist** — amend the doc that owns the surface rather than creating a second one; per-change scaffolding is archived, only refined requirements endure | `using-compound-v` → "Route against what exists first" | PRIMARY | OpenSpec (Fission-AI) — https://github.com/Fission-AI/OpenSpec: persistent `specs/` of cumulative requirements vs ephemeral `changes/` archived on completion; "specs are cumulative requirements that evolve, not proliferate … the proposal, design, and tasks are temporary scaffolding; only refined requirements graduate into the persistent specs layer." Considered and NOT adopted: spec-kit's seven-artifact-per-feature directory (`spec/plan/research/data-model/contracts/quickstart/tasks`) — coherent when many machine agents consume typed artifacts, a maintenance tax for a human-plus-agent repo. Its durable `memory/constitution.md` idea is what the one-document cap keeps. |
| **Reference and how-to docs rot first** — neither is where the thinking happened, so a behavior change invalidates them silently | `using-compound-v` → "Reference and how-to docs rot first" | PRIMARY | Diátaxis — https://diataxis.fr/: four modes chosen by the reader's intent at arrival (tutorial / how-to / reference / explanation). The doc-sync step is that taxonomy applied to a repo — a behavior change almost always invalidates a *reference* doc and often a *how-to*. |

---

## dispatching-parallel-agents

| Claim (short) | Anchor | Category | Source / note |
|---|---|---|---|
| **~4** is the practical optimal for a typical task; beyond a handful, workers step on each other ("Claude Code cyber psychosis") | `dispatching-parallel-agents` → "~4 is the practical ceiling for a typical task" | PRIMARY (directional) | YC Light Cone (the "cyber psychosis" coinage). The ~4 figure is directional, not a measured optimum. |
| Each sub-agent is a context firewall; fan-out buys isolation, not just throughput | `dispatching-parallel-agents` → "Each sub-agent is a context firewall" | JUDGMENT-CALL | Owned by `context-engineering` (sub-agents-as-firewalls). No separate citation needed. |
| Managers/orchestrators default to over-prescription when delegating to agents; brief the **what and constraints, not the how**, line-by-line | `batched-implementation` → "Brief the *what* and the constraints, not the *how*" (moved: the claim now lives in the dispatch-brief section of `batched-implementation`) | PRIMARY | Cognition, "Multi-Agents: What's Actually Working" — https://cognition.ai/blog/multi-agents-working (already cited PRIMARY above for the writes-single-threaded finding). |
| The right worker count **scales with task class** (≈1 for a fact-find, a few for a comparison, more for broad search); a lead left to size its own fan-out over-invests — put the budget in the brief | `dispatching-parallel-agents` → "spawned 50 subagents for simple queries" | PRIMARY | Anthropic, "How we built our multi-agent research system" — https://www.anthropic.com/engineering/multi-agent-research-system (verbatim: "spawning 50 subagents for simple queries"; "Simple fact-finding requires just 1 agent with 3-10 tool calls, direct comparisons might need 2-4 subagents with 10-15 calls each"). |

---

## searching-patterns

| Claim (short) | Anchor | Category | Source / note |
|---|---|---|---|
| When a repo already has an established shape (house wrapper, AGENTS.md/CLAUDE.md rule, neighboring-file pattern), that **local convention overrides** the external canonical pattern — match the local shape, don't import a clashing "correct" one | `searching-patterns` → "that overrides the external canonical one" | PRIMARY | AGENTS.md spec — https://agents.md (AGENTS.md carries code-style guidelines for in-scope code; "explicit user chat prompts override everything" — a local instruction layer that governs the diff). OpenAI Codex / Cursor system prompts: "If working within an existing website or design system, preserve the established patterns, structure, and visual language." |
| An official **conformance suite** (a protocol, wire format, standard's test vectors) is the strongest primary source — precise, executable, drift-free; point the implementer at it and write code until it passes | `searching-patterns` → "that suite *is* the primary source" | PRIMARY | Simon Willison, "Engineering practices that make coding agents work" (talk) — https://www.youtube.com/watch?v=owmJyKVu5f8 ("if there's an existing language-agnostic test suite… WebAssembly has a very detailed specification which includes hundreds of tests… write code until this test suite passes, and it kind of will"). |
| For a popular stack, go to its **canonical exemplar** — the maintainer's own docs/examples or a large real-world codebase, not a blog; include a stack only if it has one widely-agreed reference (else omit the long tail) | `searching-patterns` → "Know the canonical exemplar for your stack" | JUDGMENT-CALL (curated; URLs verified to resolve) | Maintainer-owned: React/Next — github.com/vercel-labs/agent-skills (Vercel's official `react-best-practices` skill, 70 perf rules from Vercel Engineering, `author: vercel`; verified to resolve) + nextjs.org/docs; FastAPI — fastapi.tiangolo.com; Testing Library — testing-library.com. Real-world: tRPC — github.com/calcom/cal.com (verified `packages/trpc`: @trpc/server/client/react/next) + trpc.io/docs. A curation bar, not an empirical claim; contested layers (state/auth/ORM) excluded on purpose. |

---

## verification-before-completion

| Claim (short) | Anchor | Category | Source / note |
|---|---|---|---|
| The reason agents confidently ship broken work is an **observation gap, not an action gap**; closing the feedback loop (e.g. a browser-screenshot channel for a UI the agent cannot otherwise see) is one of the biggest unlocks for autonomous task length | `verification-before-completion` → "an *observation* gap, not an action gap" | PRIMARY | Tanveer Mittal & Utkarsh Lamba (Anthropic), "Claude Agent SDK Deep Dive" (DeepLearning.AI): developers over-optimize for the action pillar and under-invest in the feedback pillar — Claude builds a React app for 20 minutes, the layout is wrong, but it cannot observe this without a browser-screenshot mechanism; closing that loop is one of the biggest unlocks for autonomous task length. |

---

## finishing

| Claim (short) | Anchor | Category | Source / note |
|---|---|---|---|
| **Local-green is not CI-green:** a post-push concern worth a dedicated step — monitor remote PR checks rather than declaring done at PR creation | `finishing` → "Green locally is not green in CI" | PRIMARY | Warp's production coding agent ships a public `diagnose-ci-failures` skill, and Claude Code provides autonomous PR-check monitoring — both encode local-green ≠ CI-green as a first-class post-push concern. |
| Before a destructive discard, the at-risk work to surface is precisely **uncommitted changes, untracked files, and unpushed commits** | `finishing` → "the work that would vanish unrecoverably" | PRIMARY | Anthropic's published Claude Code worktree auto-cleanup refuses to remove a worktree unless it has no uncommitted changes, no untracked files, and no unpushed commits — the same three categories that define unrecoverable work. |

---

## agent-security

| Claim (short) | Category | Source / note |
|---|---|---|
| The lethal trifecta (private data + untrusted content + exfiltration) as the core threat | PRIMARY | Simon Willison — https://simonwillison.net/2025/Jun/16/the-lethal-trifecta/. |
| Threat taxonomy: memory-poisoning, tool-misuse, privilege-compromise, excessive-agency, indirect injection | PRIMARY | Google, "Securing Your AI Agents" — https://cloud.google.com/transform/securing-your-ai-agents. |
| Source-trust hierarchy (system > developer > user > tool > page) as the constructive defense | PRIMARY | Source-trust primitive convergent across production deep-research agents. |
| Sandbox model-written code (AST-walk before exec; microVM > container); SSRF/RCE defenses; secret-redaction; deploy-endpoint auth-gate | PRIMARY | Convergent across production agent frameworks (SSRF proxies, deploy-endpoint auth-gates, secret-redaction). |
| Reviewer can question an insecure pattern the user asked for | PRIMARY | Cognition, "Multi-Agents: What's Actually Working" — https://cognition.ai/blog/multi-agents-working. |
| Credentials never enter the model's context (not prompt, args, or results); the model passes a **handle** (session ID / secret name) and the tool resolves it out of view | PRIMARY | Google ADK security workshop (Adam Idelman) — https://www.youtube.com/watch?v=jZXvqEqJT7o ("authentication should happen as much as possible within a specific tool… you don't want the agent to handle credentials directly"; agent passes a session ID, the tool fetches the token). |
| Apply the trifecta at **tool-selection** time: one tool — an MCP server especially — can hold all three legs at once, so vet each before enabling it | PRIMARY | Simon Willison, "The lethal trifecta" — https://simonwillison.net/2025/Jun/16/the-lethal-trifecta/ (MCP "encourages users to mix and match tools"; GitHub MCP exploit — https://simonwillison.net/2025/May/26/github-mcp-exploited/). |

---

## ai-system-reliability

| Claim (short) | Anchor | Category | Source / note |
|---|---|---|---|
| Reliability over capability — a reliable-but-narrower system beats a flaky-but-capable one once users get burned | `ai-system-reliability` → "a reliable-but-narrower system beats a more-capable-but-flaky one" | JUDGMENT-CALL | The reliability-before-capability taste gate that `compound-v:startup-taste` owns and grounds. The earlier "95%-reliable beats 70%-capable / users leave after two failures" phrasing attributed to Amjad Masad's "The Future of Software Creation" was **not supported by that talk** (its "95%" is an aspirational parallel-agent-fleet goal; its "70%" is a SWE-bench score) and was removed — a fabricated synthesis, corrected on audit. |
| **Self-error-detection + supervisor**: models catch their own errors better than they avoid making them; a primary agent is watched by "supervisor" agents | `ai-system-reliability` → "Models catch their own mistakes more reliably than they avoid making them" | PRIMARY | Clay Bavor (Sierra), "Making Customer-Facing AI Agents Delightful" (Sequoia *Training Data*) — https://www.youtube.com/watch?v=RAZFDY_jGio (verbatim: LLMs are better at detecting errors in their own output than at not making them; "supervisor" agents review the primary agent). |
| **Constellation topology**: a stateful primary agent supervised by specialist agents plus human escalation, for high-stakes domains one model can't be trusted in alone | `ai-system-reliability` → "add specialist watchers, and human escalation as the last rung" | PRIMARY | Munjal Shah / Hippocratic AI — "Polaris: A Safety-focused LLM Constellation Architecture for Healthcare" — https://arxiv.org/abs/2403.13313 (primary agent + specialist support agents to increase safety / reduce hallucination). |
| Parallelize reading/searching/analysis; **keep every write single-threaded** — multi-agent should add intelligence (a review/supervisor loop), not parallel writers | `ai-system-reliability` → "keep every write single-threaded" | PRIMARY | Walden Yan, Cognition, "Don't Build Multi-Agents" — https://cognition.ai/blog/dont-build-multi-agents (deduped index); corroborated by Anthropic, "How we built our multi-agent research system" — https://www.anthropic.com/engineering/multi-agent-research-system. |
| The failure reflex: ask **which capability the agent lacked, then make the fix enforceable in the harness** — how a team ships **1M+ LOC with zero pre-merge-reviewed human code** | `ai-system-reliability` → "ships 1M+ LOC with zero pre-merge-reviewed human code" | PRIMARY | Ryan Lopopolo, OpenAI Frontier — "Extreme Harness Engineering" (latent.space — https://www.latent.space/p/harness-eng) + OpenAI "Harness engineering: leveraging Codex in an agent-first world" — https://openai.com/index/harness-engineering/ (verbatim: >1M LOC, 0% human-written / 0% human-reviewed-before-merge; on failure, ask "what capability/context/structure is missing?" not "try harder"). |
| **Reinforce the objective on every tool return** (current goal/status/what failed), not once up front; **isolate failure-prone work in throwaway sub-agents** that report only the outcome | `ai-system-reliability` → "isolate failure-prone work in throwaway sub-agents" | PRIMARY | Armin Ronacher, "Agent Design Is Still Hard" — https://lucumr.pocoo.org/2025/11/21/agents-are-hard/ (verbatim: each tool return is a chance to "remind the agent about the overall objective and the status"; run iteration-prone tasks "in a subagent until they succeed and only report back the success"). |
| Treat every weird failure as a **research lead, not a bug ticket** — nets/agents fail *silently*, so the loop must surface and explain anomalies | `ai-system-reliability` → "a **research lead, not a bug ticket**" | PRIMARY | Sholto Douglas & Trenton Bricken on Dwarkesh Patel — https://www.dwarkesh.com/p/sholto-douglas-trenton-bricken (zero-to-frontier by staying close to where models break); Andrej Karpathy, "A Recipe for Training Neural Networks" — http://karpathy.github.io/2019/04/25/recipe/ (deduped index; "neural nets fail silently"). |
| **Reward hacking is a default failure mode of any proxy reward** — design against it before trusting a verifiable-reward / self-improving loop | `ai-system-reliability` → "the default failure mode of any verifiable-reward or self-improving loop" | PRIMARY | Lilian Weng, "Reward Hacking in Reinforcement Learning" — https://lilianweng.github.io/posts/2024-11-28-reward-hacking/ (an RL agent exploits flaws/ambiguities in the reward function to score high without doing the task). |
| Simulator-as-regression — every fix becomes a permanent regression case (case generation only; judge/eval construction is `compound-v:evals`) | `ai-system-reliability` → "Every fix becomes a permanent regression case" | (see evals) | Mechanism owned by `evals`; this skill only generates the captured-failure case and hands it off. No separate citation. |
| The **correctness invariants** (errors-are-data `{ok,data,error}`; named `StopReason`; compaction masks not truncates; classify-failure retry-vs-failover; fallback that drops `tools` is a bug) | `ai-system-reliability` → "Correctness invariants that prevent silent drift" | JUDGMENT-CALL | Engineering seam-contract judgment calls, each closing a specific silent-failure path. The retry-vs-failover axis is corroborated by Warp — https://www.warp.dev/blog/swe-bench-verified; the masks-not-truncates invariant aligns with the compaction practice owned by `compound-v:context-engineering`. |
| The **seam landmines** (async re-fire of non-idempotent step; two co-authoritative logs; `MAX(seq)+1` race; crash-resume re-fires external write; reask rewrites the call; multi-attempt cost; budget TOCTOU; `threading.Lock` in asyncio; TTFB-not-wall-clock) + the async-default worked example | `ai-system-reliability` → "The seam landmines: where durable AI state actually corrupts" | JUDGMENT-CALL | Each verified against a freshly-cloned upstream system — DBOS (durable execution), Google AX, Instructor, Tower, Helicone, and LangGraph's `Durability` literal — which together establish the public, reader-checkable contracts these landmines violate. |

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
- **Cognition Devin — published/leaked system prompt (test-protection; EXECUTION→PLANNING backtrack; third-attempt CI rule):** judgment-call / canonical (published agent prompt; corroborated by Google Antigravity's EXECUTION→PLANNING backtrack)
- **Manus — Context Engineering for AI Agents (100:1, 10×, cache discipline):** https://manus.im/blog/Context-Engineering-for-AI-Agents-Lessons-from-Building-Manus
- **Chroma — Context Rot (~40% by ~170K):** https://research.trychroma.com/context-rot
- **arXiv 2508.21433 — The Complexity Trap (observation masking 52%/+2.6%):** https://arxiv.org/abs/2508.21433
- **Mastra — Observational Memory (60.2%→94.87%, six LongMemEval categories):** https://mastra.ai/research/observational-memory
- **Hamel Husain — Your AI Product Needs Evals:** https://hamel.dev/blog/posts/evals/
- **Hamel Husain — A Field Guide to Rapidly Improving AI Products:** https://hamel.dev/blog/posts/field-guide/
- **Simon Willison — The lethal trifecta:** https://simonwillison.net/2025/Jun/16/the-lethal-trifecta/
- **Simon Willison — Engineering practices that make coding agents work (talk, "five tokens"):** https://www.youtube.com/watch?v=owmJyKVu5f8
- **Karpathy — Dwarkesh interview ("march of nines"):** https://www.dwarkesh.com/p/andrej-karpathy
- **Karpathy — A Recipe for Training Neural Networks (neural nets fail silently; never trust a result you can't explain):** http://karpathy.github.io/2019/04/25/recipe/
- **Warp — SWE-bench Verified eng. blog (same-model retry → repeat failures; cross-model fallback chain):** https://www.warp.dev/blog/swe-bench-verified
- **ghuntley — How to build a coding agent:** https://ghuntley.com/agent/
- **Sam Altman — What I Wish Someone Had Told Me (inaction is a hidden risk):** https://blog.samaltman.com/what-i-wish-someone-had-told-me
- **Paul Graham — How to Do Great Work (best ideas are noticed, not brainstormed):** https://paulgraham.com/greatwork.html
- **Paul Graham — The Right Kind of Stubborn (persistence vs obstinacy):** https://paulgraham.com/persistence.html
- **Tony Fadell — The first secret of design is … noticing (TED; habituation/beginner):** https://www.ted.com/talks/tony_fadell_the_first_secret_of_design_is_noticing
- **Amjad Masad / Replit — a16z podcast (build failures cluster at the edges):** https://www.youtube.com/watch?v=g-WeCOUYBrk
- **AGENTS.md spec (local convention overrides external canonical):** https://agents.md
- **Linear — How We Redesigned the Linear UI (98→3 colors, <50ms):** https://linear.app/now/how-we-redesigned-the-linear-ui
- **Rauno Freiberg — interfaces (16px, 0.8/0.96, tabular-nums — canonical UI constants):** https://github.com/raunofreiberg/interfaces
- **Vercel — Lessons from building v0 and d0 (~65%→94%):** https://www.youtube.com/watch?v=_f2WpsmW76Y
- **METR — Measuring AI Ability to Complete Long Tasks (~7-month task-horizon doubling):** https://arxiv.org/abs/2503.14499 — grounds `architecting-ai-systems` → "doubling roughly every seven months".
- **Anthropic — Effective harnesses for long-running agents (Opus 4.5 50.2%→55.4% SWE-bench Pro, harness-only):** grounds `architecting-ai-systems` → "from 50.2% to 55.4% on SWE-bench Pro".
- **Anthropic — Code Execution with MCP (~98% token reduction):** grounds `architecting-ai-systems` → "measured ~98% token reduction on a realistic workflow".
- **Zaharia/Frankle et al. — The Shift from Models to Compound AI Systems (BAIR 2024):** https://bair.berkeley.edu/blog/2024/02/18/compound-ai-systems/ — grounds `architecting-ai-systems` → "vaccinated against the Bitter Lesson".
- **Richard Sutton — The Bitter Lesson:** http://www.incompleteideas.net/IncIdeas/BitterLesson.html — grounds `architecting-ai-systems` → "~99% of the value lives in the RL'd model".
- **Dan McKinley — Choose Boring Technology (innovation tokens):** https://mcfunley.com/choose-boring-technology — grounds `architecting-ai-systems` → "roughly three novel-tech bets before operational complexity".
- **Aravind Srinivas / Perplexity (owned index, near-zero URL overlap):** YC "How To Build The Future: Aravind Srinivas"
- **Jake Heller / CoCounsel (matches-word-X, very high pass bar):** YC "Context Engineering: Lessons from Scaling CoCounsel"
- **Dylan Field / Figma (~4yr renderer, taste-as-moat):** https://www.latent.space/p/figma
- **Google — Securing Your AI Agents:** https://cloud.google.com/transform/securing-your-ai-agents
- **Superpowers skill set (audited for the leanness comparison):** https://github.com/obra/superpowers
- **Paul Graham — How to Think for Yourself (felt-certainty; conventional minds are surest they think for themselves):** https://paulgraham.com/think.html — grounds `critical-thinking` gate 1.
- **Charlie Munger — steelman standard ("you don't own an opinion until you can argue the other side better than its proponent"):** widely attributed (Munger, USC Law 2007 / Poor Charlie's Almanack) — maxim; grounds `critical-thinking` gate 2.
- **Karl Popper (falsification — a claim must state what would refute it) + Sébastien Bubeck et al., "Sparks of AGI" (probe breadth-first for the limit, not for demos):** Popper canonical; Bubeck https://arxiv.org/abs/2303.12712 — grounds `critical-thinking` gate 3.
- **OpenAI Codex CLI — review prompt (`codex-rs/core/review_prompt.md`, don't-flag-intentional / no-extra-rigor):** public openai/codex repo — grounds `recheck` → "a rigor bar the surrounding code doesn't meet".
- **OpenAI Codex CLI — published "Testing Philosophy" (narrowest test first, then widen):** OpenAI Codex agent instructions — grounds `test-driven-development` → "Start with the narrowest test for the code you changed".
- **OpenAI Agents SDK — `DEFAULT_MAX_TURNS = 10` (shipped default turn cap):** framework run-config default — grounds `designing-agents` → "a hard turn ceiling (≈10 is a sane default)".
- **Paul Adams (Intercom) — "Product Judgment" (domain-specific, doesn't transfer):** https://www.intercom.com/blog/product-judgment/ — grounds `product-taste` → "product judgment is domain-specific and doesn't transfer".
- **Google Antigravity — leaked `implementation_plan.md` template (`## User Review Required` second block):** grounds `writing-plans` → "a `## User Review Required` block" (also corroborates the EXECUTION→PLANNING backtrack above).
- **Anthropic — "Claude Agent SDK Deep Dive" (DeepLearning.AI; Mittal & Lamba — observation gap, feedback-loop unlock):** grounds `verification-before-completion` → "an *observation* gap, not an action gap".
- **Datadog / Scott Yak — DeepLearning.AI "MCP Server Evals Deep Dive" (trajectory strictness; second-pass refinement below threshold):** grounds `evals` → "For agents: path free, arguments graded" and the judge-as-runtime-gate row.
- **Anthropic — anthropic-cookbook evaluator-optimizer pattern + `anthropic` SDK `define_outcome` grader (bounded generate→grade→revise, default 3 / max 20):** https://github.com/anthropics/anthropic-cookbook — grounds `evals` → "become a runtime gate, not just an offline scorer".
- **Warp — `diagnose-ci-failures` skill + Claude Code PR-check monitoring (local-green ≠ CI-green):** grounds `finishing` → "Green locally is not green in CI".
- **Anthropic — Claude Code worktree auto-cleanup (no uncommitted/untracked/unpushed = removable):** grounds `finishing` → "the work that would vanish unrecoverably".
- **Character.AI — Optimizing AI Inference at Character.AI (int8-native, KV >20X, 95% prefix cache, ~33x cost):** https://blog.character.ai/optimizing-ai-inference-at-character-ai-2/ — grounds `ai-system-reliability` → "Run quality evals continuously on real production traffic". The int8 / KV-20X / 95%-prefix-cache / ~33x serving figures are **RETIRED** (cut from the skill — see the RETIRED section).
- **Armin Ronacher — Agent Design Is Still Hard (reinforce objective per tool return; iteration in throwaway sub-agents):** https://lucumr.pocoo.org/2025/11/21/agents-are-hard/ — grounds `ai-system-reliability` → "isolate failure-prone work in throwaway sub-agents".
- **Ryan Lopopolo / OpenAI Frontier — Extreme Harness Engineering (1M+ LOC, 0% human-reviewed; capability-gap failure reflex):** https://www.latent.space/p/harness-eng + https://openai.com/index/harness-engineering/ — grounds `ai-system-reliability` → "ships 1M+ LOC with zero pre-merge-reviewed human code".
- **Clay Bavor / Sierra — Making Customer-Facing AI Agents Delightful (self-error-detection → supervisor):** https://www.youtube.com/watch?v=RAZFDY_jGio — grounds `ai-system-reliability` → "Models catch their own mistakes more reliably than they avoid making them".
- **Munjal Shah / Hippocratic AI — Polaris constellation (primary + specialist agents, safety-first):** https://arxiv.org/abs/2403.13313 — grounds `ai-system-reliability` → "add specialist watchers, and human escalation as the last rung".
- **Sholto Douglas & Trenton Bricken — Dwarkesh Patel (every weird failure is a research lead; close to the run):** https://www.dwarkesh.com/p/sholto-douglas-trenton-bricken — grounds `ai-system-reliability` → "a **research lead, not a bug ticket**".
- **Lilian Weng — Reward Hacking in Reinforcement Learning (proxy-reward exploitation as default failure):** https://lilianweng.github.io/posts/2024-11-28-reward-hacking/ — grounds `ai-system-reliability` → "the default failure mode of any verifiable-reward or self-improving loop".

### Removed / do-not-cite

- **recheck cross-model "74.7% / +4.8%"** — section cut; unsourced. Do not re-cite.
- **evals Mastra "67% / five buckets / absence-awareness"** — verified wrong; use 60.2% / six
  categories / 94.87% from the Mastra source above.
- **evals NurtureBoss "33% → 95%" / "60%+ from three"** — unverified at the cited source; keep
  directional only.


## frame-the-goal
| Claim in skill | Anchor | Tier | Source |
| --- | --- | --- | --- |
| Nets/agents fail silently — an undefined goal has no tripwire; you can't check what you can't define | `frame-the-goal` → "an undefined goal has no tripwire" | PRIMARY | Andrej Karpathy, "A Recipe for Training Neural Networks" — http://karpathy.github.io/2019/04/25/recipe/ (reused) |
| Criteria drift — a measurable proxy that diverges from the real goal silently rewards the wrong thing | `frame-the-goal` → "*criteria drift*: the rubric must track" | PRIMARY | Hamel Husain, "A Field Guide to Rapidly Improving AI Products" — https://hamel.dev/blog/posts/field-guide/ (reused) |
| For an auto-checkable domain the verifier is what a later RL/self-improvement loop optimizes; its quality sets the ceiling | `frame-the-goal` → "so its quality sets the system's ceiling" | PRIMARY | Jason Wei, "Asymmetry of Verification and Verifier's Law" — https://www.jasonwei.net/blog/asymmetry-of-verification-and-verifiers-law (reused) |
| A complex system that works is grown from a simple system that worked → decompose a hard goal | `frame-the-goal` → "invariably grown from a simple system that worked" | PRIMARY (canonical maxim) | John Gall, *Systemantics* (Gall's Law) — https://en.wikipedia.org/wiki/Systemantics |
| Understand → plan → execute → check; restate and split into verifiable sub-problems | `frame-the-goal` → "understand → plan → execute → check" | PRIMARY (canonical) | George Pólya, *How to Solve It* — https://en.wikipedia.org/wiki/How_to_Solve_It |
| De-risk the load-bearing assumption first (order work by info gained per unit effort) | `frame-the-goal` → "de-risk the load-bearing assumption first" | JUDGMENT-CALL | Research-process discipline; recipe knob, no citation needed. |
| The four-part frame + one-line success check | `frame-the-goal` → "The frame: four parts, then a check" | JUDGMENT-CALL | The kit's define-success-first default; recipe knob. |

## simplest-thing-that-works
| Claim in skill | Anchor | Tier | Source |
| --- | --- | --- | --- |
| Find the simplest solution; add complexity only when it demonstrably improves outcomes; don't build agents for everything | `simplest-thing-that-works` → "add complexity only when it demonstrably improves outcomes" | PRIMARY | Erik Schluntz & Barry Zhang, Anthropic, "Building Effective Agents" — https://www.anthropic.com/research/building-effective-agents (reused) |
| "Do the simplest thing that could possibly work" + YAGNI (burden of proof on complexity) | `simplest-thing-that-works` → "do the simplest thing that could possibly work" | PRIMARY (canonical maxim) | Ward Cunningham / Kent Beck, XP — https://wiki.c2.com/?DoTheSimplestThingThatCouldPossiblyWork ; YAGNI — https://martinfowler.com/bliki/Yagni.html |
| A complex system that works grew from a simple one → climb only because the goal forces it (anti-underkill) | `simplest-thing-that-works` → "grew from a simple system that worked (Gall's Law)" | PRIMARY (canonical) | John Gall, *Systemantics* (Gall's Law) — https://en.wikipedia.org/wiki/Systemantics (shared) |
| The mechanism ladder (zero-AI → … → multi-agent), default the lowest rung | `simplest-thing-that-works` → "The mechanism ladder — default the lowest rung that works" | JUDGMENT-CALL | The kit's anti-overkill default; recipe knob, no citation. |

## make-it-stable
| Claim in skill | Anchor | Tier | Source |
| --- | --- | --- | --- |
| Nets/agents fail silently — without a check you can't even see the failure | `make-it-stable` → "Nets and agents *fail silently* by default" | PRIMARY | Andrej Karpathy, "A Recipe for Training Neural Networks" — http://karpathy.github.io/2019/04/25/recipe/ (reused) |
| Find the simplest thing that holds; add nondeterminism only where it earns its place | `make-it-stable` → "add nondeterminism only where it earns its place" | PRIMARY | Anthropic, "Building Effective Agents" — https://www.anthropic.com/research/building-effective-agents (reused) |
| Capped retry + backoff + jitter; classify transient (retry) vs permanent (fail fast) — retry only short-lived faults | `make-it-stable` → "capped retry with exponential backoff + jitter" | PRIMARY | Microsoft Azure Architecture Center, "Transient fault handling" (reused — also grounds `systematic-debugging` → "retry only faults expected to be short-lived") |
| Fail OVER to a different model/mechanism rather than re-rolling the same dice | `make-it-stable` → "Fail OVER to a different model/mechanism, don't re-roll the same dice" | PRIMARY | OpenRouter, "Provider Routing" (heterogeneous failover) — https://openrouter.ai/docs/features/provider-routing ; corroborated by Warp cross-model retry (indexed above) |
| External side effects are at-most-once via an idempotency key; only same-DB-transaction work is exactly-once | `make-it-stable` → "at-most-once via an idempotency key" | PRIMARY | Stripe, "Idempotent requests / idempotency keys" — https://docs.stripe.com/api/idempotent_requests |
| Reward hacking is a default failure mode of any proxy reward | `make-it-stable` → "Reward hacking is a default failure of any proxy reward" | PRIMARY | Lilian Weng, "Reward Hacking in Reinforcement Learning" — https://lilianweng.github.io/posts/2024-11-28-reward-hacking/ (reused) |
| The four stability moves (check / determinism / bound / idempotency), climbed to match stakes | `make-it-stable` → "It's four moves, applied in order" | JUDGMENT-CALL | Standard production-reliability practice; recipe knob. |

### Primary-source index — additions (v2 "solve any goal" pack)
- **John Gall — *Systemantics* (Gall's Law: a complex system that works evolved from a simple system that worked):** https://en.wikipedia.org/wiki/Systemantics — grounds `frame-the-goal` → "invariably grown from a simple system that worked", `simplest-thing-that-works` → "grew from a simple system that worked (Gall's Law)".
- **George Pólya — *How to Solve It* (understand → plan → execute → check; split into verifiable sub-problems):** https://en.wikipedia.org/wiki/How_to_Solve_It — grounds `frame-the-goal` → "understand → plan → execute → check".
- **Ward Cunningham / Kent Beck — "Do the simplest thing that could possibly work" (XP):** https://wiki.c2.com/?DoTheSimplestThingThatCouldPossiblyWork — grounds `simplest-thing-that-works` → "do the simplest thing that could possibly work".
- **Martin Fowler — YAGNI:** https://martinfowler.com/bliki/Yagni.html — grounds `simplest-thing-that-works` → "add complexity only when it demonstrably improves outcomes".
- **OpenRouter — Provider Routing (heterogeneous model failover):** https://openrouter.ai/docs/features/provider-routing — grounds `make-it-stable` → "Fail OVER to a different model/mechanism, don't re-roll the same dice".
- **Stripe — Idempotent requests / idempotency keys (at-most-once external effects):** https://docs.stripe.com/api/idempotent_requests — grounds `make-it-stable` → "at-most-once via an idempotency key".

---

## Cross-domain source-verified additions (2026-06-11)

*Grounding for a batch of source-verified enhancements across the product / code / CTO / CPO / AI / dev domains. Per kit style, these claims live in the skill bodies WITHOUT inline citation; this is where they are grounded. Every row below cites its public source directly.*

### architecting-ai-systems
| Claim (short) | Anchor | Category | Source / note |
|---|---|---|---|
| Start from maximal capability and restrict; a too-thick harness fails because the action space is incomplete | `architecting-ai-systems` → "start from maximal capability and restrict, not the reverse" | PRIMARY | Gregor Zunic, browser-use, "The Bitter Lesson of Agent Frameworks" — https://browser-use.com/posts/bitter-lesson-agent-frameworks ("Agent frameworks fail not because models are weak, but because their action spaces are incomplete"; "Start with maximal capability, then restrict"). Same source as the ~99% row above. |
| Shift from predefined scaffolds to reasoning-model-led workflows — "the harness becomes the box and the model chooses how to proceed" | `architecting-ai-systems` → "the harness becomes the box and the model chooses how to proceed" | PRIMARY | Ryan Lopopolo (OpenAI Frontier), "Extreme Harness Engineering" — https://www.latent.space/p/harness-eng |

### ai-system-reliability
| Claim (short) | Anchor | Category | Source / note |
|---|---|---|---|
| Heterogeneous serving backends require strict implementation equivalence; degradation evaded evals because the model "recovers well from isolated mistakes"; fix = continuous evals on true production | `ai-system-reliability` → "recovers gracefully from isolated errors" | PRIMARY | Anthropic, "A Postmortem of Three Recent Issues" — https://www.anthropic.com/engineering/a-postmortem-of-three-recent-issues |
| A workaround can mask, not fix, a deeper bug — removing it after a believed root-cause fix exposes a harder latent corruption (the December top-k workaround "inadvertently masking" a deeper miscompile) | `ai-system-reliability` → "A workaround that masks, not fixes, a deeper bug" | PRIMARY | Anthropic, "A Postmortem of Three Recent Issues" — https://www.anthropic.com/engineering/a-postmortem-of-three-recent-issues |
| Long-horizon agent resume is a harness contract: each session starts memoryless → end clean/mergeable with handoff artifacts; silent failure is a later session "declares the job done" | `ai-system-reliability` → "durable resume is also a harness contract" | PRIMARY | Anthropic, "Effective harnesses for long-running agents" — https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents (also grounds `architecting-ai-systems`) |

### context-engineering
| Claim (short) | Anchor | Category | Source / note |
|---|---|---|---|
| Programmatic tool-calling: a worked Drive→Salesforce example drops 150,000 → 2,000 tokens (98.7%) | `context-engineering` → "150,000 to 2,000 tokens — a 98.7% saving" | PRIMARY | Anthropic, "Code execution with MCP" — https://www.anthropic.com/engineering/code-execution-with-mcp ("reduces the token usage from 150,000 tokens to 2,000 tokens—a … saving of 98.7%") |
| The tool *set* is always-loaded context; "if a human engineer can't definitively say which tool to use … an AI agent can't" | `context-engineering` → "tool *set* is always-loaded context too" | PRIMARY | Anthropic, "Effective context engineering for AI agents" — https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents |
| Keep failures, distrust successes: past failure cases improve agent performance; past successes often induce lazy pattern-matching into a local minimum | `context-engineering` → "keep failures, distrust successes" | PRIMARY | Jeff Huber, Chroma, "Context Engineering for Engineers" (YC Root Access) — https://www.youtube.com/watch?v=3jN77Aw7Utk |

### designing-agents
| Claim (short) | Anchor | Category | Source / note |
|---|---|---|---|
| Wrapping a sub-LLM inside a tool backfires — "increases latency and actually reduces the quality of the output" | `designing-agents` → "a sub-LLM wrapped inside an output tool to fix tone" | PRIMARY | Armin Ronacher, "Agent Design Is Still Hard" — https://lucumr.pocoo.org/2025/11/21/agents-are-hard/ |
| Sub-agent as failure firewall: run an iteration-prone subtask inside it until success, return only success + brief note of what didn't work | `designing-agents` → "Same move as a **failure firewall**" | PRIMARY | Armin Ronacher, "Agent Design Is Still Hard" — https://lucumr.pocoo.org/2025/11/21/agents-are-hard/ |
| Concurrent writers diverge because "actions carry implicit decisions, and conflicting decisions carry bad results" | `designing-agents` → "carries an implicit decision the others can't see" · `dispatching-parallel-agents` → "Writers diverge, and the merge costs more than the fan-out saved" | PRIMARY | Walden Yan, Cognition, "Don't Build Multi-Agents" — https://cognition.ai/blog/dont-build-multi-agents (the canonical Flappy-Bird divergence; Principle 1: share full agent traces, not just messages) |

### evals
| Claim (short) | Anchor | Category | Source / note |
|---|---|---|---|
| Over-optimizing a *legitimate* metric degrades the real thing (Goodhart) — NIAH recall / factual-consistency examples | `evals` → "Over-optimizing even a *legitimate* metric degrades the real thing (Goodhart)" | PRIMARY | Yan/Bischof/Frye/Husain/Liu/Shankar, "What We've Learned From a Year of Building with LLMs" — https://applied-llms.org/ |
| Don't do eval-driven development — write evaluators for failures you discover, not imagine (infinite failure surface) | `evals` → "Write evaluators for failures you discover, not failures you imagine" | PRIMARY | Hamel Husain & Shreya Shankar, "LLM Evals FAQ" — https://hamel.dev/blog/posts/evals-faq/ |
| Baseline factual-inconsistency floor 5–10%, hard to push below ~2% even on simple tasks | `evals` → "the baseline factual-inconsistency rate runs **5–10%**" | PRIMARY | applied-llms.org ("baseline rate of 5 - 10% … below 2%"); corroborated by Eugene Yan, "Task-Specific LLM Evals that Do & Don't Work" — https://eugeneyan.com/writing/evals/ |
| Logging response + judge critique + verdict and reviewing with stakeholders lifted judge↔human agreement 68% → 94% over three iterations | `evals` → "lifted agreement from **68% to 94% over three iterations**" | PRIMARY | applied-llms.org ("Over three iterations, agreement … improved from 68% to 94%!") |

### agent-security
| Claim (short) | Anchor | Category | Source / note |
|---|---|---|---|
| The model is not the security boundary — the authoritative control is system-level, not the model flagging an injection | `agent-security` → "the authoritative control is a system-level one" | PRIMARY | Fouad Matin (OpenAI), "Securing Code-Executing AI Agents" — https://www.youtube.com/watch?v=w7IMuYsBNr8 ("your most … authoritative control is going to be a system level control") |
| Prompt injection is an unsolved frontier problem; managed network policy blocks exfil destinations at the system layer | `agent-security` → "Prompt injection remains a frontier, unsolved problem" | PRIMARY | OpenAI, "Running Codex Safely" — https://openai.com/index/running-codex-safely/ ; Simon Willison, "2025: The Year in LLMs" — https://simonwillison.net/2025/Dec/31/the-year-in-llms/ |
| Sandbox (technical boundary) vs approval policy (when to ask) are separate layers; graded approvals escape approval-fatigue; "hasn't burned me yet … and that's the problem" | `agent-security` → "hasn't burned me yet… and that's the problem" | PRIMARY | OpenAI, "Running Codex Safely" (sandbox/approval split); Simon Willison (normalization-of-deviance) |

### dispatching-parallel-agents
| Claim (short) | Anchor | Category | Source / note |
|---|---|---|---|
| Coding has far fewer truly parallelizable tasks than research; agents aren't yet great at real-time coordination | `dispatching-parallel-agents` → "coding has far fewer truly parallel seams" | PRIMARY | Anthropic, "How we built our multi-agent research system" — https://www.anthropic.com/engineering/multi-agent-research-system |
| Large artifacts: write to filesystem, return a lightweight reference; routing everything through the orchestrator is a "game of telephone" | `dispatching-parallel-agents` → "return a lightweight reference (a path)" | PRIMARY | Anthropic, "How we built our multi-agent research system" — https://www.anthropic.com/engineering/multi-agent-research-system |
| Partition on a stable interface, not an arbitrary file boundary (separate repos / stable APIs / clean interfaces) | `dispatching-parallel-agents` → "Cut the seam at a *stable interface*" | PRIMARY | Adrian Cockcroft, "Directing a Swarm of Agents for Fun and Profit" (InfoQ) — https://www.infoq.com/presentations/coding-agents/ |

### batched-implementation
*(No body change — these ground claims the skill already states.)*
| Claim (short) | Anchor | Category | Source / note |
|---|---|---|---|
| Give the agent a check it can run — "the difference between a session you watch and one you walk away from" | `batched-implementation` → "An implementer told how to check its own work" | PRIMARY | Anthropic, "Best Practices for Claude Code (agentic coding)" — https://code.claude.com/docs/en/best-practices |
| The most useful specs are self-contained — name files/interfaces, state what's out of scope, end with an end-to-end verification step | `batched-implementation` → "The dispatch prompt is the contract; it must stand alone" | PRIMARY | Anthropic, "Best Practices for Claude Code" — https://code.claude.com/docs/en/best-practices |
| "If you could describe the diff in one sentence, skip the plan" (anti-overkill tier boundary) | `using-compound-v` → "describe the whole diff in one sentence, skip the plan" (moved from `batched-implementation`) | PRIMARY | Anthropic, "Best Practices for Claude Code" — https://code.claude.com/docs/en/best-practices |
| Commit as a rollback point: snapshot mid-session, revert to the prior commit and retry with more guidance; keep the tree mergeable | `batched-implementation` → "rolls back to the last known-good point" | PRIMARY | Mitchell Hashimoto, "Agentic Engineering in Action" — https://www.youtube.com/watch?v=XyQ4ZTS5dGw ; "either mergeable or it is not," Lopopolo, "Extreme Harness Engineering" — https://www.latent.space/p/harness-eng |

### product-taste
| Claim (short) | Anchor | Category | Source / note |
|---|---|---|---|
| Users sense care in a thing — and even more reliably sense carelessness — without being able to name it | `product-taste` → "even more reliably, they sense *carelessness*" | PRIMARY | Jony Ive & Patrick Collison, Stripe Sessions 2025 — https://www.youtube.com/watch?v=wLb9g_8r-mE |
| Good taste is real: no total order of works, but a partial one — so taste can be trained | `product-taste` → "no *total* order of works exists, but a *partial* one does" | PRIMARY | Paul Graham, "Is There Such a Thing as Good Taste?" — https://www.paulgraham.com/goodtaste.html (upgrades prior JUDGMENT-CALL/Olah-thematic grounding) |
| Gesture trigger timing: lightweight actions fire during the gesture; destructive actions only on gesture end | `product-taste` → "fire **lightweight** actions (a peek, an overlay) *during* a gesture" | PRIMARY | Rauno Freiberg, "Invisible Details of Interaction Design" — https://rauno.me/craft/interaction-design |
| The six-check animation gate (natural / fast / purpose / 60fps / interruptible / accessible) | `product-taste` → "Run every motion through six checks" | PRIMARY (source-of-record) | Emil Kowalski, "Great Animations" — https://emilkowal.ski/ui/great-animations (the prior "canonical" 200–300ms knob has its source-of-record here) |

### startup-taste
| Claim (short) | Anchor | Category | Source / note |
|---|---|---|---|
| Best consumer apps run 60–85% DAU/MAU; median gen-AI app ~14% | `startup-taste` → "**60–85% DAU/MAU**" | PRIMARY | Sonya Huang & Pat Grady, Sequoia, "Generative AI's Act Two" — https://sequoiacap.com/article/generative-ai-act-two/ (pins the previously-uncited retention decimals) |
| Raw data moats are shaky (the next foundation model can erase them); durable advantage is workflow + user network — "the moats are in the customers, not the data" | `startup-taste` → "a raw data flywheel is shaky" | PRIMARY | Sequoia, "Generative AI's Act Two" — https://sequoiacap.com/article/generative-ai-act-two/ ; a16z, "Why AI Moats Still Matter" — https://www.youtube.com/watch?v=fgzr3PhzIMk (capability is differentiation, not defensibility) |
| Be the last mover, not the first; overvalue durability, undervalue growth | `startup-taste` → "**Last mover, not first.**" | PRIMARY | Peter Thiel, "Competition is for Losers" (Stanford/YC) — https://www.youtube.com/watch?v=3Fx5Q8xGU8k |

### critical-thinking
| Claim (short) | Anchor | Category | Source / note |
|---|---|---|---|
| Be fastidious about *degree* of belief — unexamined, the probable hardens into the certain | `critical-thinking` → "the probable hardens into the certain" | PRIMARY | Paul Graham, "How to Think for Yourself" — https://paulgraham.com/think.html (already cited in the same gate) |

---

## Recheck pass additions (2026-06-27)

*Grounding for a recheck-and-improve pass across the kit. Each claim was checked against a public source and adversarially verified before shipping; per kit style the claims live in the skill bodies and are grounded here.*

### code-review
| Claim (short) | Anchor | Category | Source / note |
|---|---|---|---|
| Widen the bug lens from changed lines to the **contract** — trace callers/callees of every modified symbol and pull just the directly-connected files; a change often breaks a dependency it never touches | `code-review` → "Then widen to the **contract**" | PRIMARY | CodeRabbit, "How CodeRabbit delivers accurate AI code reviews on massive codebases" — https://www.coderabbit.ai/blog/how-coderabbit-delivers-accurate-ai-code-reviews-on-massive-codebases ("Codegraph" builds a map of definitions/references, traverses related files, and surfaces "bugs outside the diff range" / broken dependencies). The "load the contract, not the repo" framing is owned by context-engineering. |
| At high/ultra or when no CI is wired up, run the static-analysis tools yourself and have the model **triage** each finding for real-in-this-diff relevance — model as a filter on top of the tools, not a re-derivation of CI | `code-review` → "run the static-analysis tools yourself and have the model triage" | PRIMARY | CodeRabbit, "How CodeRabbit's agentic code validation helps with code reviews" — https://www.coderabbit.ai/blog/how-coderabbits-agentic-code-validation-helps-with-code-reviews (integrates static tools into the pipeline; a "verification agent checks each one for accuracy, relevance, and usefulness — filtering out noise"). |
| Gate false positives cheapest-first — deterministically drop any finding whose cited line doesn't map to a real changed line *before* spending on confidence scoring; a hallucinated location is the most common, and cheapest-caught, false positive | `code-review` → "check every cited location against the file" | PRIMARY | Graphite — Diamond review pipeline's line-range validation layer: a deterministic scorer asserts each review comment maps to a real changed line in the diff and drops the rest. |

### context-engineering
| Claim (short) | Anchor | Category | Source / note |
|---|---|---|---|
| Circuit breaker on the compaction loop — abort after N consecutive failures (3 is a reasonable default) rather than retrying forever; runaway compaction burns API calls indefinitely | `context-engineering` → "abort after a few consecutive failures (3 is a reasonable default)" | PRIMARY | Anthropic — Claude Code context-management (auto-compaction halts after consecutive compaction failures to stop runaway API spend). Bounded-retry framing reused from compound-v:make-it-stable. |
| On truncation (head-and-tail slicing), leave an explicit gap placeholder ("skipped N messages") at the seam — silent truncation makes the model reconstruct the missing span and hallucinate | `context-engineering` → "leave an explicit gap placeholder" | PRIMARY | Microsoft AutoGen — `HeadAndTailChatCompletionContext` inserts a `UserMessage("Skipped N messages.")` between head and tail — https://github.com/microsoft/autogen |

### ai-system-reliability
| Claim (short) | Anchor | Category | Source / note |
|---|---|---|---|
| Rainbow deployments for long-running agents — context window + checkpoint format are pinned to the start version, so a mid-run version cutover corrupts in-flight state; keep running agents on their start-version until they finish | `ai-system-reliability` → "a *rainbow deployment*" | PRIMARY | Anthropic, "How we built our multi-agent research system" — https://www.anthropic.com/engineering/multi-agent-research-system (rainbow deployments gradually shift traffic old→new while keeping both running, to avoid disrupting running agents). Same source already cited at `ai-system-reliability` → "keep every write single-threaded". |
| Name the failure mode before targeting it — agents break in distinct, separately-fixable ways (agentic laziness, self-preferential bias, goal drift); generic "reliability work" targets none | `ai-system-reliability` → "agentic laziness" | PRIMARY | Anthropic — "A harness for every task: dynamic workflows in Claude Code" (claude.com/blog) names agentic laziness, self-preferential bias, and goal drift as distinct harness-addressable failure modes. |
| Every reliability constraint has a shelf life — tag each workaround with its model version and review it for deletion on each model release; scaffolds become capability overhang and a reliability fix can curdle into a reliability bug | `ai-system-reliability` → "tag each workaround you added" | PRIMARY | Thibault Sottiaux (OpenAI Codex), "Scaffolding is coping not scaling" (Dev Interrupted) — https://devinterrupted.substack.com/p/scaffolding-is-coping-not-scaling (harness is temporary infra to remove over time; over-built scaffolding creates capability overhang). General delete-on-release thesis is owned by compound-v:architecting-ai-systems. |

### designing-agents
| Claim (short) | Anchor | Category | Source / note |
|---|---|---|---|
| Fix the tool, not the prompt — treat a misused tool as an eval target: run it many times, watch the model trip, rewrite the interface/description in the agent's own voice; a dedicated tool-testing pass cut task-completion time ~40% | `designing-agents` → "Fix the tool, not the prompt around it" | PRIMARY | Anthropic, "Writing effective tools for AI agents" — https://www.anthropic.com/engineering/writing-tools-for-agents (rewrite descriptions in the model's voice; model-vs-human ergonomics) and "How we built our multi-agent research system" — https://www.anthropic.com/engineering/multi-agent-research-system (tool-testing agent → "40% decrease in task completion time for future agents"). |

### dispatching-parallel-agents
| Claim (short) | Anchor | Category | Source / note |
|---|---|---|---|
| Asymmetric model tier — frontier model at the orchestration/synthesis layer, a cheaper/faster model at the parallel worker layer — beat a single frontier agent by ~90% | `dispatching-parallel-agents` → "beating a single frontier agent by ~90%" | PRIMARY | Anthropic, "How we built our multi-agent research system" — https://www.anthropic.com/engineering/multi-agent-research-system ("Claude Opus 4 lead + Claude Sonnet 4 subagents outperformed single-agent Claude Opus 4 by 90.2%"). Tier names kept out of the skill body (model-agnostic). |

### verification-before-completion
| Claim (short) | Anchor | Category | Source / note |
|---|---|---|---|
| A piped verifier (`clippy \| tail`, `pytest \| tee`) reports the pipeline's last-stage exit code, not the tool's — it can read green while hiding failures; use `set -o pipefail` or read `${PIPESTATUS[0]}` | `verification-before-completion` → "read `${PIPESTATUS[0]}`" | PRIMARY | Standard POSIX/bash shell semantics — pipeline `$?` is the last command's status; `pipefail` / `PIPESTATUS` recover the real status (GNU Bash manual; POSIX shell). |

### agent-security
| Claim (short) | Anchor | Category | Source / note |
|---|---|---|---|
| Structural absence beats a call-time gate — omit the privileged tool / agent-to-agent edge from the registry at construction; an injection can't reach a decision point that doesn't exist, whereas a runtime check is still reachable | `agent-security` → "prefer *structural absence* over a call-time gate" | PRIMARY | Attack-surface-reduction / minimal-tooling is established agent-security canon (Anthropic engineering); construction-time declaration of allowed agent-to-agent edges is the Agency Swarm `communication_flows` model — github.com/vrsen/agency-swarm. |

### product-taste
| Claim (short) | Anchor | Category | Source / note |
|---|---|---|---|
| Agentic transcript is its own design surface — discriminate block types (reasoning/tool-call/diff/approval), render approvals inline (not modal) adjacent to the prompting reasoning, collapse tool calls to expandable capped-height rows, reserve color for semantic meaning | `product-taste` → "Discriminate the block types" | PRIMARY | OpenAI Codex app — typed conversation/thread items (message, tool execution, approval request, diff) with approvals rendered inline with the active turn; developers.openai.com/codex. |

### systematic-debugging
| Claim (short) | Anchor | Category | Source / note |
|---|---|---|---|
| For a wrong AI answer, debug from the raw context the model received (not the rendered output); if you can't derive the answer from that context, the bug is retrieval not the prompt — force answer-only-from-provided-context to localize | `systematic-debugging` → "localize retrieval vs prompt" | PRIMARY | Jake Heller (Casetext/CoCounsel), "Context Engineering: Lessons from Scaling CoCounsel" (YC AI Startup School); "answer only from provided context" is a standard RAG grounding/diagnosis technique. |

---

## Adapted from superpowers v6.0.3 (2026-06-27)

*Content-gap pass against superpowers v6.0.3 (github.com/obra/superpowers). Most shared skills were at parity or ahead; these four techniques were genuinely missing and adapted into the kit's own voice. (Their "receiving code review" discipline was found already covered by `batched-implementation`'s "Responding to findings"; their "praise the author first" reviewer directive was rejected as conflicting with the kit's anti-sycophancy stance.)*

| Claim (short) | Anchor | Category | Source / note |
|---|---|---|---|
| Capture a **green baseline** — run the suite before editing; if already red, stop and surface it — so a later failure is attributable to your change, not a pre-existing one | `batched-implementation` → "Capture a **green baseline**" | JUDGMENT-CALL | Standard engineering practice; spelled out as a pre-implementation step in superpowers `using-git-worktrees` (github.com/obra/superpowers). |
| **Compaction-resume protocol** — after a compaction/restart, reconcile against `git log` before dispatching; resume from the last commit whose trailer names this plan; anything after it is unverified work in progress, never re-dispatch verified work | `batched-implementation` → "reconcile against `git log` before dispatching anything" | PRIMARY | superpowers `subagent-driven-development` names controller re-dispatch of completed task sequences after compaction as its most expensive observed failure and defends with a durable ledger + "trust git log over recollection" (github.com/obra/superpowers). Durable-state-survives-the-window framing owned by `compound-v:context-engineering`. |
| Plan preamble carries the **global constraints every task must honor** (version floors, dependency limits, naming/security/perf rules, platform requirements), one line each — a fresh batch implementer sees only its own tasks and regresses unstated constraints to defaults | `writing-plans` → "the **global constraints every task must honor**" | PRIMARY | superpowers `writing-plans` "## Global Constraints" header block (github.com/obra/superpowers). |
| **Hard to test is a design signal** — heavy mocking / sprawling setup / convoluted assertions mean the code is too coupled or the seam is wrong; fix the design, not the test | `test-driven-development` → "Hard to test is a design signal" | PRIMARY | Test-driven-design feedback loop (Kent Beck, *Test-Driven Development: By Example*; Michael Feathers on testability as a design smell); surfaced in superpowers `test-driven-development` "When Stuck" (github.com/obra/superpowers). |

---

## Deep investigation pass additions (2026-07-06)

*Parallel-agent source sweep (superpowers 6.1.1, production coding-agent research, founder/builder transcripts, primary essays). Net effect: dedupe + shrink + a handful of grounded atoms; no new skills. Grounding fixes from the same pass are folded into the rows above (Willison five-tokens correction; Masad reliability row corrected to a judgment call).*

| Claim (short) | Anchor | Category | Source / note |
|---|---|---|---|
| A regression test only proves it has teeth if it **fails without the fix** — revert the fix, watch it go red, restore; running it once green doesn't prove it would have caught the bug | `verification-before-completion` → "revert the fix, watch the test go red, restore it" | ADAPTED | superpowers verification "Regression tests (TDD Red-Green): Write → Run (pass) → Revert fix → Run (MUST FAIL) → Restore" (github.com/obra/superpowers); the retroactive form of standard red-green discipline. |
| Prune a harness patch once the model catches up — a workaround built for a past model's weakness is deletable scaffolding, not permanent architecture | `startup-taste` → "cut a nudge-hack and ~20% of its system prompt" | PRIMARY | Cat Wu (Head of Product, Claude Code, Anthropic), "Product management on the AI exponential" — https://claude.com/blog/product-management-on-the-ai-exponential (cut a nudge-hack and ~20% of system-prompt volume once a new model stopped needing it). |
| Verifiability is a problem-*selection* filter, not just a prerequisite — prefer the wedge whose feedback loop is fastest; where checking is cheap (code, math) agents go superhuman | `startup-taste` → "Verifiability is also a problem-*selection* filter" | DIRECTIONAL | Michael Truell (Cursor) on pivoting from CAD to code for the instant feedback loop (public Cursor origin talks); a16z on RL agents being superhuman only where clean verifiers exist. |
| Reliability is **threshold-shaped, not linear** — below the bar users abandon and no habit forms (a demo, not a product); the first team over the bar in a new category tends to take it. Measure on the **messy real distribution, never the demo** | `startup-taste` → "Reliability is *threshold-shaped*, not linear" | DIRECTIONAL | Reliability-as-habit-formation (Assembly / Amazon Echo vs Siri, public builder talks); "the demo is a cherry-picked example... test on the 50K-line monorepo with bad names" (Cursor, public talks). No hard decimal claimed. |
| The input **affordance gap** — a bare prompt box looks identical to a login field and signals nothing; bake a known capability into a visible control instead of forcing trial-and-error prompting | `product-taste` → "a bare prompt box looks identical to a login field" | PRIMARY | Amelia Wattenberger, "Why Chatbots Are Not the Future" — https://wattenberger.com/thoughts/boo-chatbots/. |
| Make "nothing to report" an explicit, equally-valid **action** (`finish_review(comments:0)`), not an absence of output — free-text review prompts manufacture nits because silence reads as failure; the switch cut hallucinations ~9:1 → ~1:1 | `code-review` → "a `finish_review(comments: 0)` action" | PRIMARY | Graphite / Diamond, "The practical and philosophical problems with AI code review" — https://graphite.com/blog/problems-with-ai-code-review (function-calling with a no-finding branch). |
| For a large retrieved/assembled payload in the prompt, use **XML-style tags, not JSON** — tags read like trained-on prose and act as navigation anchors in long context; JSON structural chars are token overhead | `context-engineering` → "wrap it in **XML-style tags, not JSON**" | PRIMARY | Anthropic prompt-engineering guidance on XML tags (canonical): tags are trained-on structure the model tracks better than nested JSON as context grows. |
| Durability is a **separate axis** from the capability ladder — any rung can run ephemeral by default and be promoted to durable with a flag, never a rewrite; an HITL approval gate must be **checkpoint-backed** (resume hours later / a different process; idempotent up to the request) | `designing-agents` → "Durability is a separate axis from this ladder" · `ai-system-reliability` → "write-before-advance" | PRIMARY | Durable-execution practice: DBOS / Temporal durable workflows, LangGraph `Durability` mode; write-before-advance and idempotent human-in-the-loop resume. |
| Match the **form** to the failure (prohibition table for a discipline miss; positive recipe for a shaping miss; a prohibition list *backfires* on shaping) + cheap micro-test wording (no-guidance control, 5+ reps, variance-as-signal) | `references/skill-format.md` → "Match the *form* to the failure" | ADAPTED | superpowers "writing-skills" — "Match the Form to the Failure" wording-test results and micro-test method (github.com/obra/superpowers). |
| Run quality evals **continuously on real production traffic**, not just pre-deploy — a system that recovers from isolated errors hides serving/inference bugs from a pre-deploy eval | `ai-system-reliability` → "Run quality evals continuously on real production traffic" | PRIMARY | Character.AI engineering, "Optimizing AI Inference at Character.AI" (the reliability/durability angle; KV/prefix-cache mechanics belong to `context-engineering`). |

---

## RETIRED

*Rows whose claim no longer appears in the shipped skill after the 2026-07 rewrite. Kept, not deleted,
so the history of what was once claimed (and what it was grounded on) survives. Do not re-cite a
retired row without first re-adding the claim to a skill and giving it a fresh anchor.*

| Claim (short) | Was anchored to | Category | Retirement note |
|---|---|---|---|
| Attention scales as **n²** pairwise relationships; "attention budget" | `context-engineering:22` | was PRIMARY (Anthropic, "Effective context engineering for AI agents" — https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents) | **Cut and actively reversed.** The skill now says the opposite: "Resist the tidy architectural story about attention arithmetic; the mechanism is not settled, and a wrong mechanism will point you at the wrong lever." Do not re-add without resolving that contradiction first. |
| "You're a senior software engineer" / "think for longer" = gimmicky prompt-engineering | (cross-kit red flag) | was PRIMARY (Cognition, "Multi-Agents: What's Actually Working" — https://cognition.ai/blog/multi-agents-working) | Cut. The phrasing appears in no skill in the kit; the row had no anchor to begin with. |
| Character.AI serving moat: **int8-native training**, KV-cache reduced **>20X**, a **95%-hit prefix cache**, serving cost cut **~33x** | `ai-system-reliability:45` | was PRIMARY (Character.AI engineering, "Optimizing AI Inference at Character.AI" — https://blog.character.ai/optimizing-ai-inference-at-character-ai-2/) | Cut. The skill now only points at the source's reliability angle and hands the serving-stack mechanics to `context-engineering`, where none of these four figures appear either. The same URL still grounds the surviving "run quality evals continuously on real production traffic" row. |
| Innovation tokens — spend the scarce novel-tech budget only on the genuinely new part | `simplest-thing-that-works:35` | was PRIMARY (Dan McKinley, "Choose Boring Technology" — https://mcfunley.com/choose-boring-technology) | Cut *from this skill only*. The claim still ships in `architecting-ai-systems` and `startup-taste`, each with its own live row above; this duplicate had no remaining anchor. |
| Cheapest rung of parallelism is below sub-agents: within one turn, issue independent reads/searches as parallel tool calls (sequential only when one's output feeds the next) | `dispatching-parallel-agents` | was PRIMARY (frontier coding-agent system prompts; public corpus at github.com/x1xhlol/system-prompts-and-models-of-ai-tools) | Cut. `dispatching-parallel-agents` no longer mentions parallel tool calls at all; its cheapest rung is now "just run Glob/Grep yourself." |

**Two rows kept but narrowed** (anchored to what survives; flagged here so nobody reads the ledger as
proof the skill still says the whole thing):

- *"Before a destructive discard, the at-risk work to surface is precisely uncommitted changes, untracked files, and unpushed commits"* — `finishing` now surfaces **only unpushed commits**; "untracked" appears nowhere in the kit. The row is anchored to "the work that would vanish unrecoverably".
- *"~4 is the practical optimal … ('Claude Code cyber psychosis')"* — the **~4 ceiling survives**; the "cyber psychosis" coinage was cut and appears nowhere in the kit.

---

## UNGROUNDED — needs a source or a judgment-call ruling

*Claims that are live in a shipped skill and have **no row anywhere above**. Found by extracting every
sentence carrying a digit / percentage / "×" / named measurement from all 26 `skills/*/SKILL.md` and
checking each against this ledger. Nothing here is invented grounding — these are open items for the
owner: either attach a public primary source, or rule the row a JUDGMENT-CALL / recipe knob.
Ordered highest-risk first: an unsourced **specific number presented as a measurement** is the kit's
worst failure mode, because it reads as evidence.*

### P0 — a specific number presented as a measured result, no source

| # | Skill · anchor | The claim, quoted | Why it's P0 |
|---|---|---|---|
| 1 | `frame-the-goal` → "a median real prompt runs ~390 characters" | "a median real prompt runs **~390 characters** against **1,185–3,055** for benchmark tasks, while the median change it actually asks for is **~181 lines** against **7–10**" | Five precise figures, phrased as a study result, opening the skill's central argument. Highest-priority item in this list. Needs the paper/post it came from or it must go directional. |
| 2 | `code-review` → "the diff alone (~17k tokens)" | "the diff alone (**~17k tokens**) **missed** a planted cross-file bug, every connected file (**~110k**) found it, and *only* the direct callers and callees found it at **~18.3k** — an **~8%** token increase is the entire difference" | Explicitly labelled "This is measured, not a hunch." Four numbers from what reads like a controlled experiment. If it's an internal experiment, say so in the skill (the kit publishes only public sources). |
| 3 | `evals` → "a naive baseline slide deck nobody would defend" | "a naive baseline slide deck nobody would defend scored **2.8–4 on a 0–5 scale**" | RESOLVED-IN-PART: the figure is real and public (an Anthropic conference talk on hill-climbing a slide agent). Two over-reads were corrected in the skill on 2026-07-25 — the deck was a naive baseline, not "deliberately ugly", and the scale is 0–5 not 1–5. A second example (an image judge returning 5/5 for a deck with no image) was **cut**, not softened: that judge's own rubric said not to penalise a slide with no image, so it was obeying its prompt rather than miscalibrated. Still needs a row; the talk does not itself argue for binary judges. |
| 4 | `evals` → "One model jumped from 42% to 95%" | "One model jumped from **42% to 95%** on a benchmark purely by fixing the grading." | Named-shaped result ("one model", "a benchmark") with no benchmark, model, or source. |
| 5 | `evals` → "moved a PR success rate from ~20–30% to ~80%" | "One production LLM judge that had moved a PR success rate from **~20–30% to ~80%** was deleted outright once the models got good enough" | Reads as a specific production anecdote; carries the "scaffolding expires" rule. |
| 6 | `context-engineering` → "measured at **6,000–14,000 tokens each**" | "individual tool definitions have been measured at **6,000–14,000 tokens each**, so a dozen loosely-curated tools can outweigh the entire conversation" | The word "measured" makes this a claim about the world, not a knob. |
| 7 | `context-engineering` → "Treat cache hit rate as a first-class metric" | "Well-built coding agents measure in the 80s; the best measured sits around 92%" | RESOLVED-IN-PART: "major agent products run 90%+" was **overstated** and was corrected on 2026-07-25 — measured production data puts one coding agent at 92% and most in the 80s. The "alert on it like uptime" framing is Anthropic's own and is sound; no primary source prescribes a target hit rate, so no bar is asserted. |
| 8 | `designing-agents` → "roughly 72% to 90%" | "in one measurement it took a tool's correct-use rate from roughly **72% to 90%**" | "In one measurement" with no measurement cited. (The adjacent ~40% task-completion figure in the same section *is* grounded — Anthropic's multi-agent post — which makes the ungrounded neighbour easy to mistake for grounded.) |
| 9 | `context-engineering` → "roughly half an hour of deliberation" | "a single conflicting piece of context has sent a model into roughly **half an hour** of deliberation" | A specific observed duration, used to justify "contradiction is more expensive than vagueness." |
| 10 | `dispatching-parallel-agents` → "3 subagents against a hard cap of 20" | "A shipped research orchestrator … defaults to **3 subagents against a hard cap of 20**" | Attributed to a named-but-unnamed shipped product; verifiable if the product is named. |
| 11 | `dispatching-parallel-agents` → "**~3.75× the tokens of the single agent it beat**" | "it burned **~3.75× the tokens** of the single agent it beat" | The ~90% and ~80%-variance figures beside it are grounded to Anthropic's multi-agent post; this third figure is not covered by the existing row and should be checked against the same source (the post's published figure is ~15× vs. *chat*, which is a different denominator). |
| 12 | `dispatching-parallel-agents` → "burns 2–3× the turns" | "the cheap model routinely burns **2–3×** the turns anyway, so the saving is often imaginary" | A cost claim used to override a user-visible default (worker model tier). |
| 13 | `verification-before-completion` → "something ~10,000× different" | "the printed variable says one thing, the summary sentence says something **~10,000×** different" | Reads as a specific observed incident. Either cite it or drop to "wildly different." |

### P1 — an empirical/attributable claim with no number, and no row

| # | Skill · anchor | The claim, quoted | Note |
|---|---|---|---|
| 14 | `recheck` → "across formal reasoning domains" | "across formal reasoning domains, a model asked to critique and revise its own output **often makes the result *worse***, the critique manufacturing both false positives and false negatives, and out of the box a model is **no better at verifying than at generating**" | This is a literature claim (there is a real self-correction/self-critique literature) doing heavy lifting: it's the stated reason step 5 refuses a verdict without an executed check. It is the single most citable unsourced claim in the kit. |
| 15 | `evals` → "`git remote remove origin`" | an agent could "solve" a SWE-bench instance by `git pull`-ing the future commit; "the harness defensively runs **`git remote remove origin`**"; and "a model has scored well on a coding benchmark by reading **its own previous trials out of the git history**" | Two concrete, checkable facts about a public benchmark harness and a specific observed gaming behaviour. Both are verifiable — the SWE-bench harness is public. |
| 16 | `designing-agents` → "Requiring **absolute paths**" | "Requiring **absolute paths** instead of relative ones **eliminated a whole error class on real benchmarks**" | "On real benchmarks" is an empirical claim. Plausibly the same Anthropic "Building effective agents" / SWE-bench-agent lineage already cited elsewhere — worth pinning to it explicitly rather than leaving it floating. |
| 17 | `designing-agents` → "cannot reliably tell when it doesn't know" | "a worker **cannot reliably tell when it doesn't know**, and closing that small-model-to-large escalation gap is **an openly unsolved problem**" | A claim about the state of the field; needs a pointer or a hedge. |
| 18 | `context-engineering` → "comparable to a jump in model scale" | "Loading the *right* large body of context … can make the model dramatically better at the task, **comparable to a jump in model scale**, because it's learning in-context" | An empirical magnitude comparison with no source, sitting directly beside the well-grounded Context-Rot row — an easy place for a reader to assume grounding by proximity. |
| 19 | `startup-taste` → "how would you feel if you could no longer use this?" | "The field-standard read: survey users with **'how would you feel if you could no longer use this?'** and build for the segment that answers *very disappointed*" | This is the Sean Ellis PMF test by name-in-all-but-name. Cheap to ground and worth doing precisely because the skill wisely omitted the usual 40% threshold — the source should record why. |
| 20 | `recheck` + `writing-plans` → "two blocking bugs" | "a **100%-green** conformance check sits happily on top of **two blocking bugs**" (recheck) / "a plan can be **100% conformant** and still ship **two blocking bugs**" (writing-plans) | The same specific incident asserted in two skills. If it's an internal observation it can't ship as a public-source claim under the kit's own rule — rule it a stated engineering principle or attach a source. |
| 21 | `agent-security` → "found and bountied" | "a real vulnerability of exactly this shape has been **found and bountied**" | The adjacent GitHub-MCP-exploit row grounds the *shape*; "found and bountied" for the **PR-review** path specifically is a separate factual claim. |

### P2 — recipe knobs and stylistic defaults: probably fine as JUDGMENT-CALL, just need the ruling written down

These are numbers, but they're the skill's own tuning constants rather than claims about the world.
Recommend ruling each JUDGMENT-CALL / recipe-knob and adding one covering row, rather than hunting
sources that don't exist:

- `architecting-ai-systems` → "the 10–30% success band" and "roughly 18 months out" — an inference *from* the grounded METR 7-month doubling, not itself a measured band. Worth saying so, since it's stated as flatly as the METR figure it derives from.
- `writing-plans` → "Cap the plan at 200 lines" (and "a 200-line plan … the 2,000-line diff") — authoring knob.
- `evals` → "roughly **20 queries** finds the gross failures"; "**~100 is a reasonable floor**" for trace reading — sample-size knobs; adjacent to, but not covered by, the existing 30-100 / 25-50 row.
- `evals` → "75% per trial is about 42% over three" — self-evident arithmetic (0.75³), needs nothing.
- `designing-agents` → "retrieve the ~5 tools a task needs over a list of 50" — illustrative ratio.
- `dispatching-parallel-agents` → "more than ~3 queries earns a sub-agent"; "≤500 words" return contract — dispatch knobs.
- `ai-system-reliability` → "a ~1ms checkpoint write against a >100ms LLM call" — an order-of-magnitude engineering estimate carrying a default-flip decision; cheap to justify inline, no external source available.
- `ai-system-reliability` → "Three independent critics found this same default unsafe" — internal process evidence, not a public source; rule it or drop it.
- `product-taste` → "rate-limit the rendering to a fixed characters-per-frame budget with a capped number of catch-up frames" — implementation recipe.
- `code-review` → "Cap the report at ~10–12 findings" — the same signal-density knob the `recheck` row already rules on; a cross-ref would close it.
- `batched-implementation` → "~2-8 tasks" / `using-compound-v` → "~2–8 tasks" Standard tier — covered in spirit by the tier-routing judgment-call row; worth naming explicitly.

---

## founder-distribution

Added 2026-07-28. This skill shipped with no entry here — the only skill in the kit dense with
empirical market claims and no grounding, while its own "Honest-warrant discipline" section demands
three warrant tiers and ends "A rule that no evidence could break is not a rule." This section closes
that. Thirteen load-bearing claims were traced to primary sources; **four do not survive as written**
(rows 2, 3, 5 and 7), and row 9 is actively contradicted by the literature it assumes. Two further
figures that travel with this material — the Facebook density threshold and the 2–3× willingness-to-pay
multiplier — are ruled do-not-ship at the end of the section.

| # | Claim (short) | Anchor | Category | Source / note |
|---|---|---|---|---|
| 1 | Win the first 100 on a surface that delivers value in one zero-configuration interaction; accounts, alerts and personalization are second-stage | `founder-distribution` → "a single zero-configuration interaction" | **PRIMARY** on the ordering, **SOFTEN** on universality | Dated sequencing holds across reference-data products, and the gap is years: CoinMarketCap was a top-200 global site (TechCrunch, 1 May 2018) and shipped its first mobile app with watchlists *that same day*, five years in. Etherscan's own 2015→2024 timeline lists no accounts or notifications milestone at all; its watch-list doc (17 Dec 2019) opens "All the features above are only available for our registered users." Zillow's Zestimate drew 1M visitors in three days, ungated. **Boundary:** every supporting case is a *reference-data* product whose value is a public fact a stranger verifies instantly. Glassdoor gated contribution from day one and exited at $1.2B, and GoodUI's Thomasnet A/B test found a registration wall produced a **+1135% relative lift in signups** (with −18% engagement, which is why the team refused to ship it). State the conditional, not the universal. |
| 2 | Several analytics tools scaled to millions with **no push feature at all** | `founder-distribution` — no anchor (claim cut) | **WRONG as written — replace** | No source supports it. CoinMarketCap shipped watchlists in its year-5 app; Etherscan documented account-gated email alerts in Dec 2019; Similarweb and Ahrefs both sell alerting today. The defensible claim is the *sequencing* one: alerts arrived at year 4–5 as a retention layer on an existing base, never before scale. Note the symmetry — the push-retention literature that would contradict the skill (Airship's 63M-user benchmark, Kahuna's 45.3% vs 20.4%) is published by push vendors selling push, so **neither direction is independently measured.** |
| 3 | Almost every company got its first thousand users through **one** channel, not a portfolio of five | `founder-distribution` — no anchor (claim cut) | **WRONG as written — SOFTEN to the sequencing claim** | The frequency claim is a universal quantifier with no counting behind it; no dataset counts channels per company at any stage. Traction's actual sentence carries a precondition the skill drops: "we suggest focusing on one at a time, **but only after you've identified a channel that seems like it could actually work**", and Bullseye deliberately runs ~3 channels in parallel at the test stage. The book makes no first-thousand claim — co-author Justin Mares assigns that stage to Phase I: "giving talks, writing guest posts, emailing people you have relationships with, attending conferences", four of the nineteen channels at once. The widely-cited "70% from one channel" traces to a growth-SaaS vendor page with no study, sample, or stage definition. Survivorship bias is a named, unanswered objection (Gudema). |
| 4 | A gate is accretive **only when all four** hold: no network effects on the gated side · screens on fit · non-transferable admission · live capacity constraint | `founder-distribution` → "Treat these as pressure, not as a rule with four boxes to tick" | **JUDGMENT-CALL** as a heuristic; **not** a measured regularity | Per condition: **(a) SOFTEN** — Bluesky confirms (3.14M→5.1M in the month after opening), but Gmail, Clubhouse and Facebook all gated network-effects products and grew. **(b) UNTESTED** — no case anywhere measures fit or retention differences between gated and ungated cohorts. **(c) WRONG** — contradicted by the three largest gated user bases in the case set. **(d) JUDGMENT-CALL** — the only condition with a clean record, but a real capacity limit explains why a gate is *tolerable*, not why it is *accretive*. The errors are asymmetric: every false negative (Gmail, Clubhouse, Robinhood) is a gate the rule forbids that worked. |
| 5 | The famous gate that worked was a capacity constraint coupled to a measurement program | `founder-distribution` → "Two gates are cited as the canonical success and they did not do the same thing" | **PRIMARY** on Superhuman, **WRONG** as a general lesson | Superhuman's gate was a mandatory 30-minute human onboarding (90 minutes early on), founder-run at first, and it existed so the PMF survey could run on a controlled cohort — instrumentation, not scarcity. It was also revenue-positive: each Onboarding Specialist carried ~$650k ARR against $60–130k loaded cost. **But Gmail — the most-cited gate in software — violates two of the four conditions and worked anyway.** Invites were bearer tokens with a liquid secondary market: Qin Lei (SMU) counted **63,378 invitations trading for $393,027 in three months**, 5,454 sellers across 42 countries. Google's own people call the exclusivity unintentional: "it had a side effect… it was a little bit unintentional" (Harik, TIME). The transferable lesson is not any single condition — **both gates were removed** (Gmail 14 Feb 2007; Superhuman student carve-out at PMF, then three years of engineering to self-serve). A gate is scaffolding with a scheduled demolition date. |
| — | — the hardware number beside it | `founder-distribution` → "three hundred second-hand Pentium IIIs" | **UNGROUNDED — source it or go directional** | Live in the skill and load-bearing (it is the evidence that Gmail's gate was a capacity constraint rather than exclusivity), with no row until now — the gap this ledger exists to close. The figure is widely attributed to Paul Buchheit, but no primary text is pinned to it here, so it is not yet citable as a measurement. Same class as the P0 list below: attach the source, or drop to "a rack of second-hand hardware". Do not quote the number until one of those happens. |
| — | — the condition the rule is missing | — | **ADD** | **Duration.** Every gate that measurably hurt did so through *time on the list*, not gate shape. Superhuman's own waitlist operator reports it converted **~3x worse than the concurrent live funnel**, halving for each additional year queued (3% → 1.5% → 0.8%). The four-condition rule has no variable for this and waves through Bluesky's year-long gate. Any shipped version needs a fifth clause: open within a bounded window measured in months. |
| 6 | A threshold on what *enters* a stream beats human curation at the exit | `founder-distribution` → "Fix the entry bar before you staff the exit" | **JUDGMENT-CALL**; drop the comparative framing | No study anywhere compares filter-at-ingestion against curate-at-exit and reports a winner. The measured adjacent base is clinical alarm management, and it is graded only "moderate" by AHRQ (of 17 studies: 10 QI initiatives, 5 case studies, 1 quasi-experimental). It also cuts both ways: an Apple News audit found **human curation beat the algorithm** on source diversity, while Peukert et al. found the algorithm beat human editors on clicks. The best-designed study on the premise — a micro-randomized trial on the *Drink Less* app — found each notification gave a 3.5x near-term lift and **"no overall difference in time to disengagement"** across arms. Transfer risk is real: a missed ICU alarm is a death, nurses cannot unsubscribe, and every clinical study measures alarm *count*, not response quality. Defensible reduced form: a stream that admits non-actionable items degrades response to the whole stream, and exit-side triage does not recover it (Google SRE: "Every page should be actionable"). |
| 7 | The users hurt worst by flooding are those who took the highest-friction action to arrive | `founder-distribution` — no anchor (claim cut) | **WRONG — cut it** | No supporting evidence exists; a deliberate search returned only vendor marketing. The nearest real literature points the *opposite* way — sunk-cost and investment effects predict higher-effort users are more tolerant and better retained, not more fragile. |
| 8 | Modest virality with long retention beats high virality with 30-day churn | `founder-distribution` → "modest virality and long retention beats one with high virality and 30-day churn" | **PRIMARY as arithmetic; SOFTEN as an empirical law** | Skok's model is unambiguous: users grow as `K^(t/ct)`, "Unless you have a Viral Coefficient that is greater than 1, you will not have true viral growth", and cycle time dominates K. The comparison follows *given* two stated assumptions — K is not constant (Chen: saturation and platform dependence push it under 1) and K is retention-gated ("New users won't create a viral factor >1 in their first visit"). That is a model result, not an observation; say so. Also note the framing is largely a false choice: "Most of the time, you see viral factors that are 0.2 or 0.3 or below", and Skok's own conclusion is the hybrid model — sub-1 loops **require** a paid or content source to function. |
| 9 | Fix retention **before** optimizing acquisition | `founder-distribution` → "Fix retention before optimizing acquisition" | **JUDGMENT-CALL — actively contradicted; the weakest claim in the skill** | The Ehrenberg-Bass Institute contradicts the ordering on evidentiary grounds: "The idea of plugging the leak became popular with theorists who sold the idea to practical marketers, who believed, **without any evidence**, that retention is cheaper than acquisition." Seufert: churn is more expensive later-stage than at onboarding, and a worse retention curve can be the better business. For social/network products the mechanism is bidirectional — retention is not stably measurable until acquisition supplies liquidity, so "fix retention first" is incoherent for that class. Balfour's joint-constraint framing is the replacement: a 10% flattened curve is uninterpretable without knowing whether your acquisition motion can reach the volume it implies. **What survives** is a claim about interpretation, not work order: acquisition performance carries no information about retention, so acquisition wins are not evidence of fit. |
| 10 | PMF is a number: survey "how would you feel if you could no longer use this" and build for the **40%** who answer very disappointed | `founder-distribution` → "PMF is a number — but not the number you think" | **SOFTEN — keep the question, drop the threshold as a gate** | Ellis discredits the number in the sentence that introduces it ("The Startup Pyramid", startup-marketing.com 2009 — now 404, readable only via archive.org): "**Admittedly this threshold is a bit arbitrary**, but I defined it after comparing results across nearly 100 startups." No published dataset, no control group, no operationalized outcome; MeasuringU went looking and reported "we could not find any peer-reviewed papers describing research with the PMF item." Ellis's own sample description is inconsistent ("nearly 100" vs "100s"). **Documented failure modes:** churned users are excluded *by construction* (his distribution rule surveys only people who used the product twice in the last two weeks), so a product with catastrophic retention and a devoted residue scores well; segment gaming is step one of the famous success case (Superhuman went 22%→33% before shipping any product change); at n=50 the margin of error is ±13%, so "41%" and "29%" are the same measurement; and it asks a *hypothetical* question. **Superhuman scored 22% — below the bar — and reached $100M+ ARR.** Use it as a same-segment trend line, never report a score without n, segment, activity filter and churn treatment, and treat >40% as necessary-not-sufficient (Ellis's own 2010 concession). |
| 11 | Hand-recruit the first hundred; it is research that happens to collect users | `founder-distribution` → "Hand-recruit the first hundred" | **PRIMARY** for the prescription, **SOFTEN** for the causal claim | Graham states it unhedged: "The most common unscalable thing founders have to do at the start is to recruit users manually. Nearly all startups have to." The mechanism most retellings drop is the part that matters — "Over-engaging with early users is not just a permissible technique for getting growth rolling. For most successful startups it's a necessary part of the feedback loop that makes the product good." Learning first, acquisition second: success is not "100 users", it is "the product changed as a result." **What is not primary** is the implied causation — three cases chosen after the fact. Garber (Forbes, Aug 2013) names it: "There's a reason why the author calls out Facebook, Stripe, and AirBnB as examples: they were successful!" **Three things to carry that the popular version omits:** Graham's own precondition ("if the market exists"), an **exit trigger** (he gives none, and the documented counter-case is a company that committed to a call with every user — "Guess what? It didn't scale"), and the fact that Stripe's "Collison installation" (a *closing* technique) and Stripe's manual backstage merchant-account signup (a Wizard-of-Oz *delivery* trick) are two different behaviours that most write-ups merge. |
| 12 | Interview about past behavior, never about your idea | `founder-distribution` → "What did you do the last time this happened?" | **PRIMARY** for the rule; the real warrant is stronger than the usual citation, but the usual **magnitude is WRONG** | The Mom Test states the rule ("Ask about specifics in the past instead of generics or opinions about the future") but is a self-published handbook with no data in it. The actual support is two peer-reviewed literatures nobody cites: the **intention–behaviour gap** (Sheeran & Webb 2016 — a medium-to-large change in intention produces only a small-to-medium change in behaviour, *d+* = .36; the mechanism is the "inclined abstainer", which is exactly the interviewee who sincerely says yes and never buys), and **hypothetical bias in stated preference** (Murphy et al. 2005). **The folk figure is wrong:** founders repeat that people overstate willingness to pay by 2–3x; the meta-analysis found a median hypothetical-to-actual ratio of **1.35** across 83 observations — and the authors write "only 1.35" precisely to correct this belief. Do not quote 2–3x. The better argument is the one the same paper supplies: the distribution "has severe positive skewness", so most answers are mildly inflated and a minority wildly so, and you cannot tell which you have. Variance, not a correctable bias you could divide out. |
| — | — the apparent conflict with the PMF survey | `founder-distribution` → "PMF is a number" vs "never about your idea" | **RESOLVE, do not collapse** | The skill endorses both "ask about the past, not the hypothetical future" and an item that asks "how would you feel if you could no longer use this" — which looks like a contradiction and mostly is not. Both literatures above measure people forecasting a behaviour they do **not** currently perform; the Ellis item is asked of people **already using the product**, reporting on an existing behaviour by imagining its removal. Citing *d+* = .36 as a refutation of the Ellis item misapplies the source. The real defect is different and worse for the skill: the item elicits an affective reaction and then uses it as a proxy for retention, and **that inferential leap has never been validated**. Resolution to state explicitly: the Mom Test rule governs *discovery* with non-users, where the intention–behaviour gap bites hardest; the Ellis item governs *retention diagnostics* with existing users. Different stages, different populations. Neither justifies the 40% number. |
| 13 | Counts that only go up are not metrics | `founder-distribution` → "A metric earns its place by naming an action" | **SOFTEN** — right examples, wrong rule | The three named examples (waitlist size, registered users, total messages sent) are Eric Ries's own and are PRIMARY-grounded. But the source rule is *decision-usefulness*, not monotonicity: "They might make you feel good, but they don't offer clear guidance for what to do… Let's say you have 10,000 [hits]. Now what?" Croll & Yoskovitz's test is four-part, of which rate-or-ratio is one. A weekly-active count can go down and still fail all four. **Exception clause worth adding** (Cohn, Gothelf): a cumulative count is admissible as a leading indicator pre-PMF, and inadmissible the moment it appears in a goal, a board deck, or a fundraise. **Provenance:** the primary text is Ries's tim.blog guest post, 19 May 2009 — citing *The Lean Startup* (2011) as the origin is wrong. |

### Missing mechanisms

Four mechanisms the thirteen claims never reach. The first is a deliberate exclusion argued back in;
the rest are genuine gaps.

- **Paid acquisition under a payback-period constraint.** The skill excludes growth tactics, but the *gate* is a judgment tool, not a tactic: Skok's modelled cohort P&L shows "profitability is anemic if the time to recover CAC extends beyond 12 months", against a ~3:1 LTV:CAC floor. Without it a founder reads claims 1–13 and concludes paid is disreputable; the evidenced position is that paid is fine iff CAC is recovered inside ~12 months.
- **Programmatic / template-page SEO.** Not a tactic — a data-model decision made before the first user, which is exactly claim 1's territory. Chen names the mechanism and the cases (Yelp, Stack Overflow); Zapier is the canonical B2B instance. The mechanism is well-evidenced; every available traffic figure is a third-party SEO-tool estimate, so cite the mechanism, not the numbers.
- **Pricing and packaging as the distribution decision.** Claim 1 legislates the shape of the entry surface and stops before the paywall that decides whether anyone converts. OpenView's 2022 benchmarks put freemium at 5% free→paid conversion with 65% self-serve share, against free trial's 17% and 20% — a ~3x swing on a decision the skill never mentions. Self-reported founder survey; still the largest openly published dataset on the question.
- **Bottom-up B2B adoption and its ceiling.** The skill's unit of analysis is the individual user throughout. In B2B the individual is not the buyer, so the first-surface claim (1) and the channel-concentration claim (3) are right for the first 100 and silently wrong at 1,000. a16z documents the bottom-up-only motion stalling around $20M ARR.

### Claims the primary evidence contradicts

1. **"Several scaled to millions with no push feature at all"** — no supporting instance exists.
2. **"Almost every company… one channel"** — the book it leans on prescribes parallel testing first and addresses a later stage entirely.
3. **The non-transferability condition** — Gmail, Clubhouse and Robinhood, the three largest gated user bases available, all violate it.
4. **"The users who took the highest-friction action drown first"** — unevidenced, and the nearest literature points the other way.
5. **"Fix retention before optimizing acquisition"** — Ehrenberg-Bass calls the underlying belief evidence-free.
6. **The Facebook "80% of Harvard before expanding" density threshold**, if any version of this skill leans on it — no primary source; expansion to Columbia, Stanford and Yale began about one month after the 4 Feb 2004 launch. The one peer-reviewed paper built on that rollout measures students' later earnings, not whether gating helped Facebook grow. Do not ship the figure.
7. **"People overstate willingness to pay by 2–3x"** — the folk figure behind the interview rule. The meta-analysis puts the median at **1.35**, and says "only 1.35" to correct exactly this. Do not repeat it.

### Do-not-cite

The SEO tier restating the Sean Ellis 40% rule (learningloop, stackmatix, koji.so, formbricks,
surveysparrow, zonka, ideaplan, fitsignal, prelaunch) — several assert "hundreds of startups" without
the arbitrary admission, and at least one asserts "that threshold isn't arbitrary", which the origin
post directly contradicts. `aggregator` + `false_authority`. Likewise the "70% of customers from one
channel" figure and the "1 channel to $50M, 2 to $100M" heuristic: both circulate with no study,
sample, or stage attached.
