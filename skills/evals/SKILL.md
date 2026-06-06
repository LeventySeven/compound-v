---
name: evals
description: Measure whether an AI feature actually works by looking at its outputs systematically — error analysis, a binary judge aligned to a human, and an eval set decomposed by mechanism. Use when building or validating an LLM output, agent, RAG, classifier, or prompt and you need to know if it's good — "is my prompt/agent good?", flaky AI output, choosing a model, before adding or shipping an LLM feature, even when no one asked for evals.
---

# Evals

You cannot tell if an AI feature works by reading the code or vibe-checking a few outputs. You find out by looking at its outputs across the inputs real users send, and turning what you see into a measurement you can re-run. **Shipping an LLM feature with no eval is the single most common cause of a failed AI product** — teams iterate on prompts forever with no idea whether a change helped, hurt, or did nothing.

This is the AI-behavior counterpart to the code-correctness skills: compound-v:test-driven-development and compound-v:verification-before-completion prove a *deterministic* change does what the diff says; compound-v:recheck reviews a diff for bugs. Evals prove a *probabilistic* feature produces good output over a distribution of inputs. Different problem, different tool.

## When to use

- You're adding an LLM call, agent, RAG pipeline, or classifier and you're about to tune the prompt by feel.
- The output is flaky — good on your three test cases, weird on real traffic.
- You're choosing between models (or deciding whether the new model is actually better).
- A stakeholder asks "is it good enough to ship?" and you have no number to point at.
- **Skip the heavy machinery** for a one-off script or a throwaway prompt you'll run twice. The cheapest eval (a handful of assertions, below) still earns its keep; a labeled judge with calibration does not.

## Verifiable signal first

Before any LLM-judge cleverness, ask: **can this be checked by code?** A cheap deterministic assertion beats an LLM judge on cost, speed, and reliability every time. Make the model emit its objective answer *first* (a number, a label, a JSON field), then its prose — so the check is `output startswith "X"` instead of an LLM-judge call on every case. CoCounsel's discipline: "evals are way easier when you can say `matches word X`." Reserve LLM-as-judge for genuinely open-ended quality (tone, faithfulness, helpfulness) where no assertion exists — it's sometimes the only option, not the default one. Code with an automated pass/fail signal is exactly why coding agents work; engineer your feature so its output has one too.

## The #1-ROI activity: look at your data (error analysis)

Reading actual traces is the highest-return thing you can do — higher than any prompt tweak. The loop:

1. **Read traces.** Pull 30-100 real interactions (production if you have it, a realistic beta otherwise). One row per interaction in a spreadsheet.
2. **Open-code.** Write a free-text note on what went wrong with each bad one — no categories yet, just observations ("dropped the date", "invented a citation", "ignored the second question").
3. **Build a taxonomy (axial coding).** Cluster the notes into failure types. An LLM can do this clustering pass over your notes.
4. **Count.** Map each row to its failure type; pivot-table the frequencies.

Almost always **~3 failure types account for ~60%+ of all failures** (NurtureBoss: 3 issues = 60%+). That's the point — you stop guessing and fix the two or three things that actually matter. One fixed: NurtureBoss's date-handling went **33% → 95%** once they saw it ranked. None of these bugs were findable by reading code; only by watching the system fail on real inputs.

Generic off-the-shelf metrics are *worse than useless* here — a rising "helpfulness score" while users can't complete the task is "optimizing page-load time while checkout is broken." Build the taxonomy from *your* failures, not a vendor's metric list.

## Judges: binary + a written critique

When you do need an LLM to grade open-ended output:

- **Binary pass/fail, never a 1-5 Likert.** Both humans and models can't reliably tell a 3 from a 4, so Likert scores are noise dressed as precision. A 10% rise in *passing* outputs is immediately meaningful; a 0.3 rise on a 5-point scale means nothing.
- **Pair every verdict with a one-line written critique** of *why* it failed. This is the highest-leverage trick in the whole skill: those critiques become the **few-shot examples for the LLM judge**, raising judge↔human agreement by **15-20%**. Critique first, score second.
- **Use the most capable model you can afford as the judge** — it can be slower and pricier than your production model; it runs offline.
- **Align the judge to a human before trusting it.** On 25-50 examples, lay out `model_response | model_critique | model_verdict` against your own human verdict; refine the judge prompt until they agree. **Target >90% agreement.** When pass/fail classes are imbalanced, don't report raw agreement — **measure precision and recall separately** (a judge that always says "pass" looks 90% accurate on 90%-pass data and is useless).
- **Criteria emerge from grading.** You cannot fully specify the rubric up front; the act of labeling *defines* what good means. Expect the rubric to sharpen as you grade, and re-calibrate periodically as it drifts.

