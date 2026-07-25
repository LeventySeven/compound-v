# Compound V

Compound V is a skill set for Claude Code. It covers the judgment around the code: what's worth building, how it should feel, how to keep a long session sharp, how to review for bugs and security without flattery, and how to tell whether an AI feature actually works.

The bet is that code got cheap and judgment didn't. So most of these skills are about the decisions around the typing, not the typing. They're short on purpose. If a line doesn't change what the agent does, it's cut, and the kit can run its own check (below) to keep it that way.

## How it works

Every session starts at the router. `using-compound-v` loads up front and sizes the task first, so a typo just gets fixed and a real feature earns the full pipeline. A one-line change never spawns four agents.

For a real feature the path is short: pin the design with `brainstorming`, turn it into a plan an implementer with no prior context can follow with `writing-plans`, build it with `batched-implementation` (one fresh subagent per two or three related tasks, all on your strongest model), and review each batch with `recheck` before the next one starts. A five-task plan lands in about four dispatches.

## The workflow

```
using-compound-v → brainstorming → writing-plans → batched-implementation ⇄ recheck → finishing
  (route the tier)   (design gate)   (plan or PRD)    (1 impl / 2-3 tasks)    (read-only)  (merge/PR)
```

Two pieces carry most of the weight:

- `batched-implementation` runs one implementer per two or three related tasks, all on your strongest model. It keeps going instead of stopping to ask permission, and reports each batch with a four-status contract.
- `recheck` is a single read-only pass, ordered cheapest-disqualifying-first: goals, plan, bugs, vulnerabilities, re-test, over-engineering. It returns severity-tagged findings and one verdict, and caps the fix loop at three rounds. It stays read-only because a reviewer that can edit ships its own unreviewed bug.

## The skills

| Group | Skills |
|---|---|
| Foundation | `using-compound-v`: the router. Tiering, the taste/distribution/primitive gate, the non-negotiables. |
| Solve any goal (opt-in) | `frame-the-goal` (turn any goal into a testable success check) → `simplest-thing-that-works` (the simplest mechanism that provably passes it — zero-AI first, climb only when forced, as high as a hard goal needs) → `make-it-stable` (make it hold every time). The general front-door; caps the machinery, never the goal, and routes into the AI skills. |
| Taste | `startup-taste` (whether and what to build) and `product-taste` (how it feels) |
| Plan | `brainstorming` (design before code), `writing-plans` (a per-build plan with real code, no placeholders), `writing-prd` (the product's stable source-of-truth doc, read first for context), and `extracting-specs` (recover the real contract of *existing* code — the backward complement of `writing-prd`) |
| Thinking | `critical-thinking` (red-team your own reasoning before you commit — steelman it, hunt disconfirming evidence) |
| Build | `batched-implementation`, `recheck` (the in-pipeline review gate), `code-review` (the on-demand reviewer **and automatic pre-merge gate** — point it at a PR/branch/diff or let it run before any merge; scale the depth, gate findings by confidence, post to GitHub or apply the fixes), `finishing` |
| Correctness and security | `test-driven-development`, `systematic-debugging`, `verification-before-completion`, and `agent-security` (build-time defense: the lethal trifecta, source-trust, sandboxing model-written code) |
| AI design (one feature) | `designing-agents` (a call, a workflow, or an agent?), `evals` (does the AI actually work?), `context-engineering` |
| AI systems (architecture, opt-in) | `architecting-ai-systems` (the compound system around the model — harness-as-moat, primitive-not-wrapper, build for the model ~18 months out) and `ai-system-reliability` (keep a built system from corrupting its own state; chain a constellation past one model's ceiling) |
| Power | `searching-patterns` (the canonical pattern and the anti-pattern it replaces, from primary sources) and `dispatching-parallel-agents` |

## What the kit holds itself to

Three rules sit above the skills:

- Honest. Evidence over claims, no praise-padding, no false "done." When something doesn't work, it says so.
- Safe. Security is a review axis that blocks a merge. It's never traded away to ship, and the kit won't write harmful code.
- Grounded. The skills come from how production coding agents actually behave and from primary engineering sources, not invented best practice. Every load-bearing number maps to a public source in `references/sources.md`. A claim that can't be grounded is marked as a judgment call.

## Install

```bash
/plugin marketplace add LeventySeven/compound-v
/plugin install compound-v@compound-v-dev
```

For local work, symlink the skill directories into `~/.claude/skills/`. A SessionStart hook injects the small router each session, a UserPromptSubmit hook re-asserts the routing directive each turn (one self-gating line, so skills keep firing as context grows instead of decaying after the opening turn), and everything else loads on demand — so the always-on cost is the router plus a one-line nudge.

## Checking the kit

The kit checks itself, structurally and behaviourally.

`bash scripts/check.sh` reads every skill and fails if one breaks a rule: a body over its line budget, a frontmatter name that doesn't match its directory, an unknown frontmatter key, a description over the 1024-char cap the harness truncates at, a cross-reference to a skill that doesn't exist, an `@path` link, or any mention of the private research notes that must never ship. It also prints the kit's always-on cost — the descriptions are loaded in every session whether or not a skill fires, so that number is the real price of admission. No dependencies; it drops straight into CI or a pre-commit hook.

`bash scripts/trigger-eval.sh` answers the harder question: **do these skills actually fire?** A skill that never gets invoked changes nothing, and it fails silently — a description the harness truncated looks exactly like one that simply didn't match. The script drives the real CLI on your existing session auth, feeds it realistic user phrasings from `scripts/trigger-fixtures.tsv` with `Skill` as the only permitted tool, and reports which skill each prompt actually invoked. Negative fixtures are included: over-triggering on "fix the typo in the readme" is exactly as wrong as under-triggering on a real one.

It measures routing, not output quality, and each case is one cold turn — so it can't see a skill decaying over a long session. Both are real limits, and it's still the difference between "every line changes what the agent does" as a claim and as a number.

## How it was built

Compound V was built with its own loop: batched Opus implementers and a read-only `recheck` on every batch. The source material was an audit of how today's production coding and research agents behave, the canonical engineering and skill-authoring writing, practitioner talks, and a founder-judgment canon. The build's own recheck caught real defects, including a router over its line budget, a verdict-handling gap, and two descriptions that broke the kit's own rules, and they were fixed before commit. `scripts/check.sh` re-runs the structural checks (above) on every change.

## License

MIT
