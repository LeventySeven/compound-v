---
name: writing-plans
description: Turns an approved design or spec into a step-by-step implementation plan with exact files, real code, and runnable verification. Use when you have requirements for a multi-step task and are about to start building, or when an agent will execute the work task-by-task.
---

# Writing Plans

A plan is where most of the quality is decided, and it exists because a human can review a 200-line plan and cannot review the 2,000-line diff it turns into. Get the research and the plan right and the implementation almost writes itself; get them wrong and you generate thousands of bad lines from a few bad ones.

## When to use

- You have an approved design (from `compound-v:brainstorming`) or a clear spec, and the work is more than one obvious edit.
- An implementer — a subagent or a fresh session — will execute the plan without your current context.
- Producing the product's stable PRD instead? That's its own skill — **compound-v:writing-prd**.

**Skip the plan doc** for trivial and small changes per the `using-compound-v` tier table — make the change and verify. The plan earns its cost on Standard-or-larger work.

**Cap the plan at 200 lines, and keep it cheap to throw away.** Past roughly 200 lines you won't re-read the file and your colleagues certainly won't; an unread plan controls nothing. If the work doesn't fit, split the work — don't write a longer document. That cap sizes the plan for its *reader*; a second cap sizes each task for its *executor*. Count the files one task touches: a task spanning nine or ten will spend most of a fresh implementer's window reading before it writes, and batching cannot rescue it, because batching groups tasks and never splits one — so split the task here. The two caps are independent and a plan has to pass both (batch size is the other axis and belongs to `compound-v:batched-implementation`, which sizes a batch by what one review pass can hold in judgment, not by context). Keep the approval light for the same reason: when a design is signed off long before implementation and the engineer discovers at task 4 that it doesn't work, nobody wants to reopen the approval, so the bad design ships. **If being wrong at task 4 would be socially or procedurally expensive, the plan is too heavy.** Estimate effort in hours or days, and budget the *review* as well as the build — verification is the bottleneck now, five agents each generating thirty minutes of review is not a five-times speedup, and a timeline that counts only implementation is wrong by construction. If a plan reads "this will take weeks", re-scope into shippable slices, because building is rarely what's actually slow anymore.

## Research before plan, plan before code

The leverage runs uphill. A bad line of code is one bad line. A bad decision in the plan is hundreds of bad lines. A bad piece of *research* — misunderstanding how the system works, where data flows, where the change actually belongs — is thousands. So the order is **Research → Plan → Implement**, and you spend disproportionately at the top.

**Research first.** Before writing tasks, understand the system you're changing: the files that matter, where the problem actually lives, how data flows through it. Read the code; don't assume. **While you are planning, the only file you write is the plan itself** — a planner that "just fixes" something it read during research silently invalidates its own tasks and leaves the plan describing a codebase that no longer exists. The output of this phase is concrete — name real files and the specific line ranges the plan will touch, so the implementer doesn't re-discover the codebase from scratch. If you're shouting at the implementer later, the research or the plan was thin.

**Search the pattern first when it's unfamiliar.** Before you plan a non-trivial, unfamiliar, or security-sensitive pattern — or pick a library or API shape — find how it's actually done well. Use `compound-v:searching-patterns` to pull the canonical pattern *and* its matching anti-pattern, then bake both into the plan so the implementer copies the right one. An hour of pattern research up front beats a recheck cycle that rejects the wrong abstraction. Don't do this for code you already know cold.

## Order tasks by risk, not by comfort

Sequence the work so the riskiest assumption gets tested first, with the cheapest task that resolves it — don't lay scaffolding or build the fun part while the load-bearing assumption sits unexamined. (Identifying *which* assumption is load-bearing is **compound-v:startup-taste**'s job; this is where that judgment becomes task order.)

**The cheapest resolution is often not a task at all.** A step that reads as one thing — one onboarding call, one endpoint, one config path — routinely forks in the code into per-partner or per-tenant branches, and a plan that budgets a single task for it meets the rest mid-build, after the scope was agreed. Existence is not arity, so the self-review's reference check below won't catch it: while researching, grep the call sites and sibling implementations of every symbol the change will touch. It costs seconds, and it turns a blowup into a decision — the plan either covers all N branches or builds one and puts the rest on `Deferred:`, priced and signed off before approval rather than discovered after.

