---
name: council
description: Several independent fresh-context takes on one hard question, and a verdict that shows where they disagreed. Use when a judgment call has no checker to run and being wrong is expensive: an architecture or vendor choice, a diagnosis with competing explanations, a strategy, pricing or hiring call, a design nobody can objectively score, or a conclusion that feels obviously right that nobody has pushed back on. Also on "get a second opinion", "what would other models say", "poke holes in this", "am I missing something", or wanting the alternatives laid out rather than one confident answer. Skip it when a test, query or benchmark can settle the question — run that instead.
---

# Council

A council is not a vote. It is a way of spending more compute on one question that has no checker — and the leg that pays is the **blind second look**, not the diversity of first opinions.

Be honest about that ordering, because it inverts the obvious design. Asking one model the same question N times mostly buys you N similar answers: sampled repeatedly, a single model "will generate solutions that are very similar," and the diversity that makes voting work only comes free when the agents are *trained* differently — which, keyless and single-family, they are not. What survives the evidence is the other half: a reviewer that never saw the first answer being written catches things its author cannot. Build for that.

## When to convene

- **No checker exists.** This is the gate. If a test, compiler, type system, query, or benchmark can settle the question, run it — self-critique on checkable claims measurably degrades results, hallucinating faults that aren't there and editing toward them. Where a sound external verifier does exist it dominates: ~15 generate-critique iterations against a formal verifier took Blocksworld planning to 82%, while the same loop with the model judging itself was called "a MIRAGE" that leaves models worse than guessing once.
- **The call is expensive or hard to reverse** — a one-way door, a schema, a vendor, a public commitment.
- **The question has genuinely independent angles** — breadth-first work with several directions worth pursuing at once. That shape, and only that shape, parallelizes.
- **Skip it** when the call is cheap or reversible; when you can already name the answer and just want reassurance (that is **compound-v:critical-thinking**, which is free and runs solo); when the work is finished and needs review rather than deciding (**compound-v:recheck**); or when every member would come at one question from the same angle — N agents on one patch of ground is not a council, it is one answer paid for N times.

**Price it before you convene.** Agents use roughly 4× the tokens of a chat and multi-agent runs about 15×, and the value has to justify that. Anthropic's own analysis of why fan-out works is deflating and worth internalizing: multi-agent systems "work mainly because they help spend enough tokens to solve the problem," with token usage by itself explaining 80% of the performance variance. You are buying compute, not wisdom. Three members is the default; go to five only for a genuinely multi-faceted question, and never past that.

## Stage 1 — opinions, differentiated by mandate

Every member is the same model with the same tools. That is not the compromise it looks like — it is what a production harness already does. Codex tells its own root agent outright that "All agents in the team, including the agents that you can assign tasks to, are equally intelligent and capable, and have access to the same set of tools," and locates every difference in the assigned task and the propagated context.

So differentiate by **mandate**, not costume:

- **Not a persona.** "You are an expert X" has been studied repeatedly and found to contribute little on its own; the shipped practitioner guidance is 80% of effort on well-defined tasks and 20% on personas. A costume is the cheapest thing to write and the least load-bearing thing you can vary.
- **A different question, a different slice.** What *did* move output materially was a different declared standpoint over the same material. The prior art with the best shape gives each member an opposing angle — **strongest case / steelman the minority view / reconcile the two** — reading a deliberately different curated source list that **you** choose, not one they pick for themselves.
- **A narrowed tool surface.** When Codex spawns its reviewer it replaces the base instructions wholesale and disables the tool families that would let it wander back. A role that changes the harness is a real role; a role that only changes the greeting is not.

Give every member the four things whose absence makes agents duplicate work and leave gaps: **an objective, an output format, guidance on tools and sources, and clear task boundaries.** Write these yourself — a lead left to size its own fan-out over-invests.

Members never talk to each other. Agent-to-agent chatter is an anti-pattern; coordination belongs at your level, and a mesh of peers each messaging each other is chaos wearing an architecture diagram. **REQUIRED:** Use compound-v:dispatching-parallel-agents for the mechanics of briefing and running them.

