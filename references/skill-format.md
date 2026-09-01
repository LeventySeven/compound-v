# Compound V — Skill Format Constitution

The authoritative spec for writing a Compound V skill. Lean by construction: if a line gives <5%
lift, it does not belong. This file is itself the example — short, dense, every rule earns its place.

## Frontmatter (required)

```yaml
---
name: <kebab-case>            # ^[a-z0-9-]+$, ≤64 chars, matches the directory name
description: <Imperative WHAT it does, one clause>. Use when <concrete triggers / intents / phrasings>, even if <the user doesn't name it>.
---
```

- `name` and `description` are the only required keys. Optional and occasionally worth it:
  `disable-model-invocation` (see below), `license`, `metadata`.
- **`disable-model-invocation: true` — right for a dead end, wrong for a link in a chain.** The flag
  enforces what a prose plea ("opt-in, do not auto-trigger") only asks for, so prefer it *when no
  other skill hands off to this one*. If a skill sits mid-workflow, the flag silently breaks every
  upstream handoff — the model can no longer reach it at all — and the failure is invisible until a
  pipeline stops halfway. For those, keep the prose and put the real protection where it belongs: an
  explicit confirmation gate on each irreversible action inside the skill. Consequence-gating and
  invocation-gating are different jobs; don't substitute one for the other.

### The economics that govern every authoring choice
**The body is pay-per-use; the description is always loaded.** Every description in the session is
resident before any task starts, so that is where the always-on cost lives — and it is a *shared*
budget: the skill listing is capped near 1% of the context window, and when the listing overflows,
**descriptions get shortened**. Three consequences, in order of importance:

1. **Front-load the trigger.** Truncation eats the tail, so the discriminating "use when…" clause goes
   in the first sentence, never after a paragraph of what-it-does. A trigger that gets truncated is a
   skill that stops firing — and it fails silently, indistinguishably from a skill that was never a
   good match.
2. **Cut bodies ruthlessly; spend on descriptions deliberately.** These pull in opposite directions and
   the correct policy is asymmetric. Reliable triggering can genuinely take a paragraph, and cutting a
   description below that threshold is how a skill quietly stops being invoked. So don't shorten a
   description to save space — *re-spend* it: drop any clause describing the workflow (Ruling A) and
   buy more trigger situations with the words you free.
3. **Fewer skills is also a description-budget decision.** Every skill you add shortens every other
   skill's description. A skill that fires rarely is not free.
