---
name: get-shit-done
description: Take a whole project from a stated goal to a real, working thing someone outside the build has used, and hold it to the MEP bar at the end. Use when the ask is a project rather than one feature — "build me X", "make this real", a wish-list, a founder brief, a PRD, an idea that sounds too hard to finish, an overnight or multi-session run — and again when someone asks "is this actually done", "is it real", "did we drift from what I asked for", or "will the next change force a rewrite". Not for a single feature (compound-v:brainstorming) or a one-liner.
---

# Get Shit Done

Most projects that look impossible are a handful of parts, two of which are genuinely unknown. Find those two, learn how they are already solved, and most of what is left is typing — Thorsten Ball's working code-editing agent was ~300 lines and three tools: *"an LLM, a loop, and enough tokens. The rest … Elbow grease."* Overestimating is the default failure, and models are worse at it than people: asked for a hard thing, a model reaches for architecture instead of the two facts that would collapse it. But **buildability is rarely the constraint; effectiveness past the demo is** — *"creating products and systems that are effective—beyond a demo—remains deceptively difficult."* Stages 3 and 4 are aimed there.

This skill is the **project-level spine**: four stages, each handing the actual work to a skill that already owns it, and a loop rather than a line — an incident re-enters at the top.

## When to use

- The ask is a whole product, system, or multi-part build; or a sprawling brief where nobody has said what the parts are.
- A long or unattended run is about to start from a goal rather than from a plan.
- A run is about to be called finished because the tests are green, the boxes are checked, or the branch merged. Stage 4 runs standalone for this.
- **Skip it** below Large tier (**compound-v:using-compound-v** carries the tier table) — a Standard feature is **compound-v:brainstorming** → **compound-v:writing-plans** → **compound-v:batched-implementation** → **compound-v:recheck** — and skip it when the ask names no outcome anyone outside this session consumes. An internal API, CLI, job or library is *in scope*; its user is whoever calls it. A skip is announced where the verdict would have gone.

## Two units: the slice you build, the row you count

A **slice** is one capability a user can reach end to end — the sentence they would say: *"I get a DM on day 7 when a storyboard is late."* Not a layer, not "the database". A project is 3–7 slices; more and you are listing tasks, fewer and it is a feature — route down. **Slices are the build order.**

A **row** is one function inside a slice, at the grain of a thing a person could attempt. **Rows are the denominator.** A handful of slices can carry two hundred rows, and the 10% that never lands is invisible at slice grain — nine of ten done still looks like a slice in progress.

| Stage | What the spine decides | Who does the work |
|---|---|---|
| 1 Carve | the slices, their order, their checks | **compound-v:frame-the-goal** turns a fuzzy check into a real one |
| 2 Recon | how much research each slice earns | **compound-v:searching-patterns** for the pattern + anti-pattern |
| 3 Build | one slice at a time; what closes it | **compound-v:writing-plans** → **compound-v:batched-implementation** → **compound-v:recheck** |
| 4 Reckon | the verdict, and what outlives the run | **compound-v:finishing** lands the branch first |

Cede rather than re-derive: whether to build at all is **compound-v:startup-taste**, one claim is **compound-v:verification-before-completion**, a pass rate over a probabilistic path is **compound-v:evals**, reaching anyone is **compound-v:founder-distribution**. This skill never reads a diff and never emits a severity-tagged finding list.

## The ledger: what makes 100% enforceable

A long run degrades silently unless its procedure and its state live on disk: sessions are discrete and *"compaction isn’t sufficient"* to carry a procedure across them. Anthropic ran this at over 200 rows for one app, every row failing at the outset, letting the agent change nothing but the status field.

> **The done rule — every declared row is `passed` or `dropped`-with-attribution. Nothing may remain `todo` or `building` at the verdict, and `blocked` is not success.**

That is what makes *"we're at about 90%"* unsayable. Five invariants hold it up, conditions true or false at any moment rather than steps in an order. **references/completion-ledger.md** carries the schema, the status vocabulary and the reasoning — read it when you open a ledger and again at the gate.

