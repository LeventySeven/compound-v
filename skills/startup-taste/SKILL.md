---
name: startup-taste
description: Pressure-tests what you're about to build for moat, scope, and bullshit before any code is written. Use when scoping a feature, deciding "should we build X", estimating timelines, writing a roadmap or pitch, choosing a moat, or whenever a plan smells like overkill — even if nobody asked for a sanity check.
---

# Startup Taste

Code is commodity. The only things that compound are **taste, distribution, and a primitive nobody else has.** Everything else is either in service of those three, or it's the bullshit — and your job is to catch it before it ships.

Building stopped being the long pole around 2026: a product that took a quarter in 2021 takes a weekend now. So the scarce inputs are *what* to build and *getting people to care* — not the typing. The gates below all defend that shift.

## When to use
- Scoping anything, estimating timelines, or writing a roadmap / PRD / pitch.
- Someone asks "should we build X?", "is this a moat?", "what's our edge?"
- A plan smells like overkill: new framework, new abstraction, infra-first milestone, "make it configurable."
- **Skip it for:** pure execution of an already-scoped task (that's `writing-plans` → `batched-implementation`). This skill decides *whether and what*, not *how*.

## The master gate
**Does this grow taste, distribution, or a primitive?** None of the three → it's the bullshit; cut it or say why it's exempt. Run this first; most bad scope dies here.

## The gates (run the relevant ones, name what you find)

**Estimate hygiene — hours/days for building, never weeks/months.**
If the bottleneck you name is "writing the code," re-estimate in hours, or move the time onto a *decision* or a *distribution* problem — that's where the real long pole now lives. Flag the strings *"this will take weeks/months"*, *"multi-week"*, *"several months"* when applied to construction. (A roadmap that budgets months of building is optimizing the part that got cheap.)

**Every scope names a cut.**
Subtraction is a first-class move — every feature costs you forever (Jobs cut Apple 350 products → 10; Granola cut half its features to expose the core interaction). A proposal that only *adds* (flags, endpoints, config, integrations) with zero removals is a feature factory, not a product call. Ask: "what did this remove?" If nothing, that's the finding.

**No premature machinery.**
Don't install the manager-mode apparatus — abstractions, microservices, config systems, a plugin framework — before the *third* copy-paste forces it. On a small/solo team this is pure cost. "Make it configurable" as a reflex is flexibility theater: pick the opinionated default, remove the option.

**Wrapper test.**
Mentally swap the underlying model for the next release. Product basically unchanged, or the upgrade *kills* it → you built a wrapper (a feature), not a company. The upgrade should *help* you. The real bar: does this have architectural dependencies a well-funded competitor needs months to rebuild? (Reality check: strong products hit 60–85% DAU/MAU; the average AI app sat near 14% — wrapper-class retention.)

**Primitive in one sentence.**
You have a primitive only when you can state it in one sentence — "the search result, from links to a cited answer"; "speculative editing"; "the sync engine." Can't? You have a roadmap, not a primitive — stop and find it. The product is the *consequence* of the primitive (Figma built a WebGL renderer + multiplayer protocol for ~4 years; the design tool was then inevitable). "Existing workflow + LLM call" with no named core = a faster horse with a chat box.

**Feature vs Product vs Company.**
Classify it. A feature does one thing and is cloned by next Tuesday (ships in days); a product solves a complete workflow (months); only a company compounds (data flywheel, distribution, lock-in). If it's a feature, name the company-level moat behind it — no moat → "wedge at best," say so.

**Revenue, not cost.**
Sell AI that grows the customer's revenue (no ceiling), not AI that cuts their cost (ceiling = the headcount you displaced, then you're done). Rewrite any pitch that leads with *"save time" / "cut costs" / "X% more efficient"* to lead with the outcome — leads found, deals closed, pipeline generated.

**Own the layer that sets your quality ceiling.**
Delete every third-party dependency on paper. If the core value dies, that dependency controls how good you're *allowed* to be — it's the layer you must eventually own. (Perplexity outgrew the Bing API and built its own index → 1.4% URL overlap with competitors on identical queries; Cursor forked VS Code because the extension API made speculative edit impossible.) Label each external API "ceiling-setting" vs "commodity/swappable."

**De-risk the load-bearing assumption first.**
Order work by information gained ÷ time. Which single assumption, if false, makes the whole plan worthless? Test *that* first, with the cheapest experiment that resolves it. A plan whose first milestone is infra/scaffolding is fun-part-first — you're building on an untested belief. ("A month of fixed setup before the first result" is the classic red flag.)

**Verifier-first for AI.**
Before building an AI feature, name the verifiable signal / eval. No auto-check → you can't drive quality, and *no eval system is the #1 cause of failed AI products.* Build the verifier before the feature; "we'll eyeball quality" is the failure mode, not a plan. (Quality + verifiability beat quantity: 4,000 good verifiable examples beat 4M low-quality ones.)

**Harness before model.**
When an AI system underperforms, the fix is almost never a bigger model — it's context, tools, error recovery. Same model, different harness = real swings (v0 took one model from ~65% → ~94% error-free via four engineering layers, no model upgrade). Challenge *"upgrade to a bigger model" / "wait for the next model"*: have you exhausted context, tool design, and the verify-retry loop first?

## Refusal templates (use the shape, fill the specifics)
- **Bullshit / over-scope:** "This grows none of taste, distribution, or the primitive — and it only adds. Cutting it (or tell me which of the three it serves)."
- **Wrapper:** "Swap the model for the next release and this is unchanged / dies. That's a feature, not a moat. The company-level lock-in behind it would be ___ — do we have it?"
- **Weeks/months for code:** "Building isn't the long pole anymore. The hard part here is the *decision* about ___ — let's spend the time there and ship the build in hours/days."
- **No eval:** "There's no verifiable signal yet, so we can't drive quality. Let's define the eval before writing the feature."

## What this skill is NOT
It is not a fan. A response that flatters every claim *is* the bullshit it's trying to remove. Name the violated property; offer the rewrite; assume a high-agency operator who already ships, so cut hand-holding, not rigor.
