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

**2. How it must NOT be done — weight this heaviest.** Anti-patterns, the approaches practitioners
tried and abandoned, the failure cases. A practitioner running a retrieval company reports that
giving an agent past **failure** cases improves performance while past **successes** do not reliably
help and can hurt — a polished exemplar invites *"you already gave me the answer, I'll just say that
back."* Treat that as a strong lead rather than settled (one primary, and he sells retrieval), but
notice the asymmetry it implies about EFFORT: the right half of a pattern is usually
reconstructable and the wrong half is not, so a pack that splits its time evenly is
under-spending on the scarcer side. Gather both — a trap with no shape attached is unusable —
but hunt the negative harder. Hunt the negative result hardest; it is almost never written
up as an essay, which is why `references/channels.tsv` and the practitioner lane exist.

**3. The shape, and its trap.** The arrangement an experienced team would reach for, paired with the
second-order cost invisible on day one. Check **references/shapes.md** first — a hit there *is* the
whole of this slot. On a miss, read a codebase that ships it: `bash scripts/exemplar.sh grep <repo>
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

**4b. The building blocks this codebase already has.** Name the existing components, helpers and
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

## Assembling it

```
bash scripts/alpha.sh "<topic>" [tier] [language]
```

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

- **Look for what to REMOVE, not what to ADD.** A founder who threw away his own framework after
  reverse-engineering two shipped agents puts it sharply: *"abstractions freeze assumptions about how
  intelligence should work… your abstractions become constraints."* Studying an exemplar to subtract
  is safe; studying it to accumulate is how you inherit its accidents.
- **Look but don't paste.** A team rebuilding a system ~50 engineers had spent 18 months on could
  read the old code and was forbidden to copy from it, *"because that is the natural tendency."*
- **Copy the shape, re-derive the values.** A tuned artifact carries numbers earned against someone
  else's observed failures; taking it verbatim does not transfer its results.
- **A codebase's patterns include its bad ones.** An agent mining a repo will find the wrong way to
  do a thing and follow it — *"that's some engineer that doesn't work here anymore."* So this step
  ends in a reviewed list with explicit REJECTS, never in a summary the agent then obeys.

**How to tell whether the work is actually novel, rather than well-recalled.** This is the only
mechanism in the evidence that answers it, and it is a design of the *check*, not of the work: a
biology team established their result was first by choosing validation targets **whose solution could
not be in the corpus** — antibody targets with no known binder, so any hit was provably novel rather
than retrieved. The transferable form: **if it matters that the output is not derivative, evaluate it
on a task whose answer is not in what you learned from.** Grading against corpus-derived exemplars
cannot distinguish novelty from recall — that is a scope failure in the instrument, not a strictness
failure, so tightening the gate never reaches it.

**Be honest about how weak the rest of the evidence here is.** The tidy claim — that an agent can
build a v2 by being shown a v1 but cannot originate a v1 — rests on **one source who hedges it on
record** and who concedes you could probably generate the v2 of his own example. Meanwhile the
opposite is at least as well attested: the two most-cited novel products in the sweep came from a
*felt defect in daily use* and from an *operational constraint someone had already hit* — not from a
blank page. And one operator pulls the other way entirely, having killed a six-month project because
the base model was weak in that domain, concluding you should pick a domain the model is already good
at — which is also a recipe for building where everyone else is. Nobody in the evidence resolves
that, so neither does this skill.

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

Hand the pack forward: constraints and shape into **compound-v:writing-plans**, the anti-patterns
into **compound-v:recheck** as named checkable assertions, the check into the plan's verification
step. A pack that stays in the conversation dies with the session.

## The loop this closes

This skill spends the table; **compound-v:finishing** step 2.5 refills it. That is the whole
difference between an agent that starts every session cold and an engineer whose judgement compounds
across projects — the accumulated traps, held on disk, retrieved per task, never preloaded.

Note the shape of the loop, because it is the same one **compound-v:systematic-debugging** runs on a
bug: gather the context first, act second, and write down what you learned at the end. The reason
that skill's four phases are in a fixed order is the reason these six slots are — acting before you
understand produces a fix that moves the symptom, and building before you understand produces a
workaround that has to be paid for later.

## Red flags

| Smell | What it means |
|---|---|
| The pack would be identical for the next task in this repo | That is a standing document, not task context. Move it to the repo's instruction file or drop it — this is the +20% failure. |
| Slot 2 is thinner than slot 3 | You gathered the polished half. Failure cases are the half that measurably helps; go back for what people abandoned. |
| Research came back with recommendations | It evaluated. That is premature design wearing findings' clothes — re-run it as a documentarian. |
| An empty DELETE list, reported as thoroughness | The question was *how do I build X*, not *who already has X*. Re-run it, or say plainly that the work is novel. |
| The plan grew after research | Same defect. Recon that lengthens the build did not answer the question it was asked. |
| A shape with no trap | Half a finding. The trap is the part that transfers; without it you have a policy nobody can apply. |
| Still gathering after the shape and trap are named | Past the stop condition. Restatement is where a lookup turns into a research project. |
