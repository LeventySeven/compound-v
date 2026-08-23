---
name: get-shit-done
description: Take a whole project from a stated goal to a real, working thing someone outside the build has used, and hold it to the MEP bar at the end. Use when the ask is a project rather than one feature — "build me X", "make this real", a wish-list, a founder brief, a PRD, an idea that sounds too hard to finish, an overnight or multi-session run — and again when someone asks "is this actually done", "is it real", "did we drift from what I asked for", or "will the next change force a rewrite". Not for a single feature (compound-v:brainstorming) or a one-liner.
---

# Get Shit Done

Most projects that look impossible are a handful of parts, two of which are genuinely unknown. Find those two first, find out how they are already solved, and most of what is left is typing.

That is not optimism. Thorsten Ball built a working code-editing agent in ~300 lines and three tools — *"an LLM, a loop, and enough tokens. The rest … Elbow grease."* — and answered the sceptic directly: *"I bet it's a lot farther than you think."* Overestimating is the default failure, and models are worse at it than people: asked for a hard thing, a model reaches for architecture instead of for the two facts that would collapse it.

This skill is the **project-level spine**: four stages, each handing the actual work to a skill that already owns it, and a loop rather than a line — an incident re-enters at the top.

## When to use

- The ask is a whole product, system, or multi-part build; or a sprawling brief where nobody has yet said what the parts are.
- A long or unattended run is about to start from a goal rather than from a plan.
- A run is about to be called finished because the tests are green, the boxes are checked, or the branch merged. Stage 4 runs standalone for this.
- **Skip it** below Large tier — a Standard feature is **compound-v:brainstorming** → **compound-v:writing-plans** → **compound-v:batched-implementation** → **compound-v:recheck**, and this spine sits above that — and skip it when the ask names no outcome anyone outside this session consumes. An internal API, a CLI, a job or a library is *in scope* — its user is whoever calls it. A skip is announced where the verdict would have gone, never silent.

## Two units: the slice you build, the row you count

A **slice** is one capability a user can reach end to end — named as the sentence they would say: *"I get a DM on day 7 when a storyboard is late."* Not a layer, not "the database", not "the API". A project is 3–7 slices; more than that and you are listing tasks, fewer than three and it is a feature — route down. **Slices are the build order.**

A **row** is one function inside a slice, at the grain of a thing a person could attempt. **Rows are the denominator.** A project has a handful of slices and can easily have two hundred rows, and the 10% that never lands is invisible at slice grain — a slice with nine of its ten rows done still just looks like a slice in progress.

| Stage | What the spine decides | Who does the work |
|---|---|---|
| 1 Carve | the slices, their order, their checks | **compound-v:frame-the-goal** turns a fuzzy check into a real one |
| 2 Recon | how much research each slice earns | **compound-v:searching-patterns** for the pattern + anti-pattern |
| 3 Build | one slice at a time; what closes it | **compound-v:writing-plans** → **compound-v:batched-implementation** → **compound-v:recheck** |
| 4 Reckon | the verdict, and what outlives the run | **compound-v:finishing** lands the branch first |

Cede rather than re-derive: whether to build at all is **compound-v:startup-taste**, one claim is **compound-v:verification-before-completion**, a pass rate over a probabilistic path is **compound-v:evals**, reaching anyone is **compound-v:founder-distribution**. This skill never reads a diff and never emits a severity-tagged finding list.

## The ledger: what makes 100% enforceable

A long run degrades silently unless its procedure and its state live on disk: sessions are discrete, and *"compaction isn’t sufficient"* to carry a procedure across them. Anthropic ran the row idea at over 200 rows for a single app, every one marked failing at the outset, and let the coding agent change nothing but the status field.

> **The done rule — every declared row is `passed` or `dropped`-with-attribution. Nothing may remain `todo` or `building` at the verdict, and `blocked` is not success.**

