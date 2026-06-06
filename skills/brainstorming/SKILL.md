---
name: brainstorming
description: Turns a vague feature/component/behavior idea into an approved, written design before any code is written. Use when scoping or starting any non-trivial build — "let's add X", "build a Y", "I want it to do Z", a feature request, or a behavior change — even when the user jumps straight to implementation.
---

# Brainstorming

Pin down what you're building and why, and get it approved, before you touch code. The expensive mistakes are decided here, not in the editor.

## When to use

- A feature, component, subsystem, or behavior change where more than one reasonable design exists.
- The request is bigger than one obvious function — there are choices to make about shape, data flow, or boundaries.
- You caught yourself about to scaffold a project from a one-line ask.

**Skip it when** the change is trivial or small per the `using-compound-v` tier table — a typo, a rename, a config flip, or one function with a clear spec. Forcing a design phase onto a one-liner is exactly the overkill this kit refuses. For those, just make the change and verify. When unsure which tier, route down, but if you find yourself inventing the design as you code, stop and come back here.

## The gate

For a Standard-or-larger build, do not write code, scaffold, or invoke an implementation skill until you have presented a design and the user has approved it.

The reason is leverage: a wrong assumption caught in conversation costs a sentence; the same assumption caught after implementation costs the whole branch. "This is too simple to need a design" is the trap — the simple-looking builds are where unexamined assumptions do the most damage, because nobody slowed down. A design can be three sentences for a small feature; it still gets presented and approved.

This is a real gate, not a suggestion, because skipping it is the single most common way agents waste a session building the wrong thing.

## The flow

1. **Read the context first.** Look at the existing code, docs, and recent commits before asking anything. Half your questions answer themselves, and your proposals will fit what's already there instead of fighting it.

2. **Check scope before you refine.** If the request is actually several independent subsystems ("a platform with chat, billing, file storage, and analytics"), say so now — don't burn questions refining a thing that needs to be split. Decompose it into sub-projects, name how they relate and what order they build in, then brainstorm the first one through this flow. Each sub-project gets its own design → plan → build cycle.

3. **Ask one question at a time.** One question per message — multiple-choice when you can, open-ended when you must. Batched questions get shallow answers and let contradictions slip through. Drive toward the three things that actually determine the design: the purpose (what does success look like?), the constraints (what can't change?), and the boundaries (what's explicitly out of scope?).

4. **Propose 2-3 approaches with a recommendation.** Never present one option as if it were the only one — that hides the tradeoff you're silently making. Lead with the one you'd pick and say why, then give the real alternatives and what each costs. The user's pick (or pushback) is signal you can't get any other way.

5. **Present the design in sections, approved as you go.** Scale each section to its weight — a sentence for the obvious parts, a paragraph for the nuanced ones. Cover the architecture, the components and their boundaries, the data flow, error handling, and how it gets tested. Confirm each section before the next so a wrong turn gets caught at the turn, not at the end.

6. **Write the design down, then self-review it.** Save the approved design to `docs/specs/YYYY-MM-DD-<topic>.md` (the user's location preference wins). Then read it back with fresh eyes for the four things below and fix them inline. The written spec is the input to `compound-v:writing-plans` next — its quality caps the quality of everything downstream.

A committed spec file is the default for anything you'll build over more than a sitting; for a small in-session feature, an approved design in the conversation is enough. Don't manufacture ceremony the task doesn't need.

## Design self-review

After writing the spec, check it for the failures that quietly become bugs later:

- **Placeholders** — any "TBD", "TODO", or vague requirement. Resolve it now; a gap here is a guess downstream.
- **Internal contradiction** — does the architecture actually match the feature descriptions? Do two sections disagree?
- **Scope** — is this one coherent implementation, or did it quietly grow into something that needs splitting?
- **Ambiguity** — could a requirement be read two ways? Pick one and write it explicitly. An agent reading it later will pick the other one.

Fix inline and move on — no re-review loop.

## Principles that shape good questions

- **YAGNI, ruthlessly.** Every feature in the design costs forever. Cut anything not serving the named purpose; the strongest designs name what they leave out, not just what they include.
- **Design for boundaries.** Break the system into units with one clear job each, talking through well-defined interfaces. The test: can someone use a unit without reading its internals, and can you change the internals without breaking callers? If not, the boundaries need work — and focused units are easier for an agent to implement reliably.
- **In existing code, follow existing patterns.** Explore the structure before proposing changes. Fix problems that genuinely block the work (a file grown unwieldy on the path you're touching); don't bolt on unrelated refactors.
- **Be flexible.** If an answer reveals you misunderstood, go back. The flow is a spine, not a script.

## Next step

The only thing you do after an approved design is invoke `compound-v:writing-plans` to turn it into an implementation plan. Not a frontend skill, not a scaffolder — the plan comes next.
