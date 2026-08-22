# The completion ledger — making the last 10% impossible to lose

Operational detail for **compound-v:get-shit-done**. The skill states the four rules; this is how to
run them. Read it when you open a ledger, and again at the final gate.

The failure it exists to prevent is specific, and it is the normal outcome rather than a rare one: a
run ends with most of the declared functionality built, everything that got built working, and nobody
able to name what is missing. Nothing lied. The missing items were simply never anywhere a check
could look at them.

Be precise about what this buys, because the overclaim is easy: the ledger does not make undone work
doable. It withholds the done verdict and forces the remainder to be named and attributed. Whether
the named remainder then gets built or explicitly cut is a judgment you now have to make out loud
instead of one that gets made silently by forgetting.

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
`{"how": "<what you actually ran or drove>"}` — one line a third party could repeat. `steps` is the part people skip and
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
   high-value gate on this page — **including the half of that step people drop: the red has to fail
   for the right reason.** A run that fails because the route does not exist yet is guaranteed and
   tells you nothing about whether the check measures the property. So for the row classes where the
   check binds weakest to the implementation — a latency budget, an authz property, a refactor with
   no behavior change — and for any row guarding behavior that already exists, use the other form:
   break the thing on purpose and confirm the check notices.
2. **An observed end-to-end run, driven the way a user would.** Not the unit test, not `curl`.
   Anthropic's harness work found a frontier model would make the change, run unit tests, hit the dev
   server, and still not notice that *"the feature didn’t work end-to-end"*; the fix was driving it
   *"as a human user would"*.
3. **Evidence recorded** — one line naming what you actually ran or drove, so a third party can
   repeat it. *Not* a commit sha. An earlier version of this rule required one and treated any row
   behind `HEAD` as unverified, which has no fixed point: the commit that records the evidence
   advances `HEAD` past every sha it just wrote, so the whole denominator is stale the instant it is
   written. Decay is still real — a row that passed in slice 3 is routinely broken by slice 9 — and
   it is already caught by the slice-open re-run in the build loop, which drives the previous slices
   before a new one starts. A pass→fail there is a hard stop, not a re-flip.

**Decide which rows a human must flip, explicitly — and select them by irreversibility, not by
taste.** Every other mechanism on this page is an agent checking an agent, which closes some of the
loop and not all of it. But a human gate placed on "does this feel right" makes the reviewer the
bottleneck and buys little; placed on the action boundary — money moving, data deleted, something
sent, a migration run — it is the only thing that works. Mark those rows in the ledger, and give the
person the row's steps to check rather than a request to approve, or you have added a signature and
not a gate. The same axis **compound-v:make-it-stable** already draws.

## R3 — The delta: scope moves, and it must move visibly

Appending a row is **always** legal; flipping one is not. The moment the build discovers a
requirement, it enters at `todo` with `from: "discovered"` — not at the end, when it will be
forgotten or quietly absorbed. Dropping a row requires a reason and a name.

The gate reports the movement, not just the total:

```
declared 41 · discovered +7 · dropped −3 (named) · passed 45 · blocked 0 · todo 0  → 100%
```

A third party can see the denominator moved and why. A run whose denominator only ever shrinks is
one to distrust.

## R4 — Blocked is not success, and not a resting place

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

## The cost, and the grain that fits the run

This machinery is not free, and the honest read of the evidence is that its *content* is endorsed
while its *volume* is indicted. OpenAI's own prompting guidance for its coding harness says to
*"Start with the smallest prompt and tool set that passes your evals. Add an instruction, example, or
tool only when it fixes a measured failure mode"*, and its trim list names *"process instructions for
behavior the model already performs reliably"* — while its keep list retains *"success criteria and
stopping conditions"*, which is exactly what a row is. Practitioners who have benchmarked
spec-driven kits report that many of them make agents measurably worse by over-specifying. So: every
rule on this page should be here because it closes a failure you have actually seen, and a rule you
cannot name a failure for should go.

**The grain scales with the run.** A single-turn task gets no ledger at all — one shipped coding
harness skips its planning tool entirely for *"roughly the easiest 25%"* of tasks and keeps only a
short, deliberately non-persisted checklist for the rest, with one durable objective per thread. The
row ledger is for the other thing: a multi-session build of a product whose scope was declared in
advance and will otherwise be quietly forgotten. If you cannot say which declared function a row
belongs to, you are writing tasks, not rows, and the ledger has started measuring the wrong thing.

## What this does not fix — say so rather than implying otherwise

- **An incomplete spec.** No ledger invents a requirement nobody wrote. It makes the *known*
  denominator honest and visible; it cannot make it complete.
- **A weak check — partly.** R2's fail-against-nothing catches a check that measures zero. It does
  not catch one that measures one narrow path of five. The available counter is an inverted
  diagnostic at the end: **if every row is green and the outcome is still bad, the row set is wrong**
  — and that is the author's failure, not the run's. Do not respond by re-litigating the rows that
  passed; respond by asking what a user did that no row describes.
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