The risk clusters at the edges: setup (environment, dependencies, scaffolding) and the finish (deploy, env vars, prod config) are where builds fail; the middle application logic is the reliable part. Add setup and deploy tasks early instead of trusting them to fall out at the end.

## Write for an implementer with zero context

Assume the implementer is a capable engineer who knows nothing about this codebase or problem domain and has questionable taste. Everything they need is in the plan: which files to touch, the actual code, how to test it, what "done" looks like. They may read tasks out of order, so each task stands alone.

The bar is the **intern test**: if a clear brief would let a competent intern do this task, an agent can. If even a sharp intern would have to come back and ask, the gap is ambiguity in your plan — not a limit of the model — and the fix is to close it here, not to wait for a stronger model.

### File structure first

Before defining tasks, map which files get created or modified and what each is responsible for. This is where the decomposition gets locked in.

- One clear responsibility per file. Files that change together live together — split by responsibility, not by technical layer.
- Focused files are more reliable to edit (yours and the implementer's). If a file is growing unwieldy on the path you're touching, planning a split is fair; don't unilaterally restructure unrelated code.
- In an existing codebase, follow the established patterns rather than imposing new ones.

### Bite-sized tasks with real content

Each task produces a self-contained, testable change. Within a task, the steps follow the test-first rhythm — write the failing test, see it fail, implement the minimum, see it pass, commit (see `compound-v:test-driven-development`). That per-task commit is the rhythm, not a verdict: when the plan runs in batches, none of these has been rechecked yet, and **compound-v:batched-implementation** marks the batch's *final* commit as the verified one. Keep the step; don't read it as the batch boundary. Right-size the granularity to the work: don't fetishize a separate "run it to see it fail" line for a one-line mechanical step, but never collapse real behavior into "implement the feature." **Code in the plan is source, not illustration** — the implementer transcribes your snippets faithfully, bugs and all, so a plan can be 100% conformant and still ship two blocking bugs because the bugs were in the plan. Snippets carry the same correctness bar as shipped code.

```markdown
### Task N: <component>

**Files:**
- [NEW]    `src/exact/path.py`
- [MODIFY] `src/exact/existing.py:123-145`
- [DELETE] `src/exact/dead.py`
- [TEST]   `tests/exact/path_test.py`

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

Start the plan with a **preamble** the implementer inherits before any task: a one-line goal, a plan-level `Done = <machine-checkable signal>` (the command or eval that says the whole plan is finished — each task has its own test, but the plan as a whole needs one too), two-to-three sentences on the approach with key libraries, the **global constraints every task must honor** — version floors, dependency limits, naming/style and security/perf rules, platform requirements — one line each, plus which one wins for any two that can pull against each other (a fresh batch implementer sees only its own tasks and silently regresses any unstated constraint to model defaults, and resolves an unranked pair — a latency budget against a retry policy — whichever way its own tasks make cheapest, green either way because a batch's tests assert only its own tasks), a **deferred list** opened by the literal label `Deferred:` starting its own line — stay in the preamble, don't give it its own heading, or it displaces the `## User Review Required` block below from being the plan's second section and swallows everything after it — naming what this plan deliberately does *not* build and the settled decisions an implementer must not re-open (`compound-v:recheck` greps this list to prove the deferred thing was not built, and **recheck's grep is the kit's one executable anti-overkill check**; the fixed line-initial label is a separate and lesser thing — it is what lets the structure checks downstream confirm the list exists at all, rather than reporting clean against a section nobody wrote. Neither has anything to run against unless you write the list; **"Deferred: none" is a first-class answer**, and a truer one than inventing plausible non-goals to look thorough, which only sends the reviewer hunting features nobody ever proposed), and a **distilled fold-in of the research** — the real files, the line ranges, the data-flow facts, and the canonical/anti-pattern you found. The implementer has none of your context; whatever you learned and don't write here, they re-discover from scratch or guess. Add a **divergence rule** too — if a load-bearing assumption proves false mid-build, the implementer stops and reports back rather than improvising in code or looping; give an explicit budget (e.g. after ~3 failed attempts at the same thing, surface it instead of grinding). And a **User-Review flag** — call out up front, in the preamble, anything destructive or irreversible the plan introduces (a migration/backfill, a deleted public API, a prod-config change) so the human signs off before the implementer runs it autonomously, not after (a `## User Review Required` block — breaking changes, significant design decisions — belongs as the plan's second section).

## No placeholders

A placeholder in a plan is a decision you pushed onto someone with less context — it becomes a guess in the code. These are plan failures; don't write them:

- "TBD", "TODO", "implement later", "fill in the details"
- "Add appropriate error handling / validation / edge cases" — name them, or write the code
- "Write tests for the above" with no actual test code
- "Similar to Task N" — repeat the code; the implementer may read this task first
- Steps that say *what* without *how* (code steps need code blocks)
- References to types, functions, or methods no task defines

## Verification Plan

**Every plan ends with this section; it is not optional.** State the done-criteria as commands with their expected results, never as prose — that is what makes "blocking" objective downstream, because a reviewer can then rule a finding blocking on the grounds that it violates a criterion the plan stated in advance, rather than on the strength of their own opinion. The per-task tests prove each piece; this proves the whole thing holds together. Two parts:

- **Automated** — the exact commands a fresh session runs to confirm done, each paired with the result that counts as pass: `pytest -q` green, `ruff check .` clean, `npm run build` exit 0, `curl -s localhost:8000/health` returns 200. Write them runnable, not described. This is the plan-level `Done =` signal, made executable.
- **Manual** — what a machine can't assert: the thing to click, the screen to eyeball, the case to try by hand. Keep it to what genuinely needs a human; if a step *can* be automated, move it up.

The tests *are* the done-signal, so the plan must forbid editing a test to make it pass: when a test fails the suspect is the code under test, not the test — change the test only if the task is explicitly about the test. Defend the criterion from the other side too: pair each one with the negative constraint that rules out the cheat — *tests pass* **and** no assertion weakened, no expected output hardcoded — because an agent rewarded only for green tests will hardcode the green (specification gaming).

## Self-review the plan

After the plan is complete, read it against the spec with fresh eyes. This is your own pass, not a subagent — with the one autonomy-gated exception below.

- **Resolve every reference — run this, don't read it.** Confirm each path, symbol, line range, command and dependency the plan names actually exists: `ls` the files (and confirm `[NEW]` paths *don't* exist yet), grep the symbols, check the manifest, and execute each Verification Plan command in its cheapest form (`--help`, `--version`, `--collect-only`). A `Done =` signal that isn't a runnable invocation here is fiction, and finding that out costs five seconds now versus a whole batch later. This is the only check available at plan time that isn't an opinion — no reviewer, human or agent, catches a plan built on a misremembered repo by reading it. Spend here first.
- **Spec coverage** — for each requirement in the spec, point to the task that implements it **and to the line in the Verification Plan that proves it** — the observable behavior a user would check, not the unit test of the mechanism the plan happened to pick. A requirement mapped only to a task is a requirement nothing asserts: passing tests don't prove the app boots. List the gaps; add tasks to fill them.
- **Re-scope staleness** — if the scope moved while you were planning, re-read the earlier sections against the *final* scope and name every task now obsolete, redundant, or needing rework. You hold the new frame and will read the old text as though it already said the new thing; this is the one defect that grows quietly every time a plan is revised. Give it something to check against: whenever answering a question or a round of feedback *changes* the plan, append one line to a `## Clarifications` section — `Q: <what was open> → A: <what was decided>`, dated. It sits after the last task and immediately before the Verification Plan, so it displaces neither the `## User Review Required` block from second position nor the Verification Plan from last. When the answer *binds* the implementer — a constraint, a settled interface, a decision they must not re-open — write it into the preamble too, not only here: `compound-v:batched-implementation` builds a batch brief from the preamble and the task text and nothing else, so a decision that lives only in `## Clarifications` reaches nobody who is building. It costs a line, it is the only record that a decision was ever made (the intermediate states are not committed and git cannot recover them), and it is what turns this bullet from an instruction to remember into a list you can read the tasks against. A plan nobody revised has no Clarifications section, and that is the correct outcome, not a gap.
- **Task justification** — for each task, and each new file, abstraction, config surface and interface it introduces, name the requirement it serves. Anything serving none is the cut. Ask once and move on: re-asking an unchanged plan to "find more over-engineering" manufactures findings rather than catching them.
- **Placeholder scan** — hunt the patterns above and resolve every hit; `grep -nE '(TBD|TODO|implement later|fill in|Similar to Task)'` is exact where eyeballing is not.
- **Structure check** — confirm the plan carries what this skill mandates, by grep rather than by memory: `grep -nE '^## Verification Plan|^[[:space:]]*[-*]?[[:space:]]*\**Deferred:|Done =' <plan>` must hit all three (the deferred pattern tolerates a bullet or bold markers, because `**Deferred:**` and `- Deferred:` are both natural ways to write it and a bare `^Deferred:` silently misses them), and `^## User Review Required` must hit if and only if the plan introduces something destructive or irreversible. Then *read* for the two that have no fixed string — the global constraints and the divergence rule — and don't pretend that part was a grep. This is the cheapest check on the page and it catches what everything downstream assumes away: a plan with no Verification Plan gives the reviewer no criterion to rule a finding blocking against, and a missing deferred list turns the anti-overkill grep into a no-op that reports clean. You wrote the file, so you are the reader least likely to notice a section that never got written.
- **Type consistency** — do signatures and names line up across tasks? `clearLayers()` in Task 3 and `clearFullLayers()` in Task 7 is a bug waiting to happen.

