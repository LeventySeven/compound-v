---
name: evals
description: Measure whether an AI feature actually works by looking at its outputs systematically — error analysis, a binary judge aligned to a human, and an eval set decomposed by mechanism. Use when building or validating an LLM output, agent, RAG, classifier, or prompt and you need to know if it's good — "is my prompt/agent good?", flaky AI output, choosing a model, before adding or shipping an LLM feature, even when no one asked for evals.
---

# Evals

You cannot tell if an AI feature works by reading the code or vibe-checking a few outputs. You find out by looking at its outputs across the inputs real users send, and turning what you see into a measurement you can re-run. **Shipping an LLM feature with no eval is the single most common cause of a failed AI product** — teams iterate on prompts forever with no idea whether a change helped or hurt.

The AI-behavior counterpart to the code-correctness skills: compound-v:test-driven-development and compound-v:verification-before-completion prove a *deterministic* change does what the diff says, compound-v:recheck reviews a diff for bugs. Evals prove a *probabilistic* feature produces good output over a distribution of inputs.

## When to use

Any LLM call, agent, RAG pipeline, or classifier you're about to tune by feel, ship, or swap models on. **Skip the heavy machinery** for a throwaway prompt you'll run twice: the cheapest eval (a handful of assertions, below) still earns its keep; a labeled judge with calibration does not.

## Verifiable signal first

Before any LLM-judge cleverness, ask: **can this be checked by code?** A cheap deterministic assertion beats an LLM judge on cost, speed, and reliability every time. Make the model emit its objective answer *first* (a number, a label, a JSON field), then its prose — so the check is `output startswith "X"` instead of an LLM-judge call on every case. Reserve LLM-as-judge for open-ended quality (tone, faithfulness, helpfulness) where no assertion exists. Code with an automated pass/fail signal is exactly why coding agents work; engineer your feature so its output has one too.

**For an agent, grade the final state — not the prose.** Assert on what the run actually left behind: the file it wrote, the row it inserted, the tests that now pass. Judging the agent's *narration* measures its writing, and a confident summary of work that didn't happen passes. Hard constraints get code graders; only genuinely subjective quality goes to a judge. Track **turn count, latency, and token cost as first-class metrics** next to correctness — otherwise you cannot see "right answer, wrong path," and an agent that flails for forty turns to a passing result reads as a pass. **"Correctly refused" has to be able to pass**: sometimes the right action is to *not* act, and a final-state assertion ("the balance moved") scores that correct decision as a failure — so assign the label **after** the run, reading the trace, not by fixing a predetermined end-state before it.

## The #1-ROI activity: look at your data (error analysis)

Reading actual traces is the highest-return thing you can do — higher than any prompt tweak. The person doing it should be the **domain expert** who holds the real definition of "correct" — the lawyer, the doctor, the support lead — labeling directly in the product UI, not an engineer guessing at it. The loop:

1. **Read traces.** Pull 30-100 real interactions (production if you have it, a realistic beta otherwise), one row each in a spreadsheet.
2. **Open-code.** Write a free-text note on what went wrong with each bad one — no categories yet, just observations ("dropped the date", "invented a citation").
3. **Build a taxonomy (axial coding).** Cluster the notes into failure types; an LLM can do this pass.
4. **Count.** Map each row to its failure type; pivot-table the frequencies.

**Write evaluators for failures you discover, not failures you imagine — that is the whole of "don't do eval-driven development."** TDD's write-the-test-first instinct misfires here: an LLM's failure surface is effectively infinite, so evals authored up front mostly measure problems you guessed at while the real ones go uncaught. Each evaluator earns its place by pinning a failure you actually observed. Two narrow carve-outs: a hard constraint you can state exactly up front ("never mention a competitor") needs no trace, and a **capability target** — an eval written *knowing* the system fails it today, to give it a hill to climb — is legitimate, because a low pass rate you chose on purpose is not a guess.

**The admission test for a case: what would I actually do differently if this degraded?** Three questions per candidate — what does it measure, would I trust the verdict, what action would a regression trigger — and the third is the one everyone skips. No answer to it, delete the case. Cases nobody would act on cost runtime and credibility every time they go yellow and get waved through, and a suite people have learned to ignore is worse than no suite.

**Never let the model grade itself against its own prior output.** The gold label must anchor to an *externally resolved* source (the resolved outcome, a human verdict, the system of record), not to a number or summary the same model emitted earlier. A generate-and-grade-by-the-same-model loop confirms its own systematic error: it'll happily mark its hallucinated count "correct" because the hallucination is also the answer key. If the truth isn't externally pinned, you're measuring self-consistency, not correctness.

