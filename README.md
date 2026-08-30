# Compound V

Compound V is a skill set for Claude Code. It covers the judgment around the code: what's worth building, how it should feel, how to keep a long session sharp, how to review for bugs and security without flattery, and how to tell whether an AI feature actually works.

The bet is that code got cheap and judgment didn't. So most of these skills are about the decisions around the typing, not the typing. They're short on purpose. If a line doesn't change what the agent does, it's cut, and the kit can run its own check (below) to keep it that way.

## How it works

Every session starts at the router. `using-compound-v` loads up front and sizes the task first, so a typo just gets fixed and a real feature earns the full pipeline. A one-line change never spawns four agents.

For a real feature the path is short: pin the design with `brainstorming`, turn it into a plan an implementer with no prior context can follow with `writing-plans`, build it with `batched-implementation` (one fresh subagent per two or three related tasks), and review each batch with `recheck` before the next one starts. A five-task plan lands in about four dispatches.

## The workflow

```
using-compound-v → brainstorming → writing-plans → batched-implementation ⇄ recheck → finishing
  (route the tier)   (design gate)   (plan or PRD)    (1 impl / 2-3 tasks)    (read-only)  (merge/PR)
```

Two pieces carry most of the weight:

- `batched-implementation` runs one implementer per two or three related tasks — sized by what one review pass can hold in judgment, not by what fits in a context window. It passes no model parameter, so each worker inherits the session model rather than being silently downgraded. It keeps going instead of stopping to ask permission, and reports each batch with a four-status contract.
- `recheck` is a single read-only pass, ordered cheapest-disqualifying-first: goals, plan, bugs, vulnerabilities, re-test, over-engineering. It returns severity-tagged findings and one verdict, and caps the fix loop at three rounds. It stays read-only because a reviewer that can edit ships its own unreviewed bug.

## The skills

