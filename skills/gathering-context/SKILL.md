---
name: gathering-context
description: Assemble the context an implementer needs BEFORE any code is written — the constraints, how it must not be done, the shape and its trap, what prior art lets you delete, and what "done" means. Use at the start of any non-trivial build: a new function, feature, endpoint, schema, AI capability, or product, and whenever you are about to write against an unfamiliar stack or a surface where being wrong is expensive. Fires before compound-v:writing-plans and before any implementation. Run scripts/alpha.sh to sweep every verified source lane at once. Skip it for a typo, a rename, a config flip, or a change you could describe in one sentence.
---

# Gathering Context

**Do not start typing until you hold the constraints and can see the end from the beginning.**

Not until you have gathered every pattern — that is a different thing and it measures worse. This
skill assembles a **task-scoped pack**, fresh, for the thing you are about to build, and then gets
out of the way.

## The distinction that makes this work rather than cost 20%

A controlled study across multiple LLMs, agents, and both model-generated and developer-committed
context files found the two halves of "give the agent context" point in opposite directions:
**instructions in the context files "are well followed" by agents**, while **repository overviews
"although popular and recommended by model providers, are not helpful"** — and providing the files
raised inference cost by **over 20% on average** without generally improving task success.
Source: Gloaguen, Mündler, Müller, Raychev et al. (ETH Zurich SRI Lab), *"Evaluating AGENTS.md: Are Repository-Level Context Files Helpful for Coding Agents?"* — https://arxiv.org/abs/2602.11988 (arXiv 2602.11988, Feb 2026; quotes checked against the paper, not a search
digest). One study, so treat the mechanism as the durable half and the figure as one measurement.

So the failure mode is not gathering context. It is **baking a standing document into every session**
whether or not it bears on the task. Everything below is assembled *for this task*, used, and
discarded. If a section of your pack would be identical for every task in the repo, it belongs in the
repo's own instruction file — or nowhere.

The second measured qualifier: **a plan is not free.** Across 21,120 agent trajectories, a good plan
improved resolution and *"a subpar plan hurts performance even more than no plan at all"*, with
extra early-stage phases degrading results when they cut against how the model already works. Adding
preparation because it feels safer is a way to lose. Which is why this skill has a stop condition.

## The pack — six slots, and the second one is the heaviest

Fill these, in this order. Each names where it comes from.

**1. Constraints the model cannot infer.** The installed versions (not the declared ranges), the
repo's own conventions, house rules, the build and test commands. `bash scripts/stack.sh [dir]`
resolves the first; the neighbouring files and `AGENTS.md`/`CLAUDE.md` give the rest. **This is the
slot the evidence is unambiguously positive about** — it is also the cheapest. Never skip it.

**2. How it must NOT be done — spend the most EFFORT here, not the most words.** Anti-patterns, the
approaches practitioners tried and abandoned, the failure cases. The asymmetry is about scarcity,
never about inclusion: the right half of a pattern is usually reconstructable and the wrong half is
not, because a negative result is almost never written up as an essay. So a pack that splits its
*time* evenly under-spends on the scarcer side — which is why `references/channels.tsv` and the
practitioner lane exist. **Gathering less of the positive half is not what this says.** A trap with
no shape attached is unusable, and an implementer holding only anti-patterns knows what to avoid and
still faces a blank file.

*(An earlier version of this slot argued the stronger claim — that past successes actively hurt —
on one talk. Verification killed it three ways: the quotation was ASR caption text reproduced
inaccurately, which this kit's own `scripts/yt.sh` forbids twice; the source's scope is an agent
re-reading its OWN prior trajectories, not what prior art a person gathers before building; and its
author disclaims the area on record. It was never in the ledger against this skill. The effort
argument above never depended on it.)*

**3. The candidate shapes, the axis between them, and the trap on the one you would reach for.**
More than one arrangement is usually viable, and naming only the winner hides the trade-off you made
silently. So carry the alternative you did *not* take **and the reason it lost** — three independent
governance processes converge on why, and it is not to justify the decision: it is to stop the
question being reopened. Python's PEP process asks that rejected ideas be recorded with their
reasoning, which *"[prevents] people from bringing up the same rejected idea again in subsequent
discussions"*; AWS's ADR guidance gives the same reason — a rejection reason *"to prevent future
discussions on the same topic"*; and Tyree & Akerman rank the argument beside the decision, so that
*"you don't want to hear the question 'Did you think about…?' during a final review"*. Name the axis
they turn on, not just the verdict — 28% of real ADRs record the outcome and no reason, and those
are the ones that get relitigated. **Enumerating is this slot's whole job; choosing is not** —
**compound-v:brainstorming** owns the pick, and doing it here duplicates it.

