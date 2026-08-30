# The MEP gate — stage 4 of compound-v:get-shit-done in full

The detail behind the final reckoning. The skill carries the bar, the four checks by name, and the
verdict words; this is how to run each check. Read it when you reach the gate.

The bar is **MEP, the minimum evolvable product**: it survived contact with a real person, and the
next change does not require a rewrite. The ledger (**references/completion-ledger.md**) tells you
whether everything declared got built. This tells you whether what got built is real.

## The four checks

**Alignment.** Diff today's acceptance criteria against their first draft: a criterion weakened or deleted mid-run fails the work by itself, because that edit *is* the drift, recorded. Judge each goal requirement directly, not the plan's rendering of it — a different route to the same goal is not a defect, and a fully checked-off plan with one unmet requirement is not done. Drift runs both ways, so also name what exists that the ask never asked for, and who asked for it.

**Reachability.** Per capability, walk entry point → handler → data → what the user sees, and mark **reachable / partial / not reachable**. Most stubs are wired-looking files that nothing calls, so name what each piece must be *connected* to and check that link. Trace each user-visible value back to a real source — a chain ending in a literal, a mock or a static fallback is not data flowing. Walk the burning function twice: happy path, then **one input you did not construct**. Then cold-start it — kill the process, clear ephemeral state, boot from scratch, do one primary action — and run it where a user would reach it, with the last working version still up. On a nondeterministic path one green request is not a pass rate; the measuring belongs to **compound-v:evals**.

**The walk runs as *you*, so it cannot see a gate you already satisfy.** Cold-start varies the state and an unfamiliar input varies the data; neither varies the **principal**. A capability can be deployed, working, and liked by everyone who reaches it while almost nobody can — held out by something that is neither code nor on your board: a flag defaulted off, a plan tier or entitlement, an unaccepted consent or terms gate, an allowlist, a region, a key provisioned only for dev. So per capability, name the precondition a stranger must already satisfy and who it excludes. Where you can count the share of the intended audience that can reach it today, state it; where you cannot, write *unmeasured* rather than a number. A non-code precondition parked in another team's next quarter is a real user blocked from a capability the goal asked for, and blocks under the clamp. One collaboration platform's no-code AI actions drew strong qualitative feedback while the feature was contractually closed to most of its 250,000 paying customers: the gate was a routine terms-of-service change scheduled for the following quarter, and pulling it forward with legal made AI available to 98% of customers in two weeks. (Usage was smaller again — a few thousand accounts — but that is a separate number, and reading an adoption figure as a reach figure is the same confusion this paragraph exists to break.) Praise from the cohort that can already reach it is this failure's signature, not evidence against it.

**Survival evidence — the part you cannot author.** Name four things or you do not have it: **who** used it who did not build it, **what** they tried unaided, **what** broke, **what you changed** as a result. Run it on a clean checkout, a fresh install or the deployed URL — your working tree is the one environment guaranteed to work, and a demo harness is not exposure. Scale the bar to the ask: an external user means a named non-builder session, an internal capability means the person who asked, on the clean artifact, unaided. **Zero real runs → the verdict word is UNPROVEN, never DONE.** The costly signal is what of *theirs* breaks if you take it away — money, real data, a credential, best of all a hard gate where their work stops unless yours passes; nothing given up and nothing depending on it means *unvalidated*. Nobody volunteers that your product is bad, so say up front that it will be and that their failures are what you want. You may run this reckoning; you may not *be* its evidence — on a one-way door, dispatch it fresh-context with the ask and the artifact, never the builder's summary. And **zero users is a search failure**, not a build failure: return a named list of candidates and how to reach each, then stop coding (**compound-v:founder-distribution**).

**Evolvability.** Name the two most likely next changes and where each lands. If either forces a rewrite of what just shipped, or lands somewhere with no seam and no test, you shipped a final form. Could you reconstruct a failure a user reports from what you already record? If the answer starts with *"I'd add logging and ask them to retry"*, the loop is not closed. And name what a rollback would not undo — reverting restores code, never data, schema, or anything already sent.

### The clamp — what is not allowed to block

A finding blocks **only** if it names **a real user blocked from a capability the goal asked for**, or **a named next change that forces a rewrite**. The not-a-finding discipline is **compound-v:recheck**'s — apply it, don't restate it.

- **Ship at the hit rate you measured, and say what counts as a hit before you say the fraction.** Symptom cleared but root cause live, suite green but a second bug introduced — each is a 1 or a 0 and you state which. No stated hit and no denominator → report *unmeasured*, not a number.
- **Reversibility licenses imperfection, not the word MEP.** Grade each rough edge on the axis **compound-v:frame-the-goal** and **compound-v:make-it-stable** define: undoable, blast radius confined to a boundary you can name, fails loudly. Any "no" and that path gets the production bar.
- **One bar for everything is either gold-plating or a hollow core.** Hold the burning function to a production bar including its bad path; list what is deliberately rough. *Declared* means declared to whoever receives it, before they use it — a rough edge named only in your own report is undeclared.
- **Answer the machine-checkable-criterion question per capability, not once per product.** Name the check that tells an agent it succeeded, or the one human whose judgment is the only bar there. Green from the checkable half is not evidence about the other half. Where neither was ever declared, name the absence; do not invent one now.
- **A deferred follow-up is not a gap.** What the user put off was never promised.

## What this gate cannot see

It reads the assembled product, never a diff — one batch's diff is **compound-v:recheck**, one claim
is **compound-v:verification-before-completion**, a pass rate over a probabilistic path is
**compound-v:evals**. And it runs once: a gate re-run until it agrees is not a gate.

## Discharge — what the run leaves behind

**Discharge before the landing commit.** A row has two halves with opposite half-lives: its `status` is run-scoped and reads `passed` forever the day after the merge — a stale claim the next agent trusts as fact — while its `does` and `evidence` are a regression contract the run already paid to write. So the ledger goes, but never undischarged: every passed row first names a durable target — a command someone can re-run, a production observable and the query that reads it, or a named human and the check they own. `bash scripts/ledger.sh --discharge` refuses the landing until that holds. **An incident opens a row before it opens a fix** (`discovered: true`, the reproduction as its `does`), red-first by construction and re-entering at Carve — not a maintenance lane, because a second-class path is where undeclared work hides.