| Group | Skills |
|---|---|
| Foundation | `using-compound-v`: the router. Tiering, the taste/distribution/primitive gate, the non-negotiables. |
| Solve any goal (opt-in) | `frame-the-goal` (turn any goal into a testable success check) → `simplest-thing-that-works` (the simplest mechanism that provably passes it — zero-AI first, climb only when forced, as high as a hard goal needs) → `make-it-stable` (make it hold every time). The general front-door; caps the machinery, never the goal, and routes into the AI skills. |
| Taste | `startup-taste` (whether and what to build), `product-taste` (how it feels) and `founder-distribution` (whether it will reach anyone — the leg that gets skipped, because it's the only one you can't make progress on by building) |
| Plan | `brainstorming` (design before code), `writing-plans` (a per-build plan with real code, no placeholders), `writing-prd` (the product's stable source-of-truth doc, read first for context), and `extracting-specs` (recover the real contract of *existing* code — the backward complement of `writing-prd`) |
| Thinking | `critical-thinking` (red-team your own reasoning before you commit — steelman it, hunt disconfirming evidence) and `council` (when solo skepticism isn't enough: fresh-context agents answer and cross-examine one unverifiable question, findings not votes, and you write the verdict) |
| Build | `batched-implementation`, `recheck` (the in-pipeline review gate), `code-review` (the on-demand reviewer **and automatic pre-merge gate** — point it at a PR/branch/diff or let it run before any merge; scale the depth, gate findings by confidence, post to GitHub or apply the fixes), `finishing`, and `get-shit-done` (the **project spine**, aimed at the run that stops at 90% — every declared function becomes a ledger row that starts failing, a row goes green only on a check that was seen red first plus an end-to-end run driven as a user, and the run is not done while any row is neither passed nor explicitly dropped with a name attached; carve → recon → build one slice at a time → the MEP done-gate over the assembled product) |
| Correctness and security | `test-driven-development`, `systematic-debugging`, `verification-before-completion`, and `agent-security` (build-time defense: the lethal trifecta, source-trust, sandboxing model-written code) |
| AI design (one feature) | `designing-agents` (a call, a workflow, or an agent?), `evals` (does the AI actually work?), `context-engineering` |
| AI systems (architecture, opt-in) | `architecting-ai-systems` (the compound system around the model — harness-as-moat, primitive-not-wrapper, build for the model ~18 months out) and `ai-system-reliability` (keep a built system from corrupting its own state; chain a constellation past one model's ceiling) |
| Power | `searching-patterns` (the canonical pattern and the anti-pattern it replaces, from primary sources), `dispatching-parallel-agents`, and `handoff` (one `.claude/STATE.md` for work that outlives a session) |

It also ships one agent: `code-reviewer`, the spawnable read-only form of `recheck` — it reads the actual diff, re-runs the tests itself, and returns severity-tagged findings plus one verdict. In artifact mode it reviews a plan or spec before implementation instead of a diff, resolving every path and command the plan names rather than opining on prose. It never edits; the implementer applies the fixes.

## Documents earn their place

The router carries one rule the tier table can't express on its own: writing the spec is the expensive default, not the safe one. Before a document gets written, route the change against the docs the repo already has — amend the one that owns this surface, supersede the decision it reverses, create one, retire the one the ground has moved out from under, or none — and cap the output at **one new document per change**, with findings and the plan as sections of it rather than siblings. Below Standard that count is zero: the plan is confirmed in the conversation and the commit message is the record. Then name every doc the change makes wrong, make each a task, and treat the change as unshipped until they're updated.

## What the kit holds itself to

Three rules sit above the skills:

- Honest. Evidence over claims, no praise-padding, no false "done." When something doesn't work, it says so.
- Safe. Security is a review axis that blocks a merge. It's never traded away to ship, and the kit won't write harmful code.
- Grounded. The skills come from how production coding agents actually behave and from primary engineering sources, not invented best practice. Load-bearing numbers map to a public source in `references/sources.md`, and a claim that can't be grounded is marked as a judgment call. That file also carries an open list of claims still missing a source — an accurate ledger with known gaps beats one that quietly implies everything is covered.

## Install

```bash
/plugin marketplace add LeventySeven/compound-v
/plugin install compound-v@compound-v-dev
```

For local development, point a directory marketplace at your clone and enable the plugin — **don't also copy or symlink the skills into `~/.claude/skills/`.** A personal-level copy takes precedence over the plugin, so you end up running a snapshot while editing the repo, and every skill appears twice in the listing: two entries competing for one shared, truncated description budget. The failure is silent in both directions — your edits don't take effect, and the extra entries shorten everyone else's triggers.

A SessionStart hook injects the small router each session, a UserPromptSubmit hook re-asserts the routing directive each turn (one self-gating line, so skills keep firing as context grows instead of decaying after the opening turn), and everything else loads on demand — so the always-on cost is the router plus a one-line nudge.

A third hook is the mechanical floor under `verification-before-completion`: a Stop hook refuses exactly one thing — a turn that edited files, ran **no command at all**, and then claimed the work was done. It's deliberately narrow. It blocks at most once per turn (it checks `stop_hook_active`, so a session always gets to end rather than hitting the harness's consecutive-block override), the trigger is anchored on completion claims at clause start and discards any clause carrying a negation or a progress marker (a bare `working` match would fire on "I'm still working on it" — that's a bug, not a stricter gate), it fails open on anything unexpected including a missing `jq`, and `COMPOUND_V_STOP_GATE=off` turns it off. It cannot tell whether the command you ran proved anything, so it's a floor, not the gate.

## Checking the kit

The kit checks itself, structurally and behaviourally.

`bash scripts/check.sh` reads every skill and fails if one breaks a rule: a body over its budget, a frontmatter name that doesn't match its directory, an unknown frontmatter key, a description over the 1024-char cap the harness truncates at, a cross-reference to a skill that doesn't exist, an `@path` link, or any mention of the private research notes that must never ship. The size budget counts **words, not lines** — a body can double while the line count stays flat just by merging paragraphs, and the warning fires past ~3,750 words, the point where compaction stops re-attaching the rest of the file. It also prints the kit's always-on cost, since descriptions load in every session whether or not a skill fires. No dependencies; it drops straight into CI or a pre-commit hook.

`bash scripts/trigger-eval.sh` answers the harder question: **do these skills actually fire?** A skill that never gets invoked changes nothing, and it fails silently — a description the harness truncated looks exactly like one that simply didn't match. The script drives the real CLI on your existing session auth, feeds it realistic user phrasings from `scripts/trigger-fixtures.tsv`, and reports which skill each prompt actually invoked. Everything that could write, spend or spawn is denied by settings, and each case is bounded by a timeout. Negative fixtures are included: over-triggering on "fix the typo in the readme" is exactly as wrong as under-triggering on a real one, and a run that fails outright is reported as an error rather than scored as a pass.

It measures routing, not output quality, and each case is one cold turn — so it can't see a skill decaying over a long session. A miss is also not automatically a skill defect: the fixture can be wrong about what should happen, and bending a skill to satisfy a bad fixture is how a suite starts lying to you. Both are real limits, and it's still the difference between "every line changes what the agent does" as a claim and as a number.

`bash scripts/skills-audit.sh` answers the other half: **which skills fire in real sessions?** It counts Skill invocations in your own local transcripts (`--days N` windows it), and sorts the never-fired rows to the top. Cold routing from fixtures and warm routing from real work are different questions. Two traps it exists to not fall into, because both have already produced a confidently wrong report about this kit: skill names appear **both namespaced and bare** — a bare name means a personal-level copy is shadowing the plugin, and counting only the prefixed form undercounts, sometimes to zero — and **a zero is absence of evidence, not evidence of death**, so opt-in skills, whose own descriptions say not to auto-trigger, are flagged rather than counted as dead. It is read-only and must stay that way: this is one machine's usage, and what ships goes to everyone, so archiving a skill on this number would be a global decision taken on a single-user signal.

`bash scripts/hooks-test.sh` proves the Stop gate. Synthetic transcripts, a synthetic hook input, no CLI and no network, so it runs anywhere. The ALLOW cases are the important half — "I'm still working on it", a suite run followed by a trailing edit, a conditional "done once you…" — because on a Stop hook a false block costs a wasted turn, and over-triggering is exactly as wrong as under-triggering.

## How it was built

Compound V is built with its own loop: batched implementers and a read-only `recheck` on every batch. The source material is an audit of how today's production coding and research agents actually behave, the canonical engineering and skill-authoring writing, practitioner talks, and a founder-judgment canon.

The loop keeps earning its place. The most recent pass re-grounded every skill against the harness's own documented behaviour and found real defects: `code-review` carried the lethal trifecta it warns others about, several skills told you to pin a worker's model in a way that can silently downgrade it, and one taxonomy had three incompatible definitions across three files. The recheck on that pass returned FIX_REQUIRED and blocked the commit until they were fixed. Measurement caught the rest — a routing defect no amount of reading would have surfaced, and two of my own test fixtures that were wrong rather than the skills.

## License

MIT