## Stage 2 — cross-examination, blind and fresh

This is where llm-council's design has to change, and it is the change that makes the keyless version work.

**The reviewers are new agents, not the stage-1 members re-invoked.** A member that judges inside the context it generated in is the documented trigger for in-context reward hacking — "Identical context between the evaluator and generator is crucial," and shared context matters more than context length. The same mechanism shows up as a model re-reading its own draft and reproducing its own hallucination. Pointing the other way, a coding-and-review pair was found to "work best when the coding and review agents do not share any context beforehand." Fresh context is the whole asset. Do not spend it.

**Ask for findings, not a ranking.** A survey of eight shipped agent harnesses (Codex, Conductor, Claude Squad, Agency Swarm, AutoGen, CAMEL, Devin, the Claude Agent SDK) found none in which agents rank each other's answers. The nearest counter-example sits outside that set — Grok Heavy lets a judge decide among peer answers — so treat peer-ranking as rare and unproven rather than unheard of. What *is* shipped is Codex's review rubric, whose terminal judgment is binary (`"overall_correctness": "patch is correct" | "patch is incorrect"`) with the substance carried in a findings list, each finding tagged P0–P3 as an integer and carrying a `"confidence_score": <float 0.0-1.0>`. Copy that shape:

- **Per finding:** what is wrong, where, severity, confidence, and what would change the verdict.
- **Give the zero-finding exit, and the keep-going push, together.** The rubric states both at once — "prefer outputting no findings" over weak ones, and "Do not stop at the first qualifying finding." A reviewer that must find something will manufacture something; a reviewer with no floor stops at one.
- **Derive the verdict from named axes; never ask for a gestalt.** Codex's guardian derives its outcome "only after assigning `risk_level` and `user_authorization`," then maps them through a fixed threshold table. Name the two or three axes that matter for *this* question and let the verdict fall out of them.
- **Ban flattery in the brief.** A production review prompt had to say it in as many words: the comment "should avoid excessive flattery" and should avoid phrasing like *Great job…* or *Thanks for…*. Optimizing toward approval makes wrong answers more *convincing*, not more correct.

**If you do compare two candidates head-to-head, do it pairwise and run it twice with the order swapped.** Pairwise comparison is more stable than scoring on a scale, and graded scales fail for a mechanical reason — raters "default to middle values to avoid making hard decisions." Judge order bias is real and directional: altering the order of candidates alone can hack the ranking, and the direction is model-specific — one model was found to favour the first candidate shown, another the second. The part that catches people is that it is *not fixable by instruction*: the sentence telling the judge that presentation order "does not affect your judgment" was tested, and the bias persisted anyway. The two mitigations that measured out are aggregating across presentation orders and forcing the judge to write its evidence *before* any score.

**Do not average ranks into a leaderboard.** Grok Heavy — the one shipped parallel-agent product here — "explicitly does NOT vote". Take that as evidence against *averaging*, not as a model to copy: what it does instead is let instances read each other and iterate to convergence, which is the multi-round debate this skill rules out below. Both halves are deliberate. A tested judge ensemble lost to the cheapest option — "Single LLM call with a single prompt outputting scores from 0.0-1.0 and a pass-fail grade was the most consistent." And the closest measured analogue to llm-council's stage 2 — several instances scoring a response across rubric dimensions — came out *no better than plain majority voting, and worse on two datasets*.

**One round. Agreement is not evidence.** Interacting agents converge on a confident wrong answer often enough to have a name — the "debate club" phenomenon — and role separation decays *when nothing holds it in place* — CAMEL reports agents role-flipping after about five to ten turns without a hard role anchor, and hundreds of turns without collapse once one is present. That is an argument for anchoring each mandate firmly, and for not running the rounds that would test it. Take the findings and stop; if the members agree, that is a fact about the model, not about the world.

## Stage 3 — the chair is you

**You write the final answer. Never delegate it.** The rule is explicit in the shipped research orchestrator's own prompt: "NEVER create a subagent to generate the final report." Only you have seen every return.