Almost always a **handful of failure types dominate** the long tail. That's the point: you stop guessing and fix the two or three things that actually matter. Bugs like these aren't findable by reading code, only by watching the system fail on real inputs. Generic off-the-shelf metrics are *worse than useless* here — a rising "helpfulness score" while users can't complete the task is "optimizing page-load time while checkout is broken." Build the taxonomy from *your* failures, not a vendor's metric list.

**Build a one-screen data viewer** — it's what makes "look at your data" happen at volume instead of dying after five traces, and it takes **hours** with AI assistance (Streamlit / Gradio / FastHTML). Three properties do the work: **all context for one interaction on one screen** (input, output, retrieved chunks, the trace); **one-click or hotkey labeling** plus a note box, because keystrokes beat forms and that's what makes labeling 100 traces tolerable; and **filter/sort by failure type**.

## Judges: binary + a written critique

When you need an LLM to grade open-ended output:

- **Binary pass/fail, never a 1-5 Likert.** Humans and models both can't reliably tell a 3 from a 4, so Likert scores are noise dressed as precision — and without a fixed anchor judges are generous: a naive baseline slide deck nobody would defend scored **2.8–4 on a 0–5 scale**, the judge having nothing to anchor on and no worked example of what a 0 looks like. Five bands are five chances for the bar to drift upward unnoticed; a binary has one, and it's visible. A 10% rise in *passing* outputs is immediately meaningful; a 0.3 rise on a 5-point scale means nothing. Pairwise ("is A better than B?") is reliable for the same reason — a fixed reference — while "rate this 7.4/10" has none and drifts run to run. A continuous 0.0-1.0 is fine as a **diagnostic alongside** the binary (emit both in one call — the score says how close, the binary decides), never as the **ship-gate**, where its false precision lets borderline output sneak through.
- **Pair every verdict with a one-line written critique** of *why* it failed. Those critiques become the **few-shot examples for the LLM judge**, materially raising judge↔human agreement — logging the response, the critique, and the verdict and reviewing them with stakeholders lifted agreement from **68% to 94% over three iterations**. **Reasons before the score, always.** A judge that emits its verdict first argues backwards to justify it, spending the rest of its tokens defending a number instead of examining the output. Require the reasoning, the pros and the cons, *then* the verdict — this generalizes past evals: anything asked to both decide and explain must explain first.
- **The same aligned judge can become a runtime gate, not just an offline scorer.** Wrap the deliverable in a generate→grade→revise loop: the judge returns pass / needs-revision + its critique, and the agent retries using that critique as the fix-list. **Bound the loop** (e.g. 3 attempts, then accept-with-flag) — an unbounded retry-until-pass loop spins forever on a case that never satisfies the rubric.
- **Align the judge to a human before trusting it**, using the most capable model you can afford — it runs offline, so it can be slower and pricier than production. On 25-50 examples, lay out `model_response | model_critique | model_verdict` against your own human verdict; refine the judge prompt until they agree. **Report agreement on a held-out slice the judge prompt was never tuned against** — agreement on the examples you iterated on is memorisation — and **target >90%**, treating the judge as unusable as a ship-gate below that. When pass/fail classes are imbalanced, **measure precision and recall separately** (a judge that always says "pass" looks 90% accurate on 90%-pass data and is useless). **When a human and the grader disagree, the grader is wrong until proven otherwise** — the disagreement is a bug report against the judge prompt, and "the reviewer misunderstood the rubric" is how a mis-aligned judge survives.
- **Criteria emerge from grading.** You cannot fully specify the rubric up front; the act of labeling *defines* what good means, so expect it to sharpen as you grade and re-calibrate as it drifts.

**Never write a judge criterion containing the word "and."** A single-constraint judge substantially outperforms a multi-constraint one, and the conjunction is the tell that two criteria have been fused into one verdict — split them. So an open-ended task gets a few **independent axes** rather than one blurred verdict: a research-answer judge scores *factual accuracy*, *citation accuracy*, *completeness*, *source quality*, and *tool efficiency*, each its own binary, so a regression in citations is visible even when factual accuracy holds. Start small — roughly **20 queries** finds the gross failures — keeping a human in the loop on the edge cases the judge is least sure about.

## The judge is a proxy — assume it will be gamed

An LLM judge is a stand-in for the goal, not the goal itself. The moment anything optimizes *against* it — an agent tuning its own output, an RL loop, even you iterating on a prompt — it finds the cheap way to pass. Defend the gate:

