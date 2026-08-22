---
name: get-shit-done
description: Take a whole project from a stated goal to a real, working thing someone outside the build has used, and hold it to the MEP bar at the end. Use when the ask is a project rather than one feature — "build me X", "make this real", a wish-list, a founder brief, a PRD, an idea that sounds too hard to finish, an overnight or multi-session run — and again when someone asks "is this actually done", "is it real", "did we drift from what I asked for", or "will the next change force a rewrite". Not for a single feature (compound-v:brainstorming) or a one-liner.
---

# Get Shit Done

Most projects that look impossible are a handful of parts, two of which are genuinely unknown. Find those two first, find out how they are already solved, and most of what is left is typing.

That is not optimism. Thorsten Ball built a working code-editing agent in ~300 lines and three tools — *"an LLM, a loop, and enough tokens. The rest … Elbow grease."* — and answered the sceptic directly: *"I bet it's a lot farther than you think."* Overestimating is the default failure, and models are worse at it than people: asked for a hard thing, a model reaches for architecture instead of for the two facts that would collapse it.

This skill is the **project-level spine**: four stages, each handing the actual work to a skill that already owns it.

## When to use

- The ask is a whole product, system, or multi-part build; or a sprawling brief where nobody has yet said what the parts are.
- A long or unattended run is about to start from a goal rather than from a plan.
- A run is about to be called finished because the tests are green, the boxes are checked, or the branch merged. Stage 4 runs standalone for this.
- **Skip it** below Standard tier, for one feature (**compound-v:brainstorming** → **compound-v:writing-plans**), and when the ask names no outcome anyone outside this session consumes. An internal API, a CLI, a job or a library is *in scope* — its user is whoever calls it. A skip is announced where the verdict would have gone, never silent.

## Two units: the slice you build, the row you count

A **slice** is one capability a user can reach end to end — named as the sentence they would say: *"I get a DM on day 7 when a storyboard is late."* Not a layer, not "the database", not "the API". A project is 3–7 slices; more than that and you are listing tasks, fewer than three and it is a feature — route down. **Slices are the build order.**

A **row** is one function inside a slice, at the grain of a thing a person could attempt. **Rows are the denominator** — what completion is counted against. Keeping these apart is the whole point: a project has a handful of slices and can easily have two hundred rows, and the 10% that never lands is invisible at slice grain because a slice with nine of its ten rows done still looks like a slice in progress.

| Stage | What the spine decides | Who does the work |
|---|---|---|
| 1 Carve | the slices, their order, their checks | **compound-v:frame-the-goal** turns a fuzzy check into a real one |
| 2 Recon | how much research each slice earns | **compound-v:searching-patterns** for the pattern + anti-pattern |
| 3 Build | one slice at a time; what closes it | **compound-v:writing-plans** → **compound-v:batched-implementation** → **compound-v:recheck** |
| 4 Reckon | the verdict over the assembled product | **compound-v:finishing** lands the branch first |

Cede rather than re-derive: whether to build at all is **compound-v:startup-taste**, one claim is **compound-v:verification-before-completion**, a pass rate over a probabilistic path is **compound-v:evals**, reaching anyone is **compound-v:founder-distribution**. This skill never reads a diff and never emits a severity-tagged finding list.

## The ledger: what makes 100% enforceable

A long run degrades silently unless its procedure and its state live on disk: sessions are discrete — *"each new session begins with no memory of what came before"* — and *"compaction isn’t sufficient"*, because it *"doesn’t always pass perfectly clear instructions to the next agent"*. A procedure held only in context quietly stops running, and that failure looks exactly like a session that decided to do less.

Anthropic ran the row idea at over 200 rows for a single app, every one marked failing at the outset, and let the coding agent change nothing but the status field.

> **The done rule — every declared row is `passed` or `dropped`-with-attribution. Nothing may remain `todo` or `building` at the verdict, and `blocked` is not success.**

You reach 100% by passing a row or by cutting it out loud with a name on it, never by forgetting it. That is what makes *"we're at about 90%"* unsayable: either the ledger names the other 10% and who dropped each one, or the run is not finished. Four rules hold it up — **references/completion-ledger.md** carries the row shape and the operational detail; read it when you open a ledger and again at the gate.