- **Show the alternatives; don't dissolve them.** Cursor's background agents let you take three or four attempts and then go "through all the options Cursor provides and picking the winner"; Xcode generated ten named variations for a person to click through. Note the counter-case rather than hiding it: Warp explored and rejected a best@k system for its primary agent, keeping only a light wrapper that auto-selects — showing candidates is an interface choice, not a universal one. The design advice is blunt: "ask for MULTIPLE options." A council that hands back one smoothed paragraph has thrown away the thing it paid 15× for.
- **Lead with the disagreement.** What did the members split on, which way did you call it, and why. Where they agreed, say whether anything independent corroborates it.
- **Name what stayed unresolved**, rather than letting a confident summary imply it was settled.

## Keep the stages from silently vanishing

A staged pipeline carried only in a prompt gets evicted by compaction mid-run — orchestrators have been observed to drop an entire critic stage and quietly downgrade a multi-draft ensemble to a single draft. Sessions are discrete and compaction "isn’t sufficient" on its own, because it "doesn’t always pass perfectly clear instructions to the next agent." The degradation is invisible — you get a plausible answer from a pipeline that quietly skipped its own critic.

Two cheap defenses, both worth it: write the three stages down as a visible checklist before dispatching anything, and **tool-lock the reviewers read-only** rather than telling them not to write — making the undesirable action mechanically impossible beats prompt-discouraging it.

## What changed from llm-council, and why

| llm-council (Nov 2025) | Here | Why |
|---|---|---|
| 4 vendors via a paid API key | 3 fresh agents, one model family, keyless | A shipped harness already assumes all agents are equally capable with the same tools and differentiates by task + context. |
| Members differ by vendor | Members differ by mandate, sources, tool surface | Vendor diversity isn't available keyless; persona alone contributes little; a different question and slice does. |
| Each member ranks all answers **including its own** | Fresh reviewers, never the authors | Identical evaluator/generator context is the trigger for in-context reward hacking; a model re-reading its own draft repeats its own error. |
| "FINAL RANKING:" + averaged rank positions | Findings with severity + confidence; no leaderboard | Rank-averaging has no shipped precedent and no measurement; the rubric-scoring analogue tied plain majority voting and lost on two datasets. Read the original closely and the leaderboard is already inert — `calculate_aggregate_rankings` is computed into the API metadata but never passed to `stage3_synthesize_final`, so it decorates the UI and never touches the answer. |
| Regex over the ranking text | A stated output contract, and a documented fallback when it isn't met | Production parsing is typed-then-fallback-then-degrade-non-fatally; a regex over prose is the fragile link. |
| Anonymized A/B/C/D, fixed order | Swap the order when comparing; anonymity is free here | Position bias is worth >20% and cannot be instructed away. Nothing in the corpus shows anonymization removes self-preference — with one family there are no identities to hide, so the question is moot rather than solved. |
| Chairman sees the real model names | No identities exist to leak | llm-council anonymizes in stage 2 and then hands the chairman the de-anonymized authors, reopening the bias it just closed. |

## Red flags

| Symptom | What it means |
|---|---|
| A test or query could have answered this | Not a council question. Run the checker; self-critique on checkable claims makes things worse. |
| Members are re-invoked to judge their own answers | Evaluator/generator context sharing — the reward-hacking trigger. Spawn fresh reviewers. |
| The output is an averaged ranking or a winner | Unevidenced aggregation. Return findings with severity and confidence instead. |
| All members agreed, and that's the headline | Convergence, not corroboration. Same model, same training — agreement is nearly free. |
| Members were given personas but the same question | The costume is the differentiation. Vary the mandate and the sources instead. |
| A reviewer returned a long list of small findings | No zero-finding exit in the brief. Say "prefer outputting no findings" out loud. |
| Debate rounds until consensus | The debate-club failure. One round; take the findings and stop. |
| A subagent drafted the final answer | Only the chair has seen every return. Write it yourself. |
| The run produced an answer but you can't say which stage found what | The pipeline may have dropped a stage under compaction, which has been observed to happen silently. Keep the checklist visible. |
