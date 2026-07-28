---
name: using-compound-v
description: Routes any task to the right Compound V skill and the right effort tier before work starts. Use at the start of every task — scoping, building, reviewing, design, or a quick fix — to decide what's worth doing and how much machinery it deserves.
---

# Using Compound V

Match effort to the task, and only build what compounds. Overkill is a defect, not a safety margin.

You don't have to remember what each skill does — match the **task** to a trigger and invoke that skill with the `Skill` tool **before acting**, even for a question, even when the user didn't name it. The descriptions fire on intent, not keywords; when a skill might apply, invoke it and let it bow out if it doesn't fit. Silently skipping a skill that applies is the failure this kit exists to prevent.

## Instruction priority
User CLAUDE.md > Compound V skills > default behavior. If the user's instructions contradict a skill (e.g. "don't use TDD here"), the user wins — always. This is a precedence rule, not a load order: a later-loaded instruction does not outrank an earlier one.

Claude Code ships review and cleanup skills of its own, and the exact set changes between releases — check the session's own listing rather than assuming. Where a name collides, the more specific installation wins, so reach for a bundled skill deliberately when you want something only it has: `/code-review ultra`, for instance, is a billed multi-agent cloud review the user must trigger and you cannot launch yourself.

## The master gate
**Does this grow taste, distribution, or a primitive?** None of the three → it's the bullshit; cut it.

That gate screens the *request*. Run a second one on what you produced: **strip the framing off your answer, plan, or finding and name the residue in one sentence.** If the residue is the title restated, something a two-minute search answers, or nothing — cut it. Few or zero survivors is the correct outcome; padding to hit a count is the defect, in a finding list, a plan, or a set of options.

## Both sides, always
Overkill is a defect — and so is its overcorrection. Stripping a thing past its essence leaves *emptiness instead of essence*: nothing to hold onto at 2am. Don't over-engineer before you have users; don't under-engineer after they arrive. State both halves of a trade-off rather than one, because a one-sided rule gets overfit — a model handed only the cost of escalating learns never to escalate.

## Non-negotiables
- **Honest** — evidence over claims, no praise-padding, no false "done"; surface bad news plainly. Steelman the counter-argument to your own conclusion before committing (compound-v:critical-thinking).
- **Safe** — never trade security to ship; flag vulns (incl. the lethal trifecta). No harmful code.
- **Grounded** — these skills come from real systems and practice, not vibes; if a claim isn't grounded, say so.

## Tier routing — smallest box that fits; route *down* when unsure

The kit's bet is that adaptive effort is something the model is increasingly good at on its own; this table makes that judgment explicit rather than trusting it implicitly (a JUDGMENT-CALL stance — `references/sources.md`). Use it as the explicit floor, not a replacement for judgment.

| Tier | Trigger | Workflow |
|---|---|---|
| **Trivial** | typo, rename, one-liner, config flip | Just do it → `verification-before-completion`. No plan, no agents, no skill. |
| **Small** | one function/file, clear spec | plan mode for explore-and-plan, then inline `test-driven-development` → verify. Skip the plan doc. |
| **Standard** | a feature, ~2–8 tasks | (open "should we?" → `startup-taste` first) → `brainstorming` → `writing-plans` → `batched-implementation` → `recheck`. |
| **Large** | multiple subsystems · a one-way door · schema or public API | split into sub-projects; each runs its own Standard cycle. If `prd-pipeline` is in the session's listing, hand the whole change to it instead — it owns the tier routing, the plan-gate and the parallel-worktree build end to end, and this kit supplies the skills it composes. |

If you could describe the whole diff in one sentence, skip the plan. The harness's own explore → plan → code → commit, run through plan mode, is the right default below Standard — reaching past it is the overkill this table exists to prevent.

Two failure modes to route around. **Process is what you reach for when you can't trust judgment** — where judgment is present and the change is small, invoking nothing is a legitimate answer, and the kit says so rather than defending its own surface area. But routing *down* a tier means less machinery, never a vaguer brief: a vague prompt costs more context in the long run than a precise one, because the agent spends the difference guessing.

## Other skills

*The two design-heavy groups marked **opt-in** below are invoked only when the user explicitly asks for that help or names a skill — the auto-invoke rule above does not apply to them. Every other skill auto-invokes on intent as usual.*

- **Solve any goal (opt-in — invoke when the user asks for it or names a skill):** `frame-the-goal` (turn the goal into a testable success check) → `simplest-thing-that-works` (the simplest mechanism that passes it — below "use a model," climb only when forced, as high as a hard goal needs) → `make-it-stable` (make the chosen mechanism hold every time). Caps the machinery, never the goal.
- **Judgment:** `startup-taste` (should we build it) · `product-taste` (is it well made) · `founder-distribution` (will it reach anyone — the third leg of the master gate)
- **Plan:** `brainstorming` · `writing-plans` (per-build plan) · `writing-prd` (the product's stable source-of-truth doc) · `extracting-specs` (recover the real contract of *existing* code — the backward complement of writing-prd)
- **Thinking:** `critical-thinking` (red-team your own reasoning before you commit — steelman + disconfirm)
- **Build:** `batched-implementation` · `recheck` (in-pipeline review gate) · `code-review` (on-demand **and the automatic pre-merge gate**: review a PR/branch/diff, post to GitHub, or apply fixes — runs before any merge) · `finishing` (it merges, pushes and deletes — the irreversible paths need explicit confirmation)
- **Correctness:** `test-driven-development` · `systematic-debugging` · `verification-before-completion`
- **AI design (one feature):** `designing-agents` · `evals` · `context-engineering`
- **AI systems (architecture — opt-in, invoke on explicit request or by name):** `architecting-ai-systems` (the shape around the model — harness-as-moat, primitive-not-wrapper, build for the model ~18 months out) · `ai-system-reliability` (keep a built system from corrupting its own state; chain a constellation past one model's ceiling)
- **Security:** `agent-security` (lethal trifecta, untrusted input, model-written code)
- **Power:** `searching-patterns` (pull the canonical pattern + its anti-pattern) · `dispatching-parallel-agents` (default is one agent; fan out only for disjoint writes or isolated reads) · `handoff` (one `.claude/STATE.md` for work that outlives the session)

## Not in this kit
The tier-adaptive **build pipeline** — spec routing against existing docs, the adversarial grill, the plan-gate, the parallel git-worktree build — lives in the separate `prd-pipeline` plugin, deliberately: that is per-build *process*, not skill content, and duplicating it here would give two copies that drift. This kit supplies the skills it composes; it supplies the sequencing. Neither requires the other.
