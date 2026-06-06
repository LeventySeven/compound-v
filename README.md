# Compound V

**A lean, opinionated skill set for shipping great software with agentic AI.** Superpowers, but
better: product & startup taste, real context engineering, a security-first review pass, and a
workflow that refuses bullshit and overkill.

> Compound V is the substance that gives superpowers. This one is tuned: fewer skills, each leaner,
> covering more ground — judgment and taste, not just process ceremony.

## Why it exists

The dominant skill library (`superpowers`) is ~4,700 lines across 14 skills, most of it ceremony.
Compound V keeps the genuinely load-bearing ideas, cuts the rest, and adds the three things it lacks:

1. **Judgment & taste** — decide *what* to build and *how well* it must feel (`startup-taste`,
   `product-taste`). Differentiate a primitive from a wrapper; refuse "this will take weeks."
2. **Real context engineering** — the architecture-beats-the-model layer: smallest high-signal token
   set, compaction, KV-cache discipline, sub-agents as context firewalls (`context-engineering`).
3. **Security-first review** — one read-only Opus pass that checks goals → plan → bugs →
   **vulnerabilities** → re-test → patterns, after every 2–3 task batch (`recheck`).

## The workflow (the spine)

```
brainstorming → writing-plans → batched-implementation → recheck → finishing
```

- **batched-implementation**: one implementer subagent per **2–3 tasks**, all Opus 4.8.
- **recheck**: one **read-only** Opus pass folding spec-compliance + code-quality + security + a real
  test run into a single superset review. ~4 dispatches for a 5-task plan vs superpowers' ~16.

Effort is tiered — a one-line fix never triggers the full pipeline (see `using-compound-v`).

## The skills

| Group | Skills |
|---|---|
| Foundation | `using-compound-v` (router) |
| Taste | `startup-taste`, `product-taste` |
| Plan | `brainstorming`, `writing-plans` |
| Build | `batched-implementation`, `recheck`, `finishing` |
| Discipline | `test-driven-development`, `systematic-debugging`, `verification-before-completion` |
| Power | `context-engineering`, `searching-patterns`, `dispatching-parallel-agents` |

## Install

```bash
/plugin marketplace add LeventySeven/compound-v
/plugin install compound-v@compound-v-dev
```

Or for local development, symlink the skills into `~/.claude/skills/`.

## License

MIT