- **The answer-first output shape doubles as gaming defence** — a fixed prefix check can't be reverse-engineered into "say the magic words." A gate the optimizer can read is a gate it will game.
- **Hold out off-distribution cases** the feature was never tuned on; a judge only ever seen on the training inputs measures memorization, not capability.
- **Require ≥2 independent signals for anything high-stakes** — one judge is a single point of failure with an incentive to be fooled.
- **Over-optimizing even a *legitimate* metric degrades the real thing (Goodhart).** A perfectly fair eval still hurts you if you push the system to ace it — chase factual-consistency and summaries go vague to stay safe (less wrong, also less relevant); chase needle-in-a-haystack recall and the model starts treating distractors as important. Don't ship a metric to its ceiling; watch whether climbing it still moves the outcome you care about, and stop when the two diverge.
- **Make the eval itself tamper-resistant.** Agents optimize the *measured* thing, not the *intended* one: an agent can "solve" a SWE-bench instance by `git pull`-ing the future commit containing the fix, so the harness runs **`git remote remove origin`** — and a model has scored well by reading **its own previous trials out of the git history**, which no remote-stripping prevents, so reset the working tree between runs too. If the environment hands the agent a route to the answer it will take it, including routes you did not think of. Enumerate what the run can *read*, not just what it can call.

## Decompose by mechanism, not difficulty

A single aggregate score hides signal. Group your eval cases by the **mechanism** each one tests, so a change that helps one mechanism is visible even when it doesn't move the others. One team drove agent memory on LongMemEval from a **60.2%** full-context baseline to a **94.87%** SOTA this way, decomposing it into the benchmark's **six** categories so each isolated a different failure cause: temporal-reasoning turned out to be a date-*presentation* problem, knowledge-update a *write*-path problem. Both fixes would have been invisible under one blended number. Split by difficulty (easy/medium/hard) instead and you learn nothing actionable — "hard cases fail more" doesn't tell you *what to fix*.

**Three case types are mandatory whatever the decomposition.** A **control case** that must always pass, the harness's own smoke test — a suite that can't tell "the feature regressed" from "the runner is broken" reports numbers about nothing, and green-because-nothing-ran is the failure that survives longest. **Edge cases drawn from your logged failures**; the weird inputs are already in your traces. And **capability-boundary cases** where the correct behavior is to refuse or hand off — without them you only measure the happy path and never notice the system confidently answering questions it has no business answering.

**Instruction-following is its own axis, and it degrades as instructions accumulate.** For any system carrying a growing pile of rules — a system prompt, an `AGENTS.md`, a judge rubric — the question is not only "did instruction N land" but "did adding N degrade adherence to 1..N−1." Hold one case per standing instruction and re-run the whole set on every prompt edit; that regression is silent otherwise, and it is how a prompt that used to work quietly stops. The limit of this axis: **instructions don't add capability** — if a case fails because the model can't do the thing, no emphasis fixes it; that's a tool or model problem. Stacked emphasis words are the tell: "CRITICAL", "ALWAYS", "NEVER" piling up marks the spot where someone tried to prompt around a missing capability.

## Three cadences, matched to cost

Run cheaper checks more often:

| Level | What | When it runs |
|---|---|---|
| **1 — Assertions** | code-checkable pass/fail (format, contains-X, schema valid, no banned string) | every change, in CI — cheap, so constant |
| **2 — LLM / human eval** | the aligned binary judge over your mechanism-decomposed set | on a schedule / before a release |
| **3 — A/B** | real users, real outcomes | only for major changes |

**Cascade cheapest-first**: build out Level 1 and lean on it hardest — it's free to re-run, and a case that fails a cheap check never needs to reach an expensive one. Don't reach for Level 3 to settle a question Level 1 already answers — that's the overkill compound-v:using-compound-v warns against. (Choosing a model = Level 2 over a fixed input set: run old and new on the *same* inputs and compare before swapping.)

## The eval pipeline is the moat — count experiments, not features

The durable advantage in an AI product is rarely the prompt or the model — both are copyable in a weekend. It's the **eval pipeline**: the harvested failure cases, the aligned judge, the data viewer, the regression set. Progress is the number of hypotheses you tested against data, not the number of features you shipped — a feature added without a way to measure whether it helped is a guess you'll never resolve. So **add evals before you scale tool count or agent complexity** (each new tool or rung multiplies the ways the system can fail, and without a measurement harness you're adding surface area you can't see), **log full traces, not just final answers** (most agent failures are in the trajectory — wrong tool, malformed argument, redundant calls — and an answer-only eval is blind to them), and don't add a capability until you can measure it.

Grow the eval set with real failures — start at ~10 cases you wrote, scale toward hundreds-to-1,000 by **harvesting the dumb, weird inputs real users actually send** in a small "it'll be rough at first" beta. Ship when you pass the bar on that set at a very high pass rate; never promise perfection — set the bar to the use case's risk, not to 100%. Even after RAG grounding and good prompting, the baseline factual-inconsistency rate runs **5–10%**, and it's prohibitively hard to push below ~2% even on simple tasks; an internal classifier tolerates more than a customer-facing medical or financial answer, so the pass rate is a product decision, not a constant. This is the same gate compound-v:startup-taste calls verifier-first — no eval, no ship.

