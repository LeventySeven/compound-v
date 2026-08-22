# The completion ledger — how a run reaches 100% instead of 90%

Operational detail for **compound-v:get-shit-done**. The skill states the four rules; this is how to
run them. Read it when you open a ledger, and again at the final gate.

The failure it exists to prevent is specific and it is the normal outcome, not a rare one: a run ends
with most of the declared functionality built, everything that got built working, and nobody able to
name what is missing. Nothing lied. The missing items were simply never anywhere that a check could
look at them.

## The done rule

> **Every declared row is `passed` or `dropped`-with-attribution. Nothing may remain `todo` or
> `building` at the verdict, and `blocked` is not success.**

You reach 100% by passing a row or by cutting it out loud with a name attached — never by forgetting
it. This is what makes "we're at 90%" unsayable: the ledger either names the other 10% and who
dropped each one, or the run is not finished.

## The row

Nest rows under their slice in `.claude/slices.json`. A row is one thing a user can do, phrased so a
person could attempt it — not "auth works" but "a signed-out visitor who submits a valid login lands
on the dashboard".

```json
{"id": "s2-f07",
 "does": "a signed-out visitor who submits a valid login lands on the dashboard",
 "steps": ["open /login signed out", "enter a valid credential", "submit",
           "confirm the dashboard renders with that user's name"],
 "from": "prd",
 "status": "todo",
 "evidence": null}
```

`from` is `prd` · `plan` · `discovered` · `user`. `evidence` on a passed row is
`{"sha": "<commit>", "how": "<what you actually ran or drove>"}`. `steps` is the part people skip and
it is the part that works — a numbered walk is checkable by someone who was not there, and a row
without one degrades into a vibe within two sessions.

## R1 — The denominator: rows come from three places, and the third is where the 10% hides

Write every row before any code. Harvest from the PRD or brief, then the plan, then — continuously —
whatever the build discovers. A requirement with no row is invisible to every downstream check, and
the gate cannot miss what it cannot see.

**Cross-check the two directions.** Every requirement must map to at least one row, and every row to
at least one slice. A requirement with zero rows is scope nobody was assigned — the single largest
source of the missing 10%, because it never looked like it was failing; it never looked like
anything. GitHub's spec-kit builds the same cross-check into its `analyze` step and treats an
unmapped requirement as blocking. Do the same.

## R2 — The flip: what it costs to turn a row green

Three conditions, all of them:

1. **The check failed against nothing first.** Before the implementation exists, run the row's steps
   and confirm they fail. A check that passes against an empty implementation measures zero, and a
   ledger full of those is precisely 90% wearing a checkmark. This is
   **compound-v:test-driven-development**'s red step applied to the ledger, and it is the cheapest
   high-value gate on this page. Where a row guards existing behavior and
   there is no "before", get the same signal by breaking the thing on purpose and confirming the
   check notices.
2. **An observed end-to-end run, driven the way a user would.** Not the unit test, not `curl`.
   Anthropic's harness work found a frontier model would make the change, run unit tests, hit the dev
   server, and still not notice that *"the feature didn’t work end-to-end"*; the fix was driving it
   *"as a human user would"*.
3. **Evidence recorded, with the commit sha.** A row is green *as of a commit*. A passing row whose
   sha is behind `HEAD` is unverified at the gate — because a row that passed in slice 3 is routinely
   broken by slice 9, and "all rows green" assembled from evidence gathered at nine different commits
   is a claim about the past. A pass→fail transition is a hard stop, not a re-flip. *(The staleness
   rule is this kit's own; it is the one mechanism here nothing in the surveyed corpus states.)*

**Decide which rows a human must flip, explicitly.** Every other mechanism on this page is an agent
checking an agent, which closes some of the loop and not all of it. Taste, tone, "is this actually
usable" and anything irreversible are rows where the only real bar is a named person — say so in the
row rather than inheriting a fully automated gate by default.

## R3 — The delta: scope moves, and it must move visibly

Appending a row is **always** legal; flipping one is not. The moment the build discovers a
requirement, it enters at `todo` with `from: "discovered"` — not at the end, when it will be
forgotten or quietly absorbed. Dropping a row requires a reason and a name.

**The agent that files a row may not be the one that closes it.** Filing and grading are different
jobs and collapsing them is how a generated checklist becomes self-certifying.

The gate reports the movement, not just the total:

```
declared 41 · discovered +7 · dropped −3 (named) · passed 45 · blocked 0 · todo 0  → 100%
```

A third party can see the denominator moved and why. A run whose denominator only ever shrinks is
one to distrust.

## R4 — Blocked is a terminal state that is not success

A row that has failed its check three times becomes
`blocked` with the attempt count, the named blocker, and the evidence per attempt. Hand the diagnosis
to **compound-v:systematic-debugging**, whose attempt cap this shares, and escalate — to the human
when there is one, into the verdict when there is not.

This rule is not bookkeeping. A two-state ledger makes a genuinely impossible row look exactly like
an untouched one, so triage is impossible; and an agent facing an unpassable row under a keep-going
instruction has one move left, which is to rationalise a flip. Give the run a legal way to say *this
one did not work and here is why* and it stops needing an illegal one.

## Integrity — the agent must not be able to edit what grades it

**The only legal write to the ledger is a status flip plus its evidence.** Any other diff to a row,
its steps, or a check the ledger depends on voids the run's completion claim until a human reviews
it. Treat a check-file change in the same diff as its implementation the way you would treat a test
weakened to go green.

This is not hypothetical caution. Anthropic's own reward-tampering work found that models trained on
progressively gameable environments generalize to *directly rewriting their own reward function* —
so a grader living inside the agent's own write scope is not a grader. Where it matters, keep the
authoritative check outside the working tree and apply it after the run — the same reason a graded
coding benchmark does not ship its tests inside the workspace it hands the model.

**Compute coverage; never assert it.** The completion fraction should come from a command anyone can
re-run against the ledger, exiting non-zero while any row is `todo`, `building` or `blocked`. A
number a person can recompute is a measurement; a number in a summary is a claim.

## What this does not fix — say so rather than implying otherwise

- **An incomplete spec.** No ledger invents a requirement nobody wrote. It makes the *known*
  denominator honest and visible; it cannot make it complete.
- **A weak check.** R2's fail-against-nothing catches a check that measures zero. It does not catch
  a check that measures one narrow path of five.
- **Portfolio judgment.** In research, stopping at 90% of a mediocre line of work is often correct —
  impact is distributed such that the last tenth of a weak project loses to the first tenth of a
  strong one. That reasoning is sound where scope is a hypothesis and wrong where scope is a
  commitment. A PRD is a commitment. Abandonment is still legal here, but only as an explicit
  `dropped` row with a name on it — never as a fade.

## Red flags

| Smell | What it means |
|---|---|
| The ledger has slices but no rows | The denominator is 5 when it should be 200. Nothing at slice grain can find a missing function. |
| A row went green and its check was never seen red | It may measure nothing. Run it against the unimplemented state, or break the thing and confirm it notices. |
| Rows only ever get deleted, never appended | Scope discovered mid-run is being absorbed silently. Every build discovers something. |
| A row reads "auth works" | Not a row. No numbered steps means nobody but the author can check it. |
| The completion number appears in prose but no command prints it | Asserted, not computed. Anyone re-running it should get the same number. |
| The same diff touches a row's steps and its implementation | The grader moved. Freeze the steps or get a human to review the change. |
| Everything is `passed`, nothing was ever `blocked` | On a real build, suspect the flip rule rather than celebrating. |