You reach 100% by passing a row or by cutting it out loud with a name on it, never by forgetting it. That is what makes *"we're at about 90%"* unsayable. Five invariants hold it up — they are conditions that are true or false at any moment, not steps in an order. **references/completion-ledger.md** carries the row shape, the status vocabulary and the reasoning; read it when you open a ledger and again at the gate.

- **The floor** — a capability with open rows and no passing row **did not ship**, whatever the percentage says. Rows are not spread evenly across slices, so one that delivered nothing disappears into a healthy aggregate; it is reported by capability, ahead of any row.
- **Denominator** — rows come from the brief, the plan, and whatever the build discovers. **A requirement with zero rows is scope nobody was assigned**, the largest single source of the missing 10%, because it never looked like it was failing; it never looked like anything.
- **Flip** — green only on a check seen **red first, for the right reason** (**compound-v:test-driven-development**'s red step, applied to the ledger) plus an end-to-end run driven as a user, with one line recording what you ran.
- **Delta** — appending is always legal, flipping is not. Discovered work enters as `discovered: true` the moment it is found, and a drop declares its kind: `void` (the requirement does not exist, nothing owed) or `moved` (it changed shape, so a successor row is mandatory). A requirement that moved and named no successor is how a capability quietly empties out.
- **Blocked is not done** — three failed attempts marks a row `blocked` with the blocker named (**compound-v:systematic-debugging** owns the cap). Give the run a legal way to say *this did not work* and it stops needing an illegal one.

**The agent may not edit what grades it.** The only legal write is a status flip and its evidence. Anthropic's reward-tampering work found models trained on gameable environments generalize to *directly rewriting their own reward function*; where a harness can express this as a tool schema rather than a rule, that is the stronger form.

**The ledger needs an engine, or it is only a record of where you stopped.** This kit ships one: a `Stop` hook that **refuses the exit** while any row is open, or while the ledger cannot be read honestly — an unreadable row counts as open, never as done. The harness caps it at one block per turn, so unattended it is one hard shove rather than a loop; say at the start of a run what else re-invokes you. `bash scripts/ledger.sh --open` prints the same number for a human.

The run holds two files, both scaffolding, both deleted when it ends: **`.claude/STATE.md`** (prose, owned by **compound-v:handoff** — its **Next** names a row id) and **`.claude/slices.json`** (the slices and their rows). JSON deliberately: Anthropic reached the same choice after finding the model *"less likely to inappropriately change or overwrite JSON files compared to Markdown files"*.

**Attended runs get three *kinds* of scheduled interrupt**: the Carve+Recon approval, one line per landed slice, and the verdict. **Unattended runs get zero** — take the reversible default, write it down, keep going. The one unscheduled interrupt in either mode is a **one-way door the recon did not resolve**: a schema, a public API, a spend, an irreversible write. Stop and ask, even overnight.

## Stage 1 — Carve

**If nobody has yet asked whether this should exist, that gate runs before the carve, not after it** — **compound-v:startup-taste**. Carving a project is a commitment to build it, and this skill is decisive enough at the routing layer to crowd out the question if you don't ask it deliberately.

Quote the **original ask verbatim** into the ledger's `ask` field before anything else — verbatim, not your summary of it. Not the plan and not the spec — both get written mid-run and absorb the drift, so alignment to them proves nothing.

Stage 1's output is `slices.json`, and it exists before any code. Per slice, four things and no more:

- **Capability** — the user's sentence.
- **Check** — what run command, or what one named human, says this slice works. Vague here is fatal; hand it to **compound-v:frame-the-goal**.
- **Unknown** — the one line naming what might not work.
- **Confidence** — Steinhardt's buckets, which are coarse on purpose: *"I am confident that this can be done and that there are no unforeseen difficulties"* (~95%), *"modulo Murphy's law"* (~90%), *"I see the basic path … and all the steps seem like they should work"* (~65%), *"I have the intuition that this should be possible but only have a murky view of the path"* (~30%).

**Then fill each slice with its rows** — every function the goal declares, each phrased as a witness case with a concrete input and an observable outcome, all starting failing. This is the stage that decides whether the run can ever reach 100%: a function that is not a row here is one no later check can miss.

**Nothing else will write this file for you, and the gate is silent without it.** The engine reads `.claude/slices.json`; no ledger means no rows, no rows means nothing to refuse, and the run ends exactly as it would have. Skipping stage 1 does not get you a lenient pipeline, it gets you no pipeline.

**Order by what fails fastest, not by what is easiest.** The tempting order is easiest-first, and Steinhardt names exactly what it costs: *"I would do all the easy parts, then get to the hard part and encounter a fundamental obstacle that required scrapping the entire plan … The work on the easy parts was mostly wasted."* Sort instead by information per unit time — a quick slice you have never done outranks a long slice you have done many times, because it either fails early and cheap or removes the risk from everything downstream. His summary of the whole discipline is the rule here: **de-risk all components, then execute.**

**Slice 1 is the burning function, end to end, with the hard parts faked.** Steinhardt calls this a ceiling: substitute a cheating version of the difficult component and wire the whole path anyway — *"If the system works, we know that a sufficiently good implementation of the difficult component will yield a working system. If the system doesn't work, we've saved the time of implementing the difficult component."* The pair to it is a baseline, the dumb off-the-shelf version, because *"complicated methods often underperform simple baselines"* — and a baseline that already clears the check deletes the slice outright.

**Then say what the ask named that is not a slice, and who asked for it** — as `notSlices`, one entry per item with `item`, `askedBy` and `why`. Anything with no answer is drift-in before a line is written. This is where a sprawling brief gets honest: *an AI that runs the whole agency* is not a project. It is four named parts — the context store, the metrics, the follow-ups, the proactive nudges — and the one that would actually change someone's week is a job that reads a date and sends a message.

## Stage 2 — Recon: one question, and the answer is a shape

**Ask one question per slice, and make it this one:** *what is the simplest thing that has actually shipped for this, and what did it cost the people who shipped it?* Not "what do the sources say about X": an open question over a good corpus returns mostly restatement, and it is the question, not the number of lanes, that makes recon expensive.

**The output is a decision, not a report.** Name the **shape** — the architecture someone experienced would reach for here — and the **trap** that shape has. This is the whole reason the corpus exists: an agent has read more code than any of us and has none of the scar tissue, and the shape-plus-trap pair is exactly what scar tissue is. Hand the mechanism call to **compound-v:simplest-thing-that-works**, which owns the climb from a rule to a query to a call to an agent; hand the API-level pattern to **compound-v:searching-patterns**. This stage owns only the question and the budget.

**The shape has to pass three tests at once, and dropping any one of them is the failure:**

- **Simple** — you can hold it in your head and say it in a sentence. If explaining it needs a diagram, it is not the shape yet.
- **Effective** — it passes the slice's `check`. A simpler thing that does not is not simpler, it is unfinished.
- **Scalable** — the next 10× does not force a rewrite. This is the one that gets dropped, and it is why "simplest" is not the same as "smallest".

Then the two lists fall out of the shape rather than being hunted separately:

- **DELETE** — what the shape means you no longer build: someone shipped it, a library covers it, the platform already does it, the hard version turned out unnecessary.
- **FORCE** — what the shape makes you handle: a rate limit, an auth dance, a data shape, the named trap.

**An empty DELETE list is a red flag, not a clean bill.** It almost always means you searched for *how to build it* rather than *whether to*, and it is how a plan comes back from research bigger than it went in.

**Stop when you can name the shape and its trap, or when two independent sources converge on the same shape.** Not when the lanes are exhausted. Coverage and depth are different axes: every source lane gets touched — a lane at zero is a defect you justify, not a gap you pass over, and the corpus grows so it is enumerated live rather than from a remembered list — but how far you read in each is bought with the slice's confidence. A ~95% slice gets no recon at all; a ~30% slice gets the full ladder. If the environment ships a corpus-investigation skill (`workflow-investigation` is one), invoke it rather than re-deriving where things live.

Three channels, cheapest first — what is on disk, then primary web sources at your lockfile's version, then practitioners in public, X included. How to search each and how the retrieval fails is **references/prior-art.md**.

**Recon returns a file:line map, not prose.** Name the exact file and line for each claim. Prose is unfalsifiable and a confidently hallucinated architecture reads exactly like a real one; a cited line either exists or it does not, so the map is grep-checkable by someone who was not there.

Feed it forward: the shape into the plan, the trap into **compound-v:recheck** as a named checkable assertion, and DELETE/FORCE into the ledger — a deletion nobody recorded gets rebuilt by the next session.

## Stage 3 — Build one slice at a time

The failure this shape prevents is measured. Anthropic ran a frontier model in a loop from a high-level prompt: it *"tended to try to do too much at once"*, and later *"a later agent instance would look around, see that progress had been made, and declare the job done."* Their fix is the one adopted here — work **one feature at a time**, *"This incremental approach turned out to be critical"*.

Build it however you build things — **compound-v:writing-plans**, **compound-v:batched-implementation** and **compound-v:recheck** own that, and the spine adds nothing to them. What the spine owns is what a *closed* slice looks like, stated as conditions rather than as an order to follow, because the sequence is yours and the conditions are not:

- **You ran what already exists first.** The thing starts, one primary action works, the previous slice still holds. Anthropic's finding on skipping this: if the agent starts implementing instead, *"it would likely make the problem worse."*
- **The hit band was declared before the build, not after.** What fraction of real inputs this slice handles, and what the misses see. *"It breaks"* is not an answer; *"it says X and routes to a human"* is. Build to the middle and **give the tail a named exit** — an exit is a feature, chasing the tail is the defect. The exception is the axis **compound-v:make-it-stable** draws: irreversible writes, money movement, data loss, silent corruption or a stranger-facing surface get the full production bar on the bad path too.
- **Every row you are closing was walked as a user, on the assembled product.** A slice walk closes only the rows it demonstrably exercised.
- **You scanned the slice's diff for what you left behind** — `TODO`, `FIXME`, `stub`, `placeholder`, `mock`, `hardcoded`, `for now`, a skipped or `.only` test, a swallowed error. Each hit is a row or a named waiver. This is the hole the denominator cannot see on its own: a declared function that is missing is a `todo` row, but a stub the implementer *left* was never declared by anyone.
- **Nothing that grades the work moved.** Never edit a check to make it pass — *"It is unacceptable to remove or edit tests because this could lead to missing or buggy functionality"*. A threshold quietly widened at hour six is indistinguishable from success; if a check was wrong, say so in the ledger and fix it as its own decision.
- **One slice, one commit, and the commit moves the ledger.**

**The walk is the one rigid condition, because it is the documented failure.** Anthropic found Claude would make the change, run unit tests, curl the dev server — and still fail to notice that *"the feature didn’t work end-to-end"*. Unit tests, lint and type-check are the verification that was already automated; they are not the question. The question is **can the agent run the thing**, and it is the first thing dropped when nobody is watching.

**When the walk fails, it is a root-cause question, not a retry** (**compound-v:systematic-debugging**). On the third failed close, say which is true: the slice splits, the check was wrong, or stage 1's unknown was real and the shape changed. Mark it `blocked` with which one and move on — three failures is information about the plan, not about your patience.

**Serial by default.** Cognition argued against fanning writers out, then revised it ten months later and kept the line where it matters: what works is *"setups where multiple agents contribute intelligence to a task while writes stay single-threaded."* Fan out reads — recon parallelises well — never slice-writes, and only through **compound-v:dispatching-parallel-agents**.

## Stage 4 — Reckon: the MEP bar over the assembled product

Put the goal beside what exists and say plainly how much is real — including *"we have been busy for six hours and the product is not closer to a user."* The bar is **MEP, the minimum evolvable product**: it survived contact with a real person, and the next change does not require a rewrite. Not MVP — *viable* is a bar an agent clears by writing code that runs, which is the bar that produced the six-hour run with nothing real at the end.

Four checks, each run against the assembled system — **references/mep-gate.md** carries how:
**alignment** (does it still answer the ask the plan already absorbed, and what exists that nobody asked for), **reachability** (walk every capability entry-point → handler → data → what the user sees, twice, once on an input you did not construct, then cold-start it), **survival** (who used it who did not build it, what they tried, what broke, what you changed — on a clean artifact), and **evolvability** (the two most likely next changes, and whether either forces a rewrite).

The **clamp** is there too: a finding blocks only if it names a real user blocked from a capability the goal asked for, or a named next change that forces a rewrite.

### The verdict — one word, then the next action

- **DONE** — every capability the goal named is reachable on the assembled product, the survival bar for this ask was met on a clean artifact, and neither next change forces a rewrite.
- **DONE WITH GAPS** — every goal capability reachable, survival bar met, gaps named and counted in the same breath. It ships; the gaps return at the next finish.
- **UNPROVEN** — built, complete, green, and nobody outside the build has touched it. The remaining work is finding the first user, not more code.
- **NOT_DONE** — the default. Return the remaining work as addable tasks: which capability, which path, what would close it.
- **DRIFTED** — what exists is no longer what was asked for. Route back to the original ask, not to the plan.

A hand-off is not a verdict: "pushed", "PR opened", "ready for review", "agents still running" are all stopping while work is open, and a list of manual steps handed back to the user is unfinished work relabelled. **The next action is the one that closes the biggest gap to MEP, not the most comfortable one** — name the biggest gap, name the comfortable alternative you were about to do instead, and say why you are not doing it. Say all of it in the conversation; the durable residue is one line in the landing commit.

**Discharge before the landing commit.** A row has two halves with opposite half-lives: its `status` is run-scoped and reads `passed` forever the day after the merge — a stale claim the next agent trusts as fact — while its `does` and `evidence` are a regression contract the run already paid to write. So the ledger goes, but never undischarged: every passed row first names a durable target — a command someone can re-run, a production observable and the query that reads it, or a named human and the check they own. `bash scripts/ledger.sh --discharge` refuses the landing until that holds. **An incident opens a row before it opens a fix** (`discovered: true`, the reproduction as its `does`), red-first by construction and re-entering at Carve — not a maintenance lane, because a second-class path is where undeclared work hides.

## Red flags

Nothing here blocks on its own; every row routes back to a stage, and the clamp decides.

| Smell | What it means |
|---|---|
| Recon came back and the plan got *bigger* | You researched how to build it, not whether to. Re-run stage 2 for the DELETE list. |
| A slice with a check like "it looks right" | Not a slice yet. The verifiable criterion is what makes the speed real — the famous fast agent builds all had one; real software only gets one if you write it. **compound-v:frame-the-goal**. |
| The architecture arrived before the second fact | The overestimate failing loud. Two lookups usually collapse the design; do them first. |
| "Basically done, just polish left" | The last mile is most of the remaining work and where the value is. Name what's left; that list is the remaining project. |
| "This laid the foundations" | Nothing a user can do today that they couldn't yesterday. Horizontal work disguised as vertical — the shape slicing exists to prevent. |
| A ledger bit flipped without a walk, or a check edited late in the run | The two failure modes this skill is built around. Confirm the check goes red without the change, and suspect it hardest at the end of a long run. |
| The same gap N rounds running, or a different gap every round | **compound-v:systematic-debugging**'s attempt cap. The product-level addition: if every remaining gap needs something you don't hold — a real user, a credential, a live environment — no round closes any of them. Name the blocker and stop. |
| "Too complex / would take days" | Not authorization to deliver less — only to say so out loud, and to go back to stage 2 and find who already solved it. |
