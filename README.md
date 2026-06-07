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
- **Grounded** — the skills are distilled from reverse-engineered production coding agents (Claude
  Code, Codex, Cursor, Amp, Devin, Junie…), primary practitioner talks, and the canonical
  engineering posts — not invented best-practices. Every load-bearing number maps to its public
  primary source in `references/sources.md`; if a claim isn't grounded, it says so.

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

## The skills (17)

| Group | Skills |
|---|---|
| **Foundation** | `using-compound-v` — router: tier-routing + the 3-compounds gate + non-negotiables |
| **Taste** | `startup-taste` (what to build — wrapper test, revenue-not-cost, ship-in-hours) · `product-taste` (how it feels — name-the-property, slop detector, latency/animation gates) |
| **Plan** | `brainstorming` (design-first gate) · `writing-plans` (plan + PRD, no placeholders) |
| **Build** | `batched-implementation` · `recheck` · `finishing` |
| **Correctness & security** | `test-driven-development` · `systematic-debugging` · `verification-before-completion` · `agent-security` (build-time defense — trifecta, source-trust, sandbox model-written code) |
| **AI design** | `designing-agents` (call vs. workflow vs. agent) · `evals` (does the AI actually work) · `context-engineering` |
| **Power** | `searching-patterns` (canonical pattern + anti-pattern via primary sources) · `dispatching-parallel-agents` |

## How it compares to superpowers (measured, honest)

We ran a neutral head-to-head (a neutral judge, told not to favor either side). The honest result:

- **Leanness — Compound V wins decisively.** ~88% load-bearing vs ~40–45%. **1,347 lines across 17
  skills, plus 190 lines of on-demand reference** (`references/interface-checklist.md`,
  `references/skill-format.md`) — vs superpowers' ~8,474 (3,207 skill lines + 5,267 in supporting
  files) for near-identical coverage. The reference files load only when needed (progressive
  disclosure), so the always-on cost is the router alone.
- **Discoverability — 100% (re-run at v0.2).** On a 22-query trigger eval over the v0.2 descriptions —
  17 should-fire (one per skill, including the new `agent-security`), 2 adjacency traps ("how many
  agents?" → `designing-agents`, not `dispatching`; "did the agent do it right?" → `recheck`, not
  `verification`), and 3 out-of-scope should-not — every query routed correctly, **22/22**, with no
  collisions. Each query was judged by an independent fresh agent from the descriptions alone.
- **Review process — Compound V wins.** 1 read-only pass vs 2 dispatches; findings-only vs
  superpowers' *mandated* praise; cleaner disqualify-first ordering.
- **Bug & vuln detection.** *v0.1 head-to-head:* on two fixtures (Python: path-traversal,
  swallowed-404, dead code, tautological test; Node/Express: SQL injection, BOLA, unbounded cache,
  missing-`await`, vacuous test) **both kits caught the bugs** — the differentiator was severity
  calibration. superpowers was sharper on the first (3/4 vs 2/4 exact); after we hardened `recheck`'s
  calibration, recheck edged it on the second, unseen fixture (4/5 vs 3/5). *v0.2 re-validation (our
  side only — superpowers was not re-run this pass):* on a fresh Node/Express fixture (three
  SQL-injection sites, a missing authorization check, an auth token logged in plaintext, a
  missing-`await` race, two vacuous tests) `recheck` returned **FIX_REQUIRED** and caught every
  security and correctness issue — naming **CWE-89 ×3, CWE-639, and CWE-532**, the race, and both weak
  tests, each severity-calibrated (security/authz → Critical; race/vacuous tests → Important) — while
  **missing one** low-severity issue (an unbounded in-process cache). Zero false Criticals. The miss is
  reported because that's the rule. **Honest caveat:** superpowers' review output is still the more
  polished, pedagogical artifact; recheck stays leaner, findings-only, one read-only pass.
- **Where superpowers genuinely wins:** its more aggressive rationalization-resistance plausibly
  raises compliance for weaker models under pressure, and it ships executable tooling (graph
  rendering, a visual companion) that Compound V doesn't have.

Net: leaner, denser, broader coverage, more discoverable (22/22 at v0.2), and honest-by-design — and
at least as accurate on severity as superpowers in the v0.1 head-to-head. What it doesn't win is
reviewer polish/pedagogy. That's the truthful claim the kit makes — not "catches strictly more bugs."
(The cross-kit head-to-head is from v0.1; v0.2 re-validated Compound V's own side — discoverability and
recheck — as reported above; superpowers was not re-run this pass.)

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
reverse-engineered production coding agents and primary practitioner sources: a full audit of
superpowers, Anthropic's skill-authoring and context-engineering canon, how today's production
coding and deep-research agents actually behave, practitioner talks and transcripts, and a distilled
top-tier founder canon. The build's own recheck pass caught real defects (a router over budget, a
verdict-handling gap, two descriptions violating the kit's own rules) and fixed them before commit.

**v0.2 changes:** a grounding pass that ties every load-bearing number to its public primary source
in `references/sources.md` (and corrects three that were wrong or unsourced); `agent-security` added
as the build-time complement to
`recheck`'s detect-time pass; a dedupe of single-source-of-truth violations across skills; and
`searching-patterns` re-grounded around primary sources, with its browser tooling demoted to optional.

## License

MIT