1. **Denominator.** Rows come from the PRD or brief, the plan, and whatever the build discovers. Cross-check both directions: every requirement maps to a row, every row to a slice. **A requirement with zero rows is scope nobody was assigned** — the largest single source of the missing 10%, because it never looked like it was failing; it never looked like anything.
2. **Flip.** A row goes green only when three things hold: its check was seen **red first** (a check that passes against an empty implementation measures nothing — **compound-v:test-driven-development**'s red step, applied to the ledger), an end-to-end run was driven the way a user would, and the evidence records the commit sha it passed at.
3. **Delta.** Appending is always legal; flipping is not. Discovered work enters at `todo` the moment it is found, and the gate reports the movement — `declared 41 · discovered +7 · dropped −3 · passed 45 · todo 0` — so a third party can see the denominator move and why. A denominator that only ever shrinks is one to distrust.
4. **Blocked is not done.** Three failed attempts makes a row `blocked`, with the blocker named and the attempts recorded; it counts against completion and escalates (**compound-v:systematic-debugging** owns the cap). Give the run a legal way to say *this one did not work* and it stops needing an illegal one — an agent under a keep-going instruction facing an unpassable row has exactly one other move, which is to rationalise a flip.

**The agent may not edit what grades it.** The only legal write is a status flip and its evidence; any other diff to a row, its steps, or a check the ledger leans on voids the completion claim until a person looks. This is not hypothetical: Anthropic's reward-tampering work found models trained on progressively gameable environments generalize to *directly rewriting their own reward function*. A grader inside the agent's own write scope is not a grader.

The run holds exactly two files, both run scaffolding, both deleted when it ends:

- **`.claude/STATE.md`** — prose, owned by **compound-v:handoff**: the verbatim ask, Next, Do-not, Open decisions. Its **Next** names a row id and nothing more.
- **`.claude/slices.json`** — the slices and their rows. It is JSON deliberately. Anthropic reached the same choice for their equivalent artifact after finding the model *"less likely to inappropriately change or overwrite JSON files compared to Markdown files"*, and a status bit is precisely what a long run rewrites in its own favour.

**Attended runs get three interrupts and no more**: after Carve+Recon (the slices, the rows, the DELETE list), one line per landed slice, and the verdict. **Unattended runs get zero** — per **compound-v:using-compound-v**, take the reversible default, write it down, keep going.

The one unscheduled interrupt, in either mode, is a **one-way door the recon did not resolve** — a schema, a public API, a spend, an irreversible write, or a discovery that changes what the project is. Stop there and ask, even overnight; a wrong answer to one of those costs more than the wait.

## Stage 1 — Carve

**If nobody has yet asked whether this should exist, that gate runs before the carve, not after it** — **compound-v:startup-taste**. Carving a project is a commitment to build it, and this skill is decisive enough at the routing layer to crowd out the question if you don't ask it deliberately.

Quote the **original ask verbatim** into `STATE.md` before anything else. Not the plan and not the spec — both get written mid-run and absorb the drift, so alignment to them proves nothing.

Stage 1's output is `slices.json`, and it exists before any code. Per slice, four things and no more:

- **Capability** — the user's sentence.
- **Check** — what run command, or what one named human, says this slice works. Vague here is fatal; hand it to **compound-v:frame-the-goal**.
- **Unknown** — the one line naming what might not work.
- **Confidence** — Steinhardt's buckets, which are coarse on purpose: *"I am confident that this can be done and that there are no unforeseen difficulties"* (~95%), *"modulo Murphy's law"* (~90%), *"I see the basic path … and all the steps seem like they should work"* (~65%), *"I have the intuition that this should be possible but only have a murky view of the path"* (~30%).

**Then fill each slice with its rows** — every function the goal declares, harvested from the brief and the plan, each with its numbered steps, all starting failing. This is the stage that decides whether the run can ever reach 100%, because a function that is not a row here is one no later check can miss. The file keeps growing after this: rows discovered during the build are appended the moment they are found, never at the end.

**Order by what fails fastest, not by what is easiest.** The tempting order is easiest-first, and Steinhardt names exactly what it costs: *"I would do all the easy parts, then get to the hard part and encounter a fundamental obstacle that required scrapping the entire plan … The work on the easy parts was mostly wasted."* Sort instead by information per unit time — a quick slice you have never done outranks a long slice you have done many times, because it either fails early and cheap or removes the risk from everything downstream. His summary of the whole discipline is the rule here: **de-risk all components, then execute.**

**Slice 1 is the burning function, end to end, with the hard parts faked.** Steinhardt calls this a ceiling: substitute a cheating version of the difficult component and wire the whole path anyway — *"If the system works, we know that a sufficiently good implementation of the difficult component will yield a working system. If the system doesn't work, we've saved the time of implementing the difficult component."* The pair to it is a baseline, the dumb off-the-shelf version, because *"complicated methods often underperform simple baselines"* — and a baseline that already clears the check deletes the slice outright.

**Then say what the ask named that is not a slice, and who asked for it.** Anything with no answer is drift-in before a line is written. This is where a sprawling brief gets honest: *an AI that runs the whole agency* is not a project. It is four named parts — the context store, the metrics, the follow-ups, the proactive nudges — and the one that would actually change someone's week is a job that reads a date and sends a message.

## Stage 2 — Recon: research that is allowed to delete slices

**The confidence column is the research budget** — stage 1's sort, reused. A ~95% slice gets no recon; looking up what you would write correctly from memory is the overhead **compound-v:searching-patterns** already tells you to skip. A ~30% slice gets the full pass.

Recon returns exactly two lists per slice, and the first one is the point:

- **DELETE** — what you now do not have to build, because someone shipped it, a library covers it, the platform already does it, or the hard version turns out to be unnecessary.
- **FORCE** — what you now must handle that the plan did not name: a rate limit, an auth requirement, a data shape, a known trap.

**An empty DELETE list is a red flag, not a clean bill.** It almost always means you searched for *how to build it* rather than *whether to* — and it is how a plan comes back from research bigger than it went in. It can be legitimately empty on genuinely novel work; say so explicitly rather than letting the silence pass as diligence.

Three channels, cheapest first, stopping the moment the slice's unknown resolves: **what is already on disk** (the installed library, the vendored source, a neighbouring repo — version-exact, no network), **primary web sources** at your lockfile's version, then **practitioners in public, X included**, where frontier technique shows up months before documentation and where the noise is worst. How to search each, what to keep, and how the retrieval fails is **references/prior-art.md** — read it when a slice's unknown is real and unresolved.

Where a reference corpus of primary sources exists — essays, product write-ups, talk transcripts on disk — it is channel 1 and it outranks a web search, because a burst of `grep -n` over it is current by construction. If the environment ships a corpus-investigation skill (`workflow-investigation` is one), invoke it rather than re-deriving where things live; it owns the paths and the read discipline, and this stage owns only the budget and the output.

**Recon returns a file:line map, not prose.** Name the exact file and line for each claim — the installed library's signature, the neighbouring repo's handler, the doc section. Prose is unfalsifiable and a confidently hallucinated architecture reads exactly like a real one; a cited line either exists or it does not, so the map is grep-checkable by someone who was not there. A recon output nobody can spot-check has not happened.

Feed the result forward the way **compound-v:searching-patterns** already prescribes — the canonical pattern into the plan, the anti-pattern into **compound-v:recheck** as a named checkable assertion — and write DELETE/FORCE into the ledger, because a deletion nobody recorded gets rebuilt by the next session.

## Stage 3 — Build one slice at a time

The failure this shape prevents is measured. Anthropic ran a frontier model in a loop across many context windows from a high-level prompt: it *"tended to try to do too much at once"* — *"essentially to attempt to one-shot the app"* — and later *"a later agent instance would look around, see that progress had been made, and declare the job done."* Their fix is the one adopted here: work **one feature at a time** — *"This incremental approach turned out to be critical"* — against a checkable list the agent may not rewrite.

**The order is a chain of artifacts, not a recommendation.** Each step is unlocked by the previous step's output existing, and that is the only form of sequencing that has ever been observed to hold: the one hard enforcement of look-before-you-build in practice is plan mode, where the ordering holds because the write tools are not granted yet — not because a sentence asked. Use it. Everywhere else, the artifact is the gate: **no file:line map → no plan; no plan → no code; no red-first check → no row may go green.** A step whose artifact is missing has not run, whatever the transcript says.

Per slice, in order:

1. **Run what already exists first.** Start the thing, do one primary action, confirm the previous slice still works. Anthropic's finding on skipping this: if the agent starts implementing instead, *"it would likely make the problem worse."*
2. **Plan and build it** — **compound-v:writing-plans**, then **compound-v:batched-implementation**, then **compound-v:recheck** over the diff. The spine adds nothing to those three; do not re-derive them here.
3. **Declare the hit band before you build, not after.** What fraction of real inputs does this slice handle, and what do the misses see? *"It breaks"* is not an answer; *"it says X and routes to a human"* is. Build to the middle and give the tail a named exit — an exit is a feature, chasing the tail is the defect. Exception, on the axis **compound-v:make-it-stable** draws: irreversible writes, money movement, data loss, silent corruption or a stranger-facing surface get the full production bar on the bad path too.
4. **Walk it as a user, on the assembled product.** Then, and only then, flip the ledger bit to `passed`.

**When the walk fails, it is a root-cause question, not a retry.** Hand it to **compound-v:systematic-debugging** and respect its attempt cap; on the third failed close, stop trying to pass the check and ask which of three things is true — the slice is bigger than one slice and splits, the check was wrong and needs re-framing in the open, or the unknown from stage 1 turned out to be real and the project's shape changed. Mark it `blocked` with which one, and move to the next slice rather than burning the night on it. A slice that fails its check three times is information about the plan, not about your patience.

**Step 4 is the one place this skill is rigid, because it is the documented failure.** Anthropic found Claude would make the change, run unit tests, curl the dev server — and still fail to notice that *"the feature didn’t work end-to-end"*; the fix was driving it *"as a human user would"*. Read the general form off that result: unit tests, lint and type-check are the verification that was already automated, and they are not the question. The question is **can the agent run the thing** — which usually takes real thought per project to answer, and which is the first thing dropped when nobody is watching.

Two rules that make the bit mean something:

- **Never edit a check to make it pass.** Anthropic's harness carries a deliberately blunt instruction for this — *"It is unacceptable to remove or edit tests because this could lead to missing or buggy functionality"* — because a threshold quietly widened at hour six is indistinguishable from success. If a check was wrong, say it was wrong, in the ledger, and fix it as its own decision.
- **One slice, one commit, and the commit moves the ledger.** **compound-v:handoff** owns the prose state file; this is the same discipline at slice granularity.

**Serial by default.** Cognition argued against fanning writers out, then revised it ten months later and kept the line where it matters: what works is *"setups where multiple agents contribute intelligence to a task while writes stay single-threaded."* Slices share a codebase and a house style, so parallel writers reconcile conflicting implicit decisions at merge time. Fan out reads — recon parallelises well — never slice-writes, and only through **compound-v:dispatching-parallel-agents**.

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

## Red flags

Nothing here blocks on its own; every row routes back to a stage, and the clamp decides.

| Smell | What it means |
|---|---|
| Recon came back and the plan got *bigger* | You researched how to build it, not whether to. Re-run stage 2 for the DELETE list. |
| A slice with a check like "it looks right" | Not a slice yet. The verifiable criterion is what makes the speed real — the famous fast agent builds all had one; real software only gets one if you write it. **compound-v:frame-the-goal**. |
| The architecture arrived before the second fact | The overestimate failing loud. Two lookups usually collapse the design; do them first. |
| "Basically done, just polish left" | The last mile is most of the remaining work and where the value is. Name what's left; that list is the remaining project. |
| v1 · simplified · static for now · hardcoded · placeholder · wired later | Scope reduction. Re-run stage 3 step 4 on that capability. Grep the work *and your own report* — the report is where they hide. |
| "This laid the foundations" | Nothing a user can do today that they couldn't yesterday. Horizontal work disguised as vertical — the shape slicing exists to prevent. |
| A ledger bit flipped without a walk, or a check edited late in the run | The two failure modes this skill is built around. Confirm the check goes red without the change, and suspect it hardest at the end of a long run. |
| The same gap N rounds running, or a different gap every round | **compound-v:systematic-debugging**'s attempt cap. The product-level addition: if every remaining gap needs something you don't hold — a real user, a credential, a live environment — no round closes any of them. Name the blocker and stop. |
| "Too complex / would take days" | Not authorization to deliver less — only to say so out loud, and to go back to stage 2 and find who already solved it. |
