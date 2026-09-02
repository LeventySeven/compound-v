# The listing budget — why a good skill silently stops firing

A skill delivers nothing unless it fires, and whether it fires is decided by a layer *above* the
skill: the always-loaded listing of names and descriptions. That listing has a budget. When it
overflows, the harness does not warn the model — it **drops descriptions, starting with the skills
you invoke least**, leaving a bare name that matches nothing.

So the failure looks exactly like a badly-written description, and it is not. A skill can be perfect
and unreachable. This file is the owner of that failure.

## The constants

From the harness's own documentation (`code.claude.com/docs/en/skills`), current as of 2026-09:

| Constant | Value | Consequence |
|---|---|---|
| Per-entry description cap | **1,536 chars**, `description` + `when_to_use` **combined** | The **tail** is cut. Put the key use case first; trigger phrases parked at the end are the first thing to go. |
| Listing budget | **1% of the model's context window** | Scales with the model. A kit that fits on a large-context model can overflow on a smaller one. |
| Overflow behaviour | **Drops descriptions starting with the skills you invoke least** | A feedback loop: low use → description dropped → cannot match → lower use. |
| Post-compaction re-attachment | First **5,000 tokens** per skill; **25,000 tokens** combined, filled most-recently-invoked first | Anything past ~3,750 words in a `SKILL.md` may not survive compaction. Older skills can be dropped entirely. |

Two settings move these: `skillListingMaxDescChars` (the 1,536 cap) and `skillListingBudgetFraction`
(the 1%), plus `SLASH_COMMAND_TOOL_CHAR_BUDGET` for a fixed character count. `skillOverrides` can set
an entry to `"name-only"` to free budget. `/doctor` estimates the listing's cost and its biggest
contributors; on overflow the harness also writes a warning to the debug log.

## It is not hypothetical — it is happening to this kit

Observed live, 2026-09-01, in a session with this kit plus roughly a hundred other installed skills:

**`compound-v:council` carries a 679-character description in its own file and appeared in the
session listing as a bare name with no description at all**, while every other Compound V skill
carried its full text. `council` is the least-invoked skill in the kit — **1 invocation in 60 days**,
against 223 for `critical-thinking`.

That is the documented behaviour, caught in the act, and it reverses the obvious conclusion. A
usage audit reads `council: 1` as evidence the skill is redundant and should be cut. The real
causation runs the other way: its description was dropped, so it could not match, so it did not fire,
so it stayed first in line to be dropped. **Cutting it would have been treating the symptom.** The
kit's own audit script already warns that a zero is absence of evidence rather than evidence of
death; this is the mechanism behind that warning.

Compound V's own descriptions cost several thousand tokens before a
single other skill is installed. `bash scripts/check.sh` prints this number on every run.

## What to do about it

**Measure before trimming.** This kit spent its whole life enforcing a **1024**-character description
cap that the harness does not use anywhere — a self-inflicted constraint 33% tighter than the real
1,536, paid for in deleted trigger phrases. The gate now reads 1,536 and counts `when_to_use` toward
it. Check the number against the docs before believing any cap, including this one.

**Order every description by trigger value.** The cut is a tail cut, so the first clause must be the
thing a user would actually say. A description that opens with a category label and buries the
trigger phrases is a description that truncates into uselessness.

**Do not fix an overflow by deleting skills.** Deleting the least-invoked skill promotes the next
least-invoked one into the same trap, and you lose a capability to buy budget you could have bought
with `skillOverrides` or a shorter description. The population that gets dropped is a property of the
*budget*, not of the skills.

**Route around the listing where the work is important.** A `SessionStart` hook injects text
unconditionally, outside the listing budget entirely. That is why this kit's router
(**compound-v:using-compound-v**) is hook-injected and why it names every skill and its trigger: a
skill whose description was dropped is still reachable through the router. **The router is the
kit's redundancy against its own delivery layer**, which is the strongest argument for keeping it
exhaustive rather than short.

**Suspect this first when a skill stops firing.** Before rewriting a description that was working,
check whether it is still in the listing at all. The rewrite cannot fix a drop, and a description
edited to chase a phantom trigger failure is strictly worse than the one it replaced.

**Never write the current total into this file.** It was hardcoded once as "30 descriptions,
~14,100 characters" and was wrong within the week the 31st skill landed — a stale number in a
budget document is worse than none, because it gets trusted. `bash scripts/check.sh` prints the
live figure (`always-on description cost:`) every run. Read it there.