The arrangement an experienced team would reach for, paired with the
second-order cost invisible on day one. Check **references/shapes.md** first. A hit is a strong default, **not the end of the slot** —
check its `applies` conditions against your actual case before adopting it, because a cold run of
this skill took the one matching row and would have built the wrong thing with it. On a miss, read a codebase that ships it: `bash scripts/exemplar.sh grep <repo>
<subtree> "<pattern>"` at a pinned release. **A shape with no trap is a policy detached from the
context that produced it**, and it will be misapplied — if you cannot name the trap, say so rather
than inventing one. **And a shape harvested from a corpus is a MEAN, not a merit**: it tells you
what most teams converged on, which is the right default and the wrong ceiling. On work meant to be
better than average, take the shape as the floor to clear rather than the target to hit — the
honest-empty rule in slot 4 protects the DELETE list, and this is its counterpart for slot 3.

**4. What this lets you delete.** The point of prior art is a shorter build, not a longer plan. An
empty answer here is the signal to re-run the search, not to proceed: in practice it means the
question was shaped as *how do I build X* rather than *who already has X*. It can be honestly empty
on novel work — say so explicitly, because silence reads as diligence and isn't.

**4b. The building blocks this codebase already has — each with a working example at `path:line`.** Name the existing components, helpers and
services the work should compose rather than leaving the implementer a blank file. Three independent
organisations converged on this at scale: a system generating every line from scratch produces more
surface than anyone can review, while one assembling from blocks that already exist inherits their
review history. This is the constructive half of slot 4 — prior art tells you what not to build;
this tells you what to build *out of*. *(One of the three flags his own version as still
experimental, so treat the scale claim as unproven and the practice as sound.)*

**5. What "done" means.** The check a person or a command can actually run, written from what would
show the goal UNMET. **compound-v:frame-the-goal** owns this. A pack without it produces a confident
implementation of the wrong thing.

**6. What you still do not know.** Name the open questions and which are one-way doors. An unknown
you can name is a risk; an unknown you cannot is a surprise.

## The shape of a finding — this is the whole of the depth

**Nothing enters the pack as prose.** A context pack is deep because its findings have a *form*,
not because it is long. The named benchmark makes this concrete: `vercel-labs/agent-skills` @
063bee9 ships a 948-word index over 70 rule files totalling 13,606 words — a 7% index — and the
median rule is 177 words of which roughly half is code. Depth lives in the shape, and a finding
that will not fit the shape is not ready to hand over.

````
<prefix>-<slug>                                 impact: Critical | Important | Minor
why:     one or two sentences — the MECHANISM, never the rule restated
applies: <stack>@<version> · <path glob> · the situation — and say where it does NOT hold

**Wrong (<the cost, in ≤8 words>):**
```<lang>
the smallest code that shows it
```
**Right (<the condition, or the win>):**
```<lang>
the smallest code that fixes it
```
from:    <source> @ <pinned ref or version>
````

**The label parenthetical is mandatory and is the load-bearing part.** Measured over the benchmark's
70 rules, 65 of 69 `**Incorrect …**` labels name the defect in the label — `(sequential execution, 3
round trips)`, `(O(n) per check)` — while only 20% carry a cost comment inside the code. A bare
`**Wrong:**` makes the reader infer the failure mode, which is the one thing this shape exists to stop.

**`applies` is the abstain clause, and nothing else in this kit owns it.** A rule with no "does not
hold when" produces confident wrong refactors on the wrong major. Write the version range and the
situation where it stops being true; if you cannot name one, you have a slogan, not a finding.

**`impact` uses the kit's existing closed set** — `Critical | Important | Minor`, the same vocabulary
**compound-v:recheck** and **compound-v:code-review** score with — so a slot-2 finding becomes a review
assertion without translation.