- **Ruling A — description = WHAT + WHEN, never the workflow.** State what the skill does + when to
  reach for it + searchable keywords. Be slightly *pushy* ("…even if not asked") to fight
  under-triggering. **Never** summarize the steps/flow — a description that encodes the workflow makes
  the model follow the description and skip the body (superpowers' #1 tested failure). Third person.
  ≤1,536 chars — and that cap counts `description` + `when_to_use` COMBINED. (This spec said 1024 for its whole life; the harness uses that number nowhere, so every description was trimmed against a cap 33% tighter than the real one. Verify a cap before enforcing it.)

## Body structure (target ≤250 lines; hard ceiling 500)

```
# Skill Name
One-sentence core principle.

## When to use            ← bullets with concrete symptoms + a "skip it when" line
## <the substance>        ← the actual technique/gates/checklist (the bulk)
## Red flags (optional)   ← two-column table ONLY for discipline skills with real failure modes
```

- **Progressive disclosure.** Keep the body lean; push heavy reference (>100 lines) or reusable code
  into `references/` or `scripts/` and point to it with a one-line "read X when Y". Don't pre-load
  what's only sometimes needed — that is context-engineering applied to the skill itself.
- **One excellent example beats five mediocre ones.** Pick the most relevant language; make it real
  and runnable, not a fill-in-the-blank template.

## The size limit is not only about compaction — a long skill silently sheds its own steps

`scripts/check.sh` warns past ~3,750 words because compaction re-attaches only the first ~5,000
tokens of a skill. That is real, but it is the *second* reason to stay short. The first is worse,
because it happens with a full context window and leaves no trace.

Two practitioners report the same failure independently. A team whose flagship workflow prompt
reached **85 instructions** found it *"silently dropping the deepest ones"* — the agent appeared to
follow the workflow while shedding exactly the constraints that made it reliable; they split it into
stages of **under 40 instructions** each and moved the sequencing out of prose into real control
flow. A second engineer abandoned shipping his harness as a skill for the same reason, and quotes the
agent saying it outright: *"you told me to do that. I decided not to."*

Both are ASR-derived conference-talk quotes, so treat the wording as approximate and the phenomenon
as attested twice rather than measured once. The consequence is not approximate: **a skill that grows
past roughly forty real instructions stops being a procedure and becomes a menu.** It still reads
well. It still fires. It just quietly stops doing the last third, and nothing reports that.

So when a skill is over the line, splitting the *instruction count* matters more than trimming the
prose. Cutting 500 words of rationale off a 90-instruction skill leaves 90 instructions.

**Apply the expiry test to THIS kit, not only to the rules it writes for other people.** The kit
tells others to ask whether a rule would still earn its place on a stronger model; nothing asks it of
Compound V's own lines. It should, because there is now an outside measurement that a written rule
can make output **worse**: a DX engineer measured one of his own skills at **77% correct with it
loaded against 97% without**, and deleting 95% of that generated content (10,000 lines down to 553
lines of gotchas) made his eval both faster and more accurate. He only knew because he was measuring.

That is the honest bar for every line here: not "is this true?" but "does loading this beat not
loading it?" — and nothing in this kit currently answers that question with a number. Treat every
rule as provisional until it has been run both ways.

**And be careful about who does the trimming.** The caution that pairs with the measurement above is
sharper still: letting a model expand a skill *"converts high-level guidance into brittle procedural steps, and the
fact that it understood the high-level version is the proof it did not need them."* Keep the guidance
high-level, keep the gotchas concrete, and prefer deleting to explaining.

**A model upgrade is a silent breaking change, but NOT for the reason it first looks like.** A team's
agent stopped obeying a skill after a model bump with *"not a single line in the skill changed"*, and
the obvious diagnosis — the new model weights the top of the file, so move critical instructions to
the front — **does not survive checking, and the kit briefly carried it.** Zero sources support it.
Anthropic's own long-context guidance says the opposite (*"putting the instructions at the END of the
prompt, as we want Claude's recall of them to be as high as possible"*), a Tencent WeChat AI result
improved instruction-following by moving the instruction *after* the input, and a practitioner source
in this kit's own registry reports the bias runs to **both** peripheries with degradation by
instruction count that is uniform rather than positional.

The phenomenon is real and independently attested — a prompt with 17 MUSTs and 11 ALWAYSes treated as
suggestions after a version step; a 12.8pp compliance gap between two models of one family at
identical config; Anthropic itself retiring its repeat-critical-instructions advice. Only the
diagnosis was wrong. So when a skill silently stops working after an upgrade, check in this order:

1. **How far into the SESSION** the failure happens — within-session attenuation was the largest
   effect anyone measured (~5.6% lower odds of compliance per generated function), and it is a
   session-position effect, not a file-position one.
2. **Whether the instruction is an absolute the newer model now reads as defeasible.**
3. **Whether compaction dropped it.**
4. Then **re-run the eval on the new model** rather than reasoning about what it must now weight.

## Authoring checklist (the rules the kit follows but rarely states)
- **Description = WHAT + WHEN, never the steps** — Ruling A above is the single most load-bearing
  authoring rule; encoding the flow makes the model follow the description and skip the body.
- **Refs one level deep.** A SKILL points to one `references/…` file; that file does not point to a third
  hop the model has to chase. Any reference material over ~100 lines lives outside the SKILL (see
  progressive disclosure) — a long doc in the body burns context on every load whether it's needed
  or not.
- **One default, not a menu.** Give the recommended path; mention an alternative only when the choice
  is real and the trade-off is named. A menu makes the model pick (often wrong); a default makes it act.
- **Consistent terminology.** Pick one term per concept and reuse it verbatim across the SKILL and
  its refs — synonyms read as distinct things and dilute retrieval.
- **Match specificity to fragility.** Rigid step-by-step gates only for documented failure modes
  (verification, design-before-code, root-cause-before-fix); everywhere else give the reasoning and
  trust judgment (Ruling C). Over-specifying a robust step is the same defect as overkill.
- **Default to qualities; script only where the failure is measured.** On a graded eval, listing the
  **qualities the output should have** moved a prompt from **2.32 → 7.86**; replacing those qualities
  with a list of **process steps** scored **7.3 — lower**, and the author reverted. The mechanism is
  that the reasoning path is *already* in a post-trained model's output space and simply does not rank
  first, so prescriptive steps do not add a capability: scaffolding recovers ~73% of a **base** model's
  gap and about **7%** of a post-trained one's, and that number keeps falling. The strongest
  counter-example reconciles rather than overturns — a step-by-step scaffold reporting a ~47-point win
  was measured on a 2024 base-rung model, and the same author now removes scaffolding. **So: describe
  what a good answer looks like; script only a step that names the failure it prevents.** Two
  consequences worth holding: prompting style is per-model rather than per-project, so re-measure
  rather than inherit; and when a sequence of steps collectively underperforms even though each step
  performs well, *the decomposition is the bug* — stop hunting for the weak stage.
- **Match the *form* to the failure, not just the rigidity.** Specificity is one axis; the *shape* of
  the guidance is another, and it's failure-type-specific. A **discipline** failure (the model knows
  the rule but skips it under pressure) wants a prohibition / red-flag row; a **wrong-output-shape**
  failure wants a positive recipe or example; an **omitted-element** failure wants a structural
  `REQUIRED:` slot. Crucially, a prohibition list *backfires* on a shaping problem — in head-to-head
  wording tests the "don't X" arm produced *more* of the unwanted output than a positive-recipe arm,
  and trended worse than no guidance at all; and "don't X unless it matters" only reopens the
  negotiation (superpowers, "writing-skills"). So reach for a table when the model knows-but-skips,
  never to shape an output.