Fix inline and move on — then, if the plan will run unattended, add the pass below before you hand off.

### One fresh pass — only when the plan will run unattended

Add a single read-only reviewer in a fresh context (`compound-v:recheck`'s discipline; the `code-reviewer` agent in artifact mode) when **nobody will read a diff between this plan and the merge** — an overnight run, a scheduled or autonomous build, a handoff to a session you won't be in. **Gate this on autonomy, not on tier.** With a human watching batch 1 land, a wrong plan surfaces in one batch at one batch's cost and the extra dispatch is the overkill this kit refuses; with nobody watching, the same error costs the whole run.

Hand it the plan and the spec — never the conversation that produced them, which would hand it the assumption that made the plan wrong. Its one structural advantage is **deferral integrity** — confirming every entry on the deferred list is genuinely absent from the tasks, which is the check you are worst placed to run on a list you wrote. It also gets a second, colder look at the **stale decisions** the self-review above hunts; that bullet is the primary catch, and this is the backstop for a re-scope you no longer remember making. It returns findings; *you* decide scope, because you hold the user's context and it doesn't. If you are yourself a subagent you cannot dispatch this pass at all — nesting is zero levels deep, and running it "inline" would forfeit the fresh context that is the entire point. Skip it and say so in your report.

Be honest about its ceiling: a fresh pass by the same model removes anchoring, not the model's own blind spots, and a reviewer of prose has no ground truth to appeal to — which is exactly why the resolve-every-reference check above runs first and why "no findings" must be an expected, unremarkable outcome. If its findings turn out to be things the first batch's recheck would have caught anyway, delete this layer.

Then save the plan to `docs/plans/YYYY-MM-DD-<feature>.md` (user's location preference wins), **commit it before the first batch runs**, and hand off to `compound-v:batched-implementation` to execute it. The commit is what makes the plan a baseline instead of a scratch file: `compound-v:recheck` greps the deferred list and rules findings blocking against the Verification Plan's criteria, and both checks report clean against a plan that was quietly edited to drop an entry or soften a criterion. Committed, that edit is a diff anyone can read. Revising the plan mid-run is expected; weakening a done-criterion so a failing batch passes is not, and it is the one plan edit you surface to the user rather than make.

## A product PRD is a different artifact
A PRD is the product's *stable* source of truth (goal, core functions, tech stack), read first for context — not a per-build plan. It has its own skill: **compound-v:writing-prd**. The split earns its keep as generated code gets cheaper: models improve until regenerating from a good spec beats maintaining the output, which cuts both ways — don't over-plan code you'll throw away, and treat the instructions as the durable asset, worth more than the code they produce.
