# Compound V

**A lean, opinionated skill set for shipping great software with agentic AI.** Superpowers, but
better where it counts: product & startup taste, real context engineering, a security-first review
pass, evals, and a workflow that refuses bullshit and overkill — every skill grounded in how real
production systems actually work, not generic advice.

> Compound V is the substance that gives superpowers. This one is tuned: fewer skills, each leaner,
> covering *more* ground — judgment and taste, not just process ceremony.

## Why it exists

The dominant skill library (`superpowers`) is excellent at enforcing process discipline, but it's
~8,500 lines of instruction and most of it is restatement — one idea wrapped in an Iron Law banner,
a pseudocode block, three rationalization tables, and a role-play transcript. Compound V keeps the
genuinely load-bearing ideas, cuts the ceremony, and adds the things an AI-product builder actually
needs and superpowers doesn't have:

1. **Judgment & taste** — decide *what* to build and *how well* it must feel (`startup-taste`,
   `product-taste`). Tell a primitive from a wrapper; refuse "this'll take weeks."
2. **Real context engineering** — the architecture-beats-the-model layer: smallest high-signal token
   set, the compaction ladder, KV-cache discipline, sub-agents as context firewalls
   (`context-engineering`).
3. **A security-first, sycophancy-free review** — one read-only pass that checks goals → plan → bugs
   → **vulnerabilities** → re-test → over-engineering, findings-only, no praise padding (`recheck`).
4. **AI-feature design & evaluation** — when to use a call vs. a workflow vs. an agent
   (`designing-agents`), and how to know if it actually works (`evals`).

## Non-negotiables

These are the spine, not features:

- **Honest** — evidence over claims, no praise-padding, no false "done." This README's own
  comparison below reports where Compound V *loses*, because that's the rule.
- **Safe** — security is a blocking review axis, never traded away to ship. No harmful code.
- **Grounded** — the skills are distilled from reverse-engineered production agents (Claude Code,
  Codex, Cursor, Amp, Devin, Junie…), primary practitioner talks, and the canonical engineering
  posts — not invented best-practices. If a claim isn't grounded, it says so.

## How it works

It starts the moment your agent picks up a task. Instead of jumping into code, the always-loaded
router (`using-compound-v`) sizes the work first: a typo is *Trivial* and just gets done; a feature
is *Standard* and earns the full pipeline. Effort matches the task — a one-line fix never spawns four
agents.

For real features: `brainstorming` pins down the design before any code, `writing-plans` turns it
into a plan an implementer-with-no-context can follow (research → plan → implement, because a bad
line of research costs thousands of bad lines of code), then `batched-implementation` builds it with
fresh-context subagents — **one per 2-3 tasks, all Opus 4.8** — and `recheck` independently verifies
each batch before the next. ~4 dispatches for a 5-task plan, where superpowers spends ~16.

## The workflow (the spine)

```
using-compound-v  →  brainstorming  →  writing-plans  →  batched-implementation  ⇄  recheck  →  finishing
   (route tier)       (design gate)     (plan + PRD)        (1 impl / 2-3 tasks)    (read-only)   (merge/PR)
```

- **batched-implementation** — one implementer subagent per 2-3 related tasks, all Opus 4.8,
  continuous execution, a four-status contract.
- **recheck** — one **read-only** Opus pass, cheapest-disqualifying-first: goals → plan → bugs →
  **vulnerabilities** → re-test → over-engineering. Findings only, severity-tagged, N=3 fix cap.
  Read-only because a reviewer that can edit ships its own unreviewed bug.

## The skills (16)

| Group | Skills |
|---|---|
| **Foundation** | `using-compound-v` — router: tier-routing + the 3-compounds gate + non-negotiables |
| **Taste** | `startup-taste` (what to build — wrapper test, revenue-not-cost, ship-in-hours) · `product-taste` (how it feels — name-the-property, slop detector, latency/animation gates) |
| **Plan** | `brainstorming` (design-first gate) · `writing-plans` (plan + PRD, no placeholders) |
| **Build** | `batched-implementation` · `recheck` · `finishing` |
| **Correctness** | `test-driven-development` · `systematic-debugging` · `verification-before-completion` |
| **AI design** | `designing-agents` (call vs. workflow vs. agent) · `evals` (does the AI actually work) · `context-engineering` |
| **Power** | `searching-patterns` (canonical pattern + anti-pattern via agent-browser) · `dispatching-parallel-agents` |

## How it compares to superpowers (measured, honest)

We ran a neutral head-to-head (a neutral judge, told not to favor either side). The honest result:

- **Leanness — Compound V wins decisively.** ~88% load-bearing vs ~40–45%. **1,160 lines across 16
  skills with zero supporting files**, vs superpowers' ~8,474 (3,207 skill lines + 5,267 in
  supporting files) for near-identical coverage.
- **Discoverability — 100%.** On a 15-query trigger eval (12 should-fire, 3 near-miss should-not),
  the descriptions routed correctly 15/15.
- **Review process — Compound V wins.** 1 read-only pass vs 2 dispatches; findings-only vs
  superpowers' *mandated* praise; cleaner disqualify-first ordering.
- **Bug detection — a tie, and superpowers was slightly sharper.** On a planted-bug fixture
  (path-traversal, swallowed-404, dead code, tautological test) **both caught all four.** Superpowers'
  heavier two-stage review actually scored *better* on severity accuracy (3/4 vs 2/4 — `recheck`
  under-rated the dead code) and gave deeper analysis. We treated that as the dogfooded loop working:
  `recheck`'s severity calibration was hardened in response (over-engineering with latent risk is now
  rated Important, and vuln findings must name the class + exploit vector).
- **Where superpowers genuinely wins:** its more aggressive rationalization-resistance plausibly
  raises compliance for weaker models under pressure, and it ships executable tooling (graph
  rendering, a visual companion) that Compound V doesn't have.

Net: leaner, denser, broader coverage, more discoverable, honest-by-design — not "catches strictly
more bugs on a single diff." That's the truthful claim, and it's the one the kit makes.

## Install

```bash
/plugin marketplace add LeventySeven/compound-v
/plugin install compound-v@compound-v-dev
```

For local development, symlink the skill directories into `~/.claude/skills/`. A `SessionStart` hook
injects the tiny router each session; every other skill loads on demand (progressive disclosure — the
kit dogfoods its own `context-engineering`).

## How it was built

Built with Compound V's own loop — batched Opus implementers + read-only `recheck` — and grounded in
eight parallel research streams over a large RE corpus: a full audit of superpowers, Anthropic's
skill-authoring and context-engineering canon, ~20 reverse-engineered coding-agent and
deep-research teardowns, practitioner transcripts, and a distilled top-1% founder field manual. The
build's own recheck pass caught real defects (a router over budget, a verdict-handling gap, two
descriptions violating the kit's own rules) and fixed them before commit.

## License

MIT