**Where the code comes from, in order:** this repo (`path:line`), the vendor's own API/reference
documentation for the exact version, a pinned exemplar (`scripts/exemplar.sh read|grep`), then the
installed package. Compose it yourself only when none of those has it, and say so in `from:`. *(The
vendor-docs rung is listed second because a cold run of this skill found every Critical "must not"
finding came from the vendor's API docs and nowhere else.)*

**No per-finding `check:` field.** Slot 5 already owns the runnable check for the whole pack, and a
twelve-finding pack does not need thirteen of them.

**How many findings?** Few. Hand over the ones that change what gets built and say which you dropped —
this kit has a REFUTED ledger row against putting a number on it, and the two studies that look like
they set one are counting whole skill modules and topic documents, not findings per decision.

## Assembling it

**The pack is one file, written beside the plan and deleted with it.**

```
Context pack — <the thing being built>
resolved: <stack>@<versions FROM THE LOCKFILE> · repo @ <commit> · <date>
sweep:    alpha.sh "<topic>" — <n> pointers, <n> read. Lanes at (0): <name them>

  1  Constraints      2  Must not (most of the EFFORT)   3  Shapes + the axis
  4  Delete           4  Force — what you must now handle that the plan didn't name
  4b Build out of     5  Done means                      6  Still unknown
```

`resolved:` is the first line because a pack whose versions are not stamped cannot be detected as
stale later — it can only be believed. **No slot is ever silently empty:** write `NONE — <reason>`,
because a blank reads as thoroughness and an absence is a finding. `Force` is the standing companion
to `Delete` from **references/prior-art.md** — what prior art now obliges you to handle that the plan
never named: a rate limit, an auth dance, a pagination shape, an ordering guarantee.

```
bash scripts/preflight.sh                            # once per machine
bash scripts/alpha.sh "<topic>" [tier] [language]    # every task
```

**These paths are relative to the KIT ROOT, not your project.** You are almost never standing in
it: use `${CLAUDE_PLUGIN_ROOT}` where it is set, or take the base directory the harness printed
when it loaded this skill and go up two. A cold run of this skill lost its first attempt to
exactly this, and `No such file or directory` reads like a broken kit rather than a wrong cwd.

**Preflight first, and only once per machine.** The lanes shell out to `gh`, `yt-dlp` and
`curl`; a missing or logged-out tool makes a lane return nothing, which reads as *"there is
nothing to find"*. An empty slot 3 caused by an uninstalled binary is indistinguishable from
a genuinely novel problem, and the two call for opposite responses.

One command sweeps every verified lane — talks, arXiv, exemplar repos, engineering blogs,
practitioners — and returns **pointers, not content**. Breadth is mechanical and therefore free, so
spend agents on *reading* the shortlist rather than on *finding* it. `references/public-sources.md`
maps the lanes; `references/prior-art.md` carries the method and the per-dispatch worker brief.

**Research documents; it does not evaluate.** The strongest public version of this workflow makes it
an explicit prohibition — the research pass may not critique the implementation, propose
enhancements, or recommend refactors. *Documentarians, not evaluators.* A research pass allowed to
evaluate collapses into premature design and returns a plan wearing the costume of findings.

**Carry `path:line`, not prose.** A cited line either exists or it does not; a confidently
hallucinated architecture reads exactly like a real one. Pin the commit or release you read at — that
is what makes the pack detectably stale later rather than silently wrong.

## Four rules that keep prior art from making the work derivative

- **Look for what to REMOVE, not what to ADD.** Studying an exemplar to subtract is safe; studying
  it to accumulate is how you inherit its accidents, including the ones it is still paying for.
- **Look but don't paste.** Reading the old implementation and copying from it are different acts,
  and the second is the default drift — name it before you start, not after.
- **Copy the shape, re-derive the values.** A tuned artifact carries numbers earned against someone
  else's observed failures; taking it verbatim does not transfer its results.
- **A codebase's patterns include its bad ones.** An agent mining a repo will find the wrong way to
  do a thing and follow it, because nothing in the file says which engineer left. So this step ends
  in a reviewed list with explicit REJECTS, never in a summary the agent then obeys.

*(These four carried quoted attributions for their whole life and none was ever registered in
references/sources.md — three strings, zero ledger rows, invisible to gate #8 because it walks
ledger→file and cannot see a quote that was never entered. Almost certainly transcript text, which
this kit forbids quoting. The rules survive their removal intact, which is the usual tell that the
quotation was decoration.)*

**How to tell whether the work is actually novel, rather than well-recalled.** It is a design of
the *check*, not of the work: a biology team established their result was first by choosing
validation targets **whose solution could not be in the corpus**, so any hit was provably novel
rather than retrieved. The transferable form — **if it matters that the output is not derivative,
evaluate it on a task whose answer is not in what you learned from.** Grading against
corpus-derived exemplars cannot distinguish novelty from recall; that is a scope failure in the
instrument, so tightening the gate never reaches it.

**Be honest about how weak the rest of the evidence here is.** The tidy claim — that an agent can
build a v2 from a v1 but cannot originate a v1 — rests on **one source who hedges it on record**.
The opposite is at least as well attested: the two most-cited novel products in the sweep came from
a *felt defect in daily use* and from an *operational constraint someone had already hit*, not from
a blank page. Nobody in the evidence resolves it, so neither does this skill.

**And the expiry test, which nothing else in this kit applies:** would this line still earn its place
on a *stronger* model? A rule that only lifts a weak one is scaffolding for a deficiency being
deleted week by week — mark it with an expiry rather than carrying it as doctrine.

## Stop

Stop when the six slots are filled well enough to start — **not** when the sources are exhausted.
The stop condition is: *you can state the shape and its trap, and you can see the end from the
beginning.* Two independent primary sources converging is enough; a third is restatement.

Budget it by how much you actually don't know. A surface you have shipped before earns slot 1 and
nothing else. A one-way door — a schema, a public name, money, an irreversible write — earns the
full pack. Running the whole apparatus on a familiar CRUD endpoint is this skill over-building on
itself, and the plan study above says that costs you rather than protects you.

Hand the pack forward: the candidate shapes and their axis into **compound-v:brainstorming**, which
is where one gets chosen; the chosen shape and the constraints into **compound-v:writing-plans**;
the anti-patterns into **compound-v:recheck** as named checkable assertions; the check into the
plan's verification step. **Naming brainstorming here is not decoration** — the router sequences
this skill straight into it, but this line used to skip it, so a reader following these instructions
routed a fully-researched pack past the only step that generates alternatives, and the implementer
got a blank file with one shape in it. A pack that stays in the conversation dies with the session.

## The loop this closes

This skill spends the table; **compound-v:finishing** step 2.5 refills it. That is the difference
between an agent that starts every session cold and an engineer whose judgement compounds — the
accumulated traps, held on disk, retrieved per task, never preloaded. It is the same order
**compound-v:systematic-debugging** runs on a bug: gather first, act second, write down what you
learned at the end.

## Red flags

| Smell | What it means |
|---|---|
| The pack would be identical for the next task in this repo | That is a standing document, not task context. Move it to the repo's instruction file or drop it — this is the +20% failure. |
| Slot 2 names only the obvious failure modes | You gathered the polished half. The test is not LENGTH — slot 3 legitimately runs longer, since it carries alternatives — it is whether anything in slot 2 is something you could not have guessed without reading a practitioner who had been burned. If every anti-pattern is one you already knew, you did not go and look. |
| Slot 3 names one shape and no alternative | Then there was no choice to hand forward, and **compound-v:brainstorming** has nothing to choose between. One arrangement being obviously right is a legitimate answer — say so explicitly, rather than leaving the absence to be read as thoroughness. |
| An option is named with no reason it lost | The verdict without the axis. That is the form that gets relitigated by the next session, which is the whole reason the rejected ones are written down. |
| Research came back with recommendations | It evaluated. That is premature design wearing findings' clothes — re-run it as a documentarian. |
| An empty DELETE list, reported as thoroughness | The question was *how do I build X*, not *who already has X*. Re-run it, or say plainly that the work is novel. |
| The plan grew after research | Same defect. Recon that lengthens the build did not answer the question it was asked. |
| A shape with no trap | Half a finding. The trap is the part that transfers; without it you have a policy nobody can apply. |
| Still gathering after the shape and trap are named | Past the stop condition. Restatement is where a lookup turns into a research project. |