- **Mind validation.** `name`/`description` are the only required keys; any other top-level key fails
  validation. `name` must match `^[a-z0-9-]+$`, ≤64 chars, and equal the directory name.

## Ruling B — tier-routing is the anti-overkill law
Match effort to the task. A trivial change never triggers the full pipeline. The router
(`using-compound-v`) owns the tier table; every workflow skill respects it and routes *down* when
unsure. Overkill is a defect, not a safety margin.

## Ruling C — explain *why*, not all-caps MUSTs
Today's models have good theory-of-mind; a reason generalizes where a rigid rule overfits. Reserve
hard gates for documented failure modes (verification, design-before-code, root-cause-before-fix).
Everywhere else: give the reasoning and trust judgment. All-caps ALWAYS/NEVER is a yellow flag.

## Flowcharts — only when they earn it
Use a small graphviz `dot` flowchart ONLY for a non-obvious decision or a loop where the model might
stop too early. Conventions: `diamond` = question, `box` = verb-action, `octagon` = STOP,
`doublecircle` = entry/exit; label edges yes/no. **Never** put code, reference material, or linear
steps in a flowchart — use lists/tables/code blocks for those.

## Cross-referencing other skills
Refer by name with an explicit marker: `**REQUIRED:** Use compound-v:recheck`. Never use `@path`
links — they force-load the file and burn context before it's needed.

## The no-bullshit / no-overkill bar (apply to every skill before shipping)
- **Target is Opus 4.8.** Write for a model with strong theory-of-mind — do *not* pad for weaker
  ones. No Iron-Law liturgy, no rationalization tables, no all-caps reinforcement walls. And no
  mandatory pressure-test-before-every-edit gate: that ceremony would turn a one-line deepen into a
  multi-day exercise and break the kit's ship-in-hours discipline. Test a *new* skill or a risky
  change; don't gate every word. When you do test a load-bearing wording, do it cheaply: always
  include a **no-guidance control** (if the control doesn't exhibit the failure, there's nothing to
  fix — don't author the guidance), run **5+ reps** per variant (single samples lie), and treat
  **variance as the signal** — five different readings across five reps means the wording isn't
  binding yet.
- Every section answers: would a senior engineer be *worse off* without it? If not, cut it.
- No ceremony, no triple-reinforced rationalization walls, no dated "in session X we…" narratives,
  no motivational filler, no model cost-tiering (we run Opus 4.8).
- Estimate work in hours/days, never weeks/months — and never let a skill imply otherwise.
- Every claim of fact traces to a real source. The grounding map is `references/sources.md` — it
  maps each load-bearing numeric/factual claim to its public primary URL and marks the recipe-knob
  judgment calls that need none. If a number isn't in that map, add a row citing its primary source
  (a real URL) or cut it; if you can't ground it, mark it clearly as a judgment call.