- **The floor** — a capability with open rows and no passing row **did not ship**, whatever the percentage says.
- **Denominator** — rows come from the brief, the plan, and whatever the build discovers. **A requirement with zero rows is scope nobody was assigned**, the largest single source of the missing 10%.
- **Flip** — green only on a check seen **red first, for the right reason** (**compound-v:test-driven-development**'s red step) plus an end-to-end run driven as a user.
- **Delta** — appending is legal, flipping is not. A drop declares its kind: `void` (nothing owed) or `moved` (a successor row is mandatory). A drop that moved and named no successor is how a capability quietly empties out.
- **Blocked is not done** — three failed attempts marks a row `blocked`, blocker named (**compound-v:systematic-debugging** owns the cap). Give the run a legal way to say *this did not work*.
**The agent may not edit what grades it.** Status flips, appended rows and stage-2 slice fields (`shape`, `trap`, `delete`, `force`) are legal writes; a row's `does`, a drop already made, and any check are frozen. A superseded `shape` is appended to rather than overwritten, carrying what falsified it. Models trained on gameable environments generalize to *directly rewriting their own reward function*.

**The ledger needs an engine, or it is only a record of where you stopped.** This kit ships one: a `Stop` hook that **refuses the exit** while any row is open or the ledger cannot be read honestly — an unreadable row counts as open, never done. Capped at one block per turn. `bash scripts/ledger.sh --open` prints the same number for a human.

The run holds two files, both scaffolding, both deleted when it ends: **`.claude/STATE.md`** (prose, owned by **compound-v:handoff** — its **Next** names a row id) and **`.claude/slices.json`**. JSON deliberately: the model is *"less likely to inappropriately change or overwrite JSON files compared to Markdown files"*.

**Attended runs get three *kinds* of scheduled interrupt**: the Carve+Recon approval, one line per landed slice, the verdict. **Unattended runs get zero** — take the reversible default, write it down, keep going. The one unscheduled interrupt in either mode is a **one-way door the recon did not resolve**: a schema, a public API, a spend, an irreversible write. Stop and ask, even overnight.

## Stage 1 — Carve

**If nobody has yet asked whether this should exist, that gate runs before the carve** — **compound-v:startup-taste**. Carving is a commitment to build.

Quote the **original ask verbatim** into the ledger's `ask` field first — not your summary, and not the plan or spec, both of which get written mid-run and absorb the drift.

Stage 1's output is `slices.json`, and it exists before any code. Per slice, four things and no more:

- **Capability** — the user's sentence.
- **Check** — what run command, or what one named human, says this slice works. Vague here is fatal; hand it to **compound-v:frame-the-goal**. **One row carries it, marked `is_check: true`** — a slice that never turns its check into a row can pass everything it has and still miss the thing it was for.
  **Write the check from what would show the goal UNMET, because that is what differs between kinds of goal.** A *behaviour* goal's ground truth is a run. A *replication* goal's — *"like X"*, *"port this"*, *"match the design"* — is the source, so the check is a comparison, and a row that never touches the reference measures the wrong thing however green it goes. A *property* goal's is an adversarial probe, never the happy path. A *removal* goal's is absence plus nothing-else-broke. A *migration* goal's is old and new agreeing. A check aimed at the wrong truth passes while the goal fails.
- **Unknown** — the one line naming what might not work.
- **Confidence** — Steinhardt's buckets, coarse on purpose: *no unforeseen difficulties* (~95%), *"modulo Murphy's law"* (~90%), *the basic path is visible and every step should work* (~65%), *"only … a murky view of the path"* (~30%).

**Then fill each slice with its rows** — every function the goal declares, each a witness case with a concrete input and an observable outcome, all starting failing. A function that is not a row here is one no later check will ever look for. **Nothing else will write this file for you, and the gate is silent without it**: skipping stage 1 does not get you a lenient pipeline, it gets you no pipeline.

**Order by what fails fastest, not by what is easiest.** Easiest-first wastes the easy work when the hard part turns out infeasible — *"The work on the easy parts was mostly wasted."* Sort by information per unit time: a quick slice you have never done outranks a long one you have done many times. **De-risk all components, then execute.**

**Slice 1 is the burning function, end to end, with the hard parts faked.** Wire the whole path with a cheating version of the hard component: if it works, a real implementation will too; if it doesn't, you saved building it. Its pair is a baseline, the dumb off-the-shelf version — *"complicated methods often underperform simple baselines"* — and a baseline that clears the check deletes the slice outright.

**Then say what the ask named that is not a slice, and who asked for it** — as `notSlices`, one entry per item with `item`, `askedBy` and `why`. Anything with no answer is drift-in before a line is written. This is where a sprawling brief gets honest: *an AI that runs the whole agency* is not a project, it is four named parts, one of which is a job that reads a date and sends a message.

## Stage 2 — Recon: one question, and the answer is a shape

**Ask one question per slice, and make it this one:** *what is the simplest thing that has actually shipped for this, and what did it cost the people who shipped it?* An open question over a good corpus returns mostly restatement — it is the question, not the number of lanes, that makes recon expensive.

**The output is a decision, not a report — and it lands in `slices.json` or it did not happen.** Name the **shape** (the architecture someone experienced would reach for), its **trap** (the second-order cost invisible on day one), and what the shape lets you **delete** — these land as slice fields in **references/completion-ledger.md** (which carries a fourth, `force`, for what the plan did not name), and a shape left in the conversation dies with the session. Shape-and-trap is the whole reason the corpus exists: an agent has read more code than any of us and has none of the scar tissue. The mechanism climb and the Simple/effective/scalable test are **compound-v:simplest-thing-that-works**; the API-level pattern is **compound-v:searching-patterns**.

**Look the shape up before you research it.** compound-v:searching-patterns carries a curated table of arrangement-plus-trap pairs, and a hit *is* the whole of recon for that slice. It is a cache with a miss path, so most slices miss and a miss is the rule working. On a miss you get **one hunt, scoped to that one domain**, at build time, never a standing sweep. The budget is the `confidence` stage 1 wrote down:

| `confidence` | what recon costs |
|---|---|
| ~95% — *no unforeseen difficulties* | nothing. Write the shape you already hold. |
| ~90% — *modulo Murphy's law* | the lookup only; on a miss, write what you know and move. |
| ~65% — *the basic path, and the steps should work* | one lane, the one question, one pass. |
| ~30% — *a murky view of the path* | the full ladder — three channels cheapest-first, **references/prior-art.md**. |

When the hunt dispatches an agent, its brief is **references/prior-art.md**'s dispatch block, pasted verbatim. That file also owns how to read a corpus — enumerate lanes live, a local library is several lanes, `MUST`/`STRONG`/`OPTIONAL` sets **order, not inclusion** — which is context the dispatch block itself does not carry, so hand the worker both. If the environment ships a corpus-investigation skill (`workflow-investigation` is one), invoke it rather than re-deriving where things live.

**The band is a pre-investigation guess, so an observable signal can overturn it** — a shape-table miss on a slice you banded ~0.9, or a first read contradicting its `unknown`. Re-band once, out loud, in the ledger, and **the legal revision is upward in recon** — which on this table means *downward in confidence*, from ~0.9 toward ~0.65 and its extra lane. Re-banding the other way mid-hunt, to buy yourself less work and an earlier stop, is the same move as editing a check to make it pass. Both failures are live and opposite — the measured sweeps over-researched what was known, while the one real ledger skipped recon on exactly the slices that needed it.

**Stop when you can name the shape and its trap, or when two independent sources converge** — not when the lanes are exhausted, and never on a source's grade. A lane at zero is a defect you justify, not a gap you pass over. **An empty `delete` is a red flag, not a clean bill**: write `[]`, never nothing.

**Recon returns a file:line map, not prose** — a cited line either exists or it does not, where a confidently hallucinated architecture reads exactly like a real one. Feed it forward: the shape into the plan, the trap into **compound-v:recheck** as a named checkable assertion, all three into the ledger. At Reckon, a shape that will recur graduates into the table.


## Stage 3 — Build one slice at a time

The failure this shape prevents is measured. A frontier model in a loop from a high-level prompt *"tended to try to do too much at once"*, and later *"a later agent instance would look around, see that progress had been made, and declare the job done."* The fix is theirs: **one feature at a time**, *"This incremental approach turned out to be critical"*.

Build it however you build things; **compound-v:writing-plans**, **compound-v:batched-implementation** and **compound-v:recheck** own that. The spine owns what a *closed* slice looks like:

- **You ran what already exists first.** The thing starts, one primary action works, the previous slice still holds. If the agent starts implementing instead, *"it would likely make the problem worse."*
- **The hit band was declared before the build, not after.** What fraction of real inputs this slice handles, and what the misses see. *"It breaks"* is not an answer; *"it says X and routes to a human"* is. Build to the middle and **give the tail a named exit**. The exception is the axis **compound-v:make-it-stable** draws: irreversible writes, money movement, data loss, silent corruption or a stranger-facing surface get the production bar on the bad path too.
- **Every row you are closing was walked as a user, on the assembled product.** A slice walk closes only the rows it demonstrably exercised.
- **You scanned the slice's diff for what you left behind** — `TODO`, `FIXME`, `stub`, `placeholder`, `mock`, `hardcoded`, `for now`, a skipped or `.only` test, a swallowed error. Each hit is a row or a named waiver. A missing declared function is a `todo` row; a stub the implementer *left* was declared by nobody, and that is the hole the denominator cannot see.
- **What you gave up under pressure was elements, not quality.** Shipping all of it worse is how those stubs get written. Delete instead: drop each element whose removal still leaves the slice useful, down to the `is_check` row and not through it. Every cut is a `dropped` row, `moved` where it returns.
- **Nothing that grades the work moved.** Never edit a check to make it pass — *"It is unacceptable to remove or edit tests because this could lead to missing or buggy functionality"*. A threshold quietly widened at hour six is indistinguishable from success.
- **One slice, one commit, and the commit moves the ledger.**

**The walk is the one rigid condition, because it is the documented failure.** Claude would make the change, run unit tests, curl the dev server — and still not notice that *"the feature didn’t work end-to-end"*. Lint and type-check are the verification that was already automated; the question is **can the agent run the thing**, and it is the first thing dropped when nobody is watching.

**When the walk fails, it is a root-cause question, not a retry** (**compound-v:systematic-debugging**). On the third failed close, say which is true: the slice splits, the check was wrong, or stage 1's unknown was real. Where the answer is *the shape is wrong*, run the call below **before** you mark anything — `blocked` is what you mark when the replacement failed too, not instead of trying it.

### Repair or replace — decide it by running it, never by estimating it

The third patch onto the same shape is a decision being made by default. Make the decision deliberately instead, and make it on evidence: **build the replacement in a throwaway worktree and run the existing check against both** — *"if one experiment fails, I throw away that worktree and nothing is lost in main."* The under-selection is measured: on held-out checkpoints, two of three frontier models met rising requirements by making functions bigger *"rather than moving things around"*, one going from 4.6% duplicated lines to 16.8%. *Why* is less settled — scoring pairs the fix with `PASS_TO_PASS` and *"there is no penalty for eroding codebase maintainability"*, which would reward minimal additive change, but that is a reasonable read rather than a demonstrated cause. Rely on the behaviour, not the explanation, which is why the answer is a run and not an argument.

**Say what the run decides before you start it:** replace if the rebuild passes a check the incumbent fails, or passes the same one with the next change landing in one place instead of many. Otherwise repair — and a rebuild that merely *feels* cleaner while both arms pass identically is the incumbent winning. Decide the criterion after the run and the arm you enjoyed building wins.

Three conditions separate this from licence:

- **The check pre-dates the replacement, and you know what it cannot see.** The whole-runtime port everyone cites named its substrate as load-bearing — *"he defined a test suite … it's very, very well tested … So it's easy to know if you did the right thing."* Grading a rebuild with tests the rebuild wrote is the reward-tampering rule above in a new hat. But a check covers only behaviour someone wrote down, and what a rewrite loses is the behaviour nobody did — the edge cases the old code earned in production. Recover that contract first (**compound-v:extracting-specs**); a green bake-off over a thin suite is a confident way to ship a regression.
- **Name which cost you are paying.** Producing a replacement collapsed: that port ran **eleven days** on one steered prompt (a second telling says a week) against a human estimate of *"definitely over a year"*. Judging did not, and that is the cost to plan around — an agent loop reported a renderer at 88ms → 1.5ms, which reads as success until you learn the hand-written version was *"roughly 75x better"* again. Nothing touched the third cost: migrating accumulated data, or a published surface whose migration is *other people's* work. So run the seam test — *if I am wrong, can I fix this by rewriting code, or only by migrating data?* Code-only is machinery, and machinery was always meant to be replaced.
- **The rows move with it, and the rebuilder does not rewrite them.** The replaced thing's open rows are `moved` with successors named, never `void`; its passed rows go red and are re-walked. Each successor inherits its predecessor's `does` — one promising less is editing a check by another route.

Keep the scale honest: whole-product one-shotting is the *other* documented failure and it is first on the list. This is a move inside one slice, not a licence to restart the project.

**Dispatch the check, not the build.** The measured payoff for a fresh context is in *judging* work, not producing it — a clean-context reviewer finds around two real bugs per pull request on code the same system wrote, most severe, precisely because it shares no context with the author. Every measured result on dispatching the *build* runs the other way, and **the skimping is the ledger's job, not dispatch's**: an agent identified **20 call sites**, changed **5**, and stopped, and what fixed it was an in-context checklist. **Do not dispatch because there are many tasks.**

**The check is dispatchable; the build is not — and the condition that decides it is this: dispatch a slice only where you can re-run its check yourself, without the worker's trace** — otherwise the split bought context isolation at the price of an unauditable ledger. **The worker returns evidence; the orchestrator flips the row.** Workers never write `slices.json` — the single-writer rule **compound-v:handoff** applies to `STATE.md`, plus one this ledger adds: a worker that can flip its own row is a worker grading its own homework. Its brief carries the slice's rows, check, shape and trap: dispatch makes the ledger the only path from one slice's lesson to the next slice's worker, so a run whose `shape` and `trap` sit empty has no carrier at all.

## Stage 4 — Reckon: the MEP bar over the assembled product

Put the goal beside what exists and say plainly how much is real — including *"we have been busy for six hours and the product is not closer to a user."* The bar is **MEP, the minimum evolvable product**: it survived contact with a real person, and the next change is one you can afford. *Viable* is a bar an agent clears by writing code that runs, which is what produced that six-hour run.

**Afford is priced in migrations, not in retyping.** A next change that forces you to rebuild a component is a Tuesday; one that forces you to migrate accumulated data, or a published surface others depend on, is the thing to have avoided. Only the second is a defect in what you shipped.

**100% is over a declared denominator, never over every axis.** Every row you *declared*, passed or dropped with a name on it — not every requirement anyone could name. The second target does not ship: against a list running reliability, harmlessness, factual consistency, usefulness, scalability, cost, security, privacy and fairness, the verdict is *“If we try to tackle all these requirements at once, we’re never going to ship anything”*. So choose the denominator at Carve, put the rest into `notSlices` with a name against it, then finish **all** of what remains. A run measuring itself against every axis it can imagine is at 80% forever, its missing 20% undeclared rather than unbuilt.

Four checks against the assembled system; **references/mep-gate.md** carries how. **Alignment** — does it still answer the ask, and what exists nobody asked for. **Reachability** — walk every capability end to end on an input you did not construct, then cold-start it. **Survival** — who used it who did not build it, on a clean artifact. **Evolvability** — the two likeliest next changes, and what each forces.

The **clamp**: a finding blocks only if it names a real user blocked from a capability the goal asked for, or a next change that forces a migration you cannot afford.

### The verdict — one word, then the next action

- **DONE** — every capability the goal named is reachable on the assembled product, the survival bar for this ask was met on a clean artifact, and neither next change forces a migration you cannot afford.
- **DONE WITH GAPS** — every goal capability reachable, survival bar met, gaps named and counted in the same breath. It ships; the gaps return at the next finish.
- **UNPROVEN** — built, complete, green, and nobody outside the build has touched it. The remaining work is finding the first user, not more code.
- **NOT_DONE** — the default. Return the remaining work as addable tasks: which capability, which path, what would close it.
- **DRIFTED** — what exists is no longer what was asked for. Route back to the original ask, not to the plan.

A hand-off is not a verdict: "pushed", "PR opened", "ready for review" are all stopping while work is open, and manual steps handed back to the user are unfinished work relabelled. **The next action is the one that closes the biggest gap to MEP, not the most comfortable one** — name the gap, name the comfortable alternative, and say why you are not doing it.

**Discharge before the landing commit** — the ledger goes, but never undischarged: every passed row first names a durable target that outlives the file, and an incident opens a row before it opens a fix. `bash scripts/ledger.sh --discharge` refuses the landing until that holds.

## Red flags

Nothing here blocks on its own; every row routes back to a stage, and the clamp decides.

| Smell | What it means |
|---|---|
| Recon came back and the plan got *bigger* | You researched how to build it, not whether to. Re-run stage 2 for the DELETE list. |
| The architecture arrived before the second fact | The overestimate failing loud. Two lookups usually collapse the design; do them first. |
| A slice with a check like "it looks right" | Not a slice yet. The verifiable criterion is what makes the speed real, and real software only gets one if you write it. **compound-v:frame-the-goal**. |
| "Basically done, just polish left" / "this laid the foundations" | Two names for one smell: nothing a user can do today that they couldn't yesterday, counted as nearly finished. Name what's left; that list is the remaining project. |
| A ledger bit flipped without a walk, or a check edited late in the run | The two failure modes this skill is built around. Confirm the check goes red without the change, and suspect it hardest at the end of a long run. |
| The same gap N rounds running, or a different gap every round | **compound-v:systematic-debugging**'s attempt cap. The product-level addition: if every remaining gap needs something you don't hold — a real user, a credential, a live environment — no round closes any of them. Name the blocker and stop. |
| "Too complex / would take days" | Not authorization to deliver less. Say it out loud, go back to stage 2, and find who already solved it. |
| A third patch onto the same shape, or a compatibility shim over a design nobody defends | The replace-or-repair call is being made by default rather than made. Run it. |
| A rebuild was declined on an estimate nobody measured | Estimating is the failure mode. Build it in a worktree against the existing check and read the result. |
| Round after round of engineering and the metric will not move | Suspect an **invisible asymptote** — *"a ceiling that our growth curve would bump its head against if we continued down our current path"*. Some ceilings belong to the path, not the effort. The move is a different path, named out loud, not another round. |
