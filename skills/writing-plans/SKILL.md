---
name: writing-plans
description: Turns an approved design or spec into a step-by-step implementation plan with exact files, real code, and runnable verification — or into a PRD/design doc. Use when you have requirements for a multi-step task and are about to start building, when an agent will execute the work task-by-task, or when asked to write a PRD, spec, or product doc.
---

# Writing Plans

A plan is where most of the quality is decided. Get the research and the plan right and the implementation almost writes itself; get them wrong and you generate thousands of bad lines from a few bad ones.

## When to use

- You have an approved design (from `compound-v:brainstorming`) or a clear spec, and the work is more than one obvious edit.
- An implementer — a subagent or a fresh session — will execute the plan without your current context.
- You're asked for a PRD, design doc, or product spec (use the PRD template near the end).

**Skip the plan doc** for trivial and small changes per the `using-compound-v` tier table — make the change and verify. The plan earns its cost on Standard-or-larger work.

## Research before plan, plan before code

The leverage runs uphill. A bad line of code is one bad line. A bad decision in the plan is hundreds of bad lines. A bad piece of *research* — misunderstanding how the system works, where data flows, where the change actually belongs — is thousands. So the order is **Research → Plan → Implement**, and you spend disproportionately at the top.

**Research first.** Before writing tasks, understand the system you're changing: the files that matter, where the problem actually lives, how data flows through it. Read the code; don't assume. The output of this phase is concrete — name real files and the specific line ranges the plan will touch, so the implementer doesn't re-discover the codebase from scratch. If you're shouting at the implementer later, the research or the plan was thin.

**Search the pattern first when it's unfamiliar.** Before you plan a non-trivial, unfamiliar, or security-sensitive pattern — or pick a library or API shape — find how it's actually done well. Use `compound-v:searching-patterns` to pull the canonical pattern *and* its matching anti-pattern, then bake both into the plan so the implementer copies the right one. An hour of pattern research up front beats a recheck cycle that rejects the wrong abstraction. Don't do this for code you already know cold.

## Order tasks by risk, not by comfort

Sequence the work by information gained per unit of time: **find the one assumption that, if false, makes the whole plan worthless, and test it first** — with the cheapest experiment that resolves it. Do not put infrastructure, scaffolding, or the fun part first while the load-bearing assumption sits unexamined; that's building a foundation on a guess. The first task should reduce the biggest risk, not lay the most plumbing.

## Write for an implementer with zero context

Assume the implementer is a capable engineer who knows nothing about this codebase or problem domain and has questionable taste. Everything they need is in the plan: which files to touch, the actual code, how to test it, what "done" looks like. They may read tasks out of order, so each task stands alone.

### File structure first

Before defining tasks, map which files get created or modified and what each is responsible for. This is where the decomposition gets locked in.

- One clear responsibility per file. Files that change together live together — split by responsibility, not by technical layer.
- Focused files are more reliable to edit (yours and the implementer's). If a file is growing unwieldy on the path you're touching, planning a split is fair; don't unilaterally restructure unrelated code.
- In an existing codebase, follow the established patterns rather than imposing new ones.

### Bite-sized tasks with real content

Each task produces a self-contained, testable change. Within a task, the steps follow the test-first rhythm — write the failing test, see it fail, implement the minimum, see it pass, commit (see `compound-v:test-driven-development`). Right-size the granularity to the work: don't fetishize a separate "run it to see it fail" line for a one-line mechanical step, but never collapse real behavior into "implement the feature."

```markdown
### Task N: <component>

**Files:**
- Create: `src/exact/path.py`
- Modify: `src/exact/existing.py:123-145`
- Test:   `tests/exact/path_test.py`

- [ ] Write the failing test:
      ```python
      def test_rejects_expired_token():
          assert verify(expired_token()) is False
      ```
- [ ] Run `pytest tests/exact/path_test.py -v` → expect FAIL ("verify not defined")
- [ ] Implement the minimal code in `src/exact/path.py`:
      ```python
      def verify(token): ...   # real body, not a sketch
      ```
- [ ] Run `pytest tests/exact/path_test.py -v` → expect PASS
- [ ] Commit: `git commit -am "feat: reject expired tokens"`
```

Start the plan with a one-line goal, two-to-three sentences on the approach, and the key libraries — enough orientation, no boilerplate ceremony.

## No placeholders

A placeholder in a plan is a decision you pushed onto someone with less context — it becomes a guess in the code. These are plan failures; don't write them:

- "TBD", "TODO", "implement later", "fill in the details"
- "Add appropriate error handling / validation / edge cases" — name them, or write the code
- "Write tests for the above" with no actual test code
- "Similar to Task N" — repeat the code; the implementer may read this task first
- Steps that say *what* without *how* (code steps need code blocks)
- References to types, functions, or methods no task defines

Estimate effort in hours or days. If a plan reads "this will take weeks", the construction isn't the long pole — re-scope into shippable slices, because building is rarely what's actually slow anymore.

## Self-review the plan

After the plan is complete, read it against the spec with fresh eyes. This is your own pass, not a subagent.

- **Spec coverage** — for each requirement in the spec, point to the task that implements it. List the gaps; add tasks to fill them.
- **Placeholder scan** — hunt the patterns above and resolve every hit.
- **Type consistency** — do signatures and names line up across tasks? `clearLayers()` in Task 3 and `clearFullLayers()` in Task 7 is a bug waiting to happen.

Fix inline and move on. Save the plan to `docs/plans/YYYY-MM-DD-<feature>.md` (user's location preference wins), then hand off to `compound-v:batched-implementation` to execute it.

## Writing a PRD or design doc

When the deliverable is a product doc rather than a code plan, the discipline is the same — concrete over vague, with one cut named — but the sections differ. Keep it to the shortest thing that makes the decision:

- **Problem** — the specific problem and who has it, in plain language. Not a mission statement.
- **The one verifiable signal** — how you'll *know* it worked: the metric, eval, or observable outcome that says ship/don't-ship. If there's no auto-checkable signal, that gap is the first risk to close, not a detail to defer. For an agent-built feature, make the signal *machine-checkable and tamper-resistant* — a feature list as an executable spec: a JSON list of requirements the agent may flip to `passes: true` but not rewrite (JSON resists accidental overwrite better than prose).
- **Scope and the cut** — what's in, and explicitly what's out for v1. A doc that only adds is a backlog, not a plan; name what you're refusing.
- **Approach** — the chosen design and the real alternatives you rejected, with why. One sentence stating the core idea — if you can't state it in one sentence, the design isn't settled.
- **Risks, riskiest first** — the load-bearing assumptions, ordered by what would hurt most if wrong, each with how you'd test it cheaply.

Then run the same self-review: every claim concrete, no placeholders, effort in hours/days.