A domain expert — the lawyer, the doctor, the support lead — should write the prompts and the eval criteria directly, in the real product UI. They hold the definition of "correct" that an engineer is only guessing at.

## Decompose by mechanism, not difficulty

A single aggregate score hides signal. Group your eval cases by the **mechanism** each one tests, so a change that helps one mechanism is visible even when it doesn't move the others. Mastra drove agent memory from 67% to SOTA this way — their five buckets each isolated a different failure cause: single-session extraction (bounded retrieval), multi-session reasoning (semantic recall), temporal reasoning (date *presentation*), knowledge updates (the *write* path — targeted overwrite, not full rewrite), and absence-awareness (say "I don't know", don't hallucinate). The fixes were mechanism-specific and would have been invisible under one blended number.

If you split by difficulty (easy/medium/hard) instead, you learn nothing actionable — "hard cases fail more" doesn't tell you *what to fix*. Split by what's being exercised.

## Three cadences, matched to cost

Run cheaper checks more often (ordered by what dictates the cadence):

| Level | What | When it runs |
|---|---|---|
| **1 — Assertions** | code-checkable pass/fail (format, contains-X, schema valid, no banned string) | every change, in CI — cheap, so constant |
| **2 — LLM / human eval** | the aligned binary judge over your mechanism-decomposed set | on a schedule / before a release |
| **3 — A/B** | real users, real outcomes | only for major changes |

Build out Level 1 first and lean on it hardest; it's free to re-run. Don't reach for Level 3 to settle a question Level 1 already answers — that's the overkill compound-v:using-compound-v warns against. (Choosing a model = Level 2 over a fixed input set, not a vibe: run old and new on the *same* inputs and compare on your metrics before swapping.)

## Build a one-screen data viewer

Teams with a thoughtfully built data viewer iterate **~10x faster**. You'll build it in **hours** with AI assistance (Streamlit / Gradio / FastHTML — anything you already have; don't go buy a fancy eval platform first). What makes it pay off:

- **All context for one interaction on a single screen** — input, output, retrieved chunks, the trace. No clicking between tabs.
- **One-click / hotkey labeling** — pass/fail plus an open-ended note box. Keystrokes beat forms; this is what makes labeling 100 traces tolerable.
- **Filter and sort by failure type** — so you can jump straight to the cluster you're working.

The viewer is what makes "look at your data" actually happen at volume instead of dying after five traces.

## Count experiments, not features

Progress on an AI product is the number of hypotheses you tested against data, not the number of features you shipped. A feature added without a way to measure whether it helped is a guess you'll never resolve. So: don't add a capability until you can measure it (Mastra deliberately deferred reranking and episodic memory until each was measurable), and grow the eval set with real failures — start at ~10 cases you wrote, scale toward hundreds-to-1,000 by **harvesting the dumb, weird inputs real users actually send** in a small "it'll be rough at first" beta. Ship when you pass the bar on that set (CoCounsel ships near ~999/1,000); never promise perfection.

## Red flags

| Smell | Why it's wrong |
|---|---|
| Tuning the prompt by re-reading 3 outputs | You're optimizing on noise. Do error analysis on 30-100 real traces. |
| A 1-5 quality score | Graders can't separate 3 from 4. Use binary pass/fail. |
| A judge you never aligned to a human | Could be agreeing with itself. Calibrate on 25-50 examples; target >90% agreement, P/R when imbalanced. |
| One aggregate accuracy number | Hides which mechanism broke. Decompose by mechanism. |
| Reaching for an off-the-shelf "helpfulness" metric | Generic metrics are worse than useless — checkout's broken while load-time improves. |
| LLM-judging something code could assert | Slower, costlier, flakier. Emit the answer first; assert on it. |
| Test cases only from your imagination | Real users send inputs you'd never invent. Harvest failures from a beta. |
| Shipping the feature with no eval at all | The #1 cause of failed AI products. Even a handful of assertions beats nothing. |