**When you don't yet have real traffic, generate synthetic inputs — but with discipline.** Build the set as **features × scenarios × personas** so coverage is structured, not a pile of similar prompts. Generate the **inputs, never the outputs** — a synthetic "correct answer" defeats the exercise of seeing what your system produces. And **verify each synthetic case actually triggers the path it claims to**; a scenario that doesn't exercise the feature is a blind spot dressed as coverage.

**Trace-reading stop rule:** read logs until you stop learning. When several traces in a row teach you nothing new — no fresh failure mode, no surprising input — you've saturated this batch; **~100 is a reasonable floor** before you trust that signal, fewer only for a throwaway. Stop when the marginal trace stops surprising you, not when you hit a quota.

## Guard against drift, decoration, and trajectory bugs

- **Run every case N times, each trial from a clean environment, and report the spread.** Agent behaviour is a distribution, not a value: a single pass tells you almost nothing, and high variance is its own finding, not something to average away. Isolate the trials — cases that share state contaminate each other and the result reads as flakiness, worst on a coding kit where a dirty working tree is the default. Then **compound the per-trial number** when the work is a chain of steps that all have to land: 75% per trial is about 42% over three, and the un-compounded headline flatters the system.
- **Freeze a golden set; re-run it when you change the judge.** Your judge prompt and rubric *are* code, and editing them silently moves the bar. Keep a small set of human-verified cases with locked verdicts; after any judge change, re-run it — if previously-passing cases now fail (or vice versa), you changed the measurement, not the system. Corollary: **when a score comes back catastrophically low, suspect the eval before the model.** A 0% pass rate is far more often a broken task than a broken system — a malformed grader, an impossible setup, an ambiguous prompt. Verify the task is well-formed first: a reference solution exists, and two people reading it independently reach the same verdict. One model jumped from 42% to 95% on a benchmark purely by fixing the grading.
- **Scaffolding is scoped to a model generation — re-test with it removed on every upgrade.** Judges, critics, retry loops, and extra agents compensate for a specific model's weaknesses, and they expire without telling you. One production LLM judge that had moved a PR success rate from ~20–30% to ~80% was deleted outright once the models got good enough not to need it. So on each upgrade, re-run the suite with your judge/critic/extra-agent layer *off*; if the score holds, delete the layer — you are paying latency and tokens for a workaround to a problem that no longer exists. This stops a harness ossifying around a model that isn't in production anymore — the reflex compound-v:context-engineering applies to the harness: don't keep what scale washed away.
- **Negative-control / ablation: remove the input the feature depends on and watch the metric drop.** If a RAG answer scores the same with retrieval turned *off*, the retrieval is decorative and the model was answering from priors. A component that can be ablated with no metric change isn't earning its place.
- **For agents: path free, arguments graded.** Don't assert *which* tool was called — agents are resourceful and reach the goal another way, so a tool-path assertion turns a correct novel route into a false failure, and becomes a change-detector the moment you consolidate two tools into one. Do inspect the **arguments** of the calls that did happen: a missing or malformed parameter is invisible in the final answer, and that is exactly where defects hide. Pin a call sequence only where the task requires one — a mandatory audit write, a required confirmation — and then at the loosest strictness that still catches the bug: **ANY_ORDER** (the required calls all happened, order-free) before **IN_ORDER** (in order, extras allowed) before **EXACT** (same calls, same order, nothing extra).

## Red flags

| Smell | Why it's wrong |
|---|---|
| Tuning the prompt by re-reading 3 outputs | You're optimizing on noise. Do error analysis on 30-100 real traces. |
| A 1-5 quality score | Graders can't separate 3 from 4. Use binary pass/fail. |
| A judge you never aligned to a human | Could be agreeing with itself. Calibrate on 25-50 examples; target >90% agreement on a held-out slice, P/R when imbalanced. |
| A pass/fail from a single run per case | Behaviour is a distribution. Run each case N times from a clean environment; report the spread. |
| Reaching for an off-the-shelf "helpfulness" metric | Generic metrics are worse than useless — checkout's broken while load-time improves. |
| LLM-judging something code could assert | Slower, costlier, flakier. Emit the answer first; assert on it. |
| Test cases only from your imagination | Real users send inputs you'd never invent. Harvest failures from a beta. |
| A judge or retry layer nobody has re-tested since the model upgrade | Scaffolding expires. Re-run with it off; if the score holds, delete it. |
| Shipping the feature with no eval at all | The #1 cause of failed AI products. Even a handful of assertions beats nothing. |
