---
name: founder-distribution
description: Pressure-tests how a product will actually reach people — first-100 sequencing, channel choice, entry friction, and whether a number means anything. Use when there are no users or growth has stalled, when picking or defending an acquisition channel, when deciding what to gate or what to send, when a launch or roadmap assumes users will simply arrive, or whenever a plan grows the product but not its reach — even if nobody asked about distribution. This is the distribution leg of the master gate; startup-taste judges whether to build, product-taste judges whether it's well made.
---

# Founder Distribution

Code is commodity. The three things that compound are **taste, distribution, and a primitive nobody else has.** There are skills for taste and for judging the primitive. This is the one for distribution — the leg that gets skipped, because it is the only one you cannot make progress on by building.

The tell that you skipped it: a long, healthy commit history and no users. Shipping feels like progress and is measurable daily; distribution feels like exposure and is measurable only in rejections. Teams drift toward the first without ever deciding to.

## When to use
- No users, few users, or growth flat — **especially** when the instinct is to fix the product first.
- Choosing or defending an acquisition channel; planning a launch; writing a roadmap that assumes users arrive.
- Deciding what to gate, what to charge for, what to send, how often.
- A metric moved and someone wants to celebrate.
- **Skip it for:** a product with real retention that needs to be made better, not bigger — that's `product-taste`. Whether to build the thing at all is `startup-taste`.

## The master gate, applied here
**Does this put the product in front of a person who doesn't already know you?** No → it is not distribution, however much work it is. Instrumenting, refactoring the funnel, and polishing the landing page all fail this gate.

## The gates

### Sequence by what you demand before you give
The variable that predicts first-cohort velocity is not push-vs-pull, paid-vs-organic, or B2B-vs-B2C. It is **how much a stranger must do before the product does anything for them.**

Win the first 100 on a surface that delivers real value in a **single zero-configuration interaction** — open a page, paste a public identifier, run one query. Anything that requires an account, a connection, a credential, or a configured preference is a **second-stage** surface, for people who already have a reason to trust you.

This is the observed sequencing across the analytics tools that got big: a free, no-signup, browse-or-paste-an-address surface first; alerts, personalization, and push layered on **after** a base existed. Several scaled to millions with no push feature at all. The reflex to lead with the personalized surface is strong — it's the most impressive thing you built — and it is backwards.

Ask: *what is the least a stranger can do and still get something real?* Put that first. If the answer is "nothing, everything needs setup," you have a distribution problem disguised as a product.

### One channel, not five
Almost every company that got its first thousand users did it through **one** channel, not a portfolio. Five channels at 20% effort is how you get zero on all five. Pick one, go deep enough to actually learn it, and give it a deadline and a falsifier.

Prefer the channel where your buyers **already are** over one you must build. If your users congregate somewhere public, that is a gift — instrument it before you invent an audience from scratch.

### The gate decision rule
An entry gate (invite, waitlist, approval) is **accretive only when all four hold**:
1. **No network effects on the gated side.** Single-player value → slow admission costs nothing. If the product needs density to work, gating starves the thing that makes it work while an open competitor closes the gap.
2. **It screens on fit with the product**, not on who the person already knows or can pay.
3. **The cost of admission is a product interaction, not a transferable token.** A conversation cannot be resold; a code can — and once a resale market exists, the gate selects for hustle, not fit.
4. **It is a capacity constraint actively being worked against**, not a permanent identity that outlived its reason.

The famous gate that worked was a *capacity constraint around manual onboarding coupled to a real measurement program* — an expensive standing apparatus. Note what that implies at small n: the mechanism that is prohibitive at scale is nearly free at 20 users. **A gate with no mechanism behind it is friction wearing a strategy's clothes** — it screens nothing, protects no capacity, and just makes the door heavier.

Failing the rule rarely means "remove all friction." It usually means **the gate is on the wrong surface**: open the browse surface, gate the thing that actually costs you something.

### Threshold at entry, not curation at exit
When a feed, digest, or alert stream is too loud, the reflex is "curate" — assign a human, cut the volume. That is high-lift and rarely happens.

The lever that works is a **threshold on what is allowed to enter the stream**: a size cutoff, a significance floor, a relevance bar. It is a config change, not a hiring decision, and it closes most of the volume gap as a side effect.

Apply it to **every** stream you own, not just the loudest one. Products that flood one surface usually flood all of them, and the worst-hit users are the ones who took the highest-friction action to get there — your most valuable cohort, drowning first.

### Retention sets the ceiling; acquisition cannot outrun churn
A product with modest virality and long retention beats one with high virality and 30-day churn. Every new cohort has to stick or the loop decays to nothing. **Fix retention before optimizing acquisition** — and note that "retention" here means people coming back, not messages delivered.

### Distinguish reach from conversion — and don't assume the bridge
A large audience on a free surface is a **reach asset**. Reach is not conversion, and the step between them is a separate mechanism you must actually build: a filtered tier, a product layer, a reason to move.

Be suspicious here: this is a place where public numbers are systematically unavailable. Impressive follower counts are published constantly; the conversion rate from those followers to product users is published almost never. **If you cannot find the number, say so** rather than borrowing a plausible-looking benchmark from a vendor's content-marketing post.

### A number that only goes up is not a metric
Waitlist size, registered users, subscribers, total messages sent — cumulative counts that **by construction almost never decrease** and have no intrinsic link to whether anyone got value. They feel like progress and measure nothing.

Before celebrating: name the **user outcome** the number is a proxy for, and check that the outcome moved too. Prefer counts that can go **down**: weekly actives, paid power-user retention, the share of a user's relevant work happening in your product.

### PMF is a number, not a vibe
Survey users with *"how would you feel if you could no longer use this?"* and build for the segment that answers **very disappointed**. Track paid power-user retention, not signups. No segment clears the bar → you have interest, not fit; keep finding the people who'd be gutted to lose it rather than widening to please everyone.

### Hand-recruit the first hundred — it is research that happens to collect users
The first cohort comes through you, one at a time. The unscalable work is where the signal is: the exact words people use for the problem, the trigger that made them look, the objection you didn't anticipate. Every awkward conversation is data you cannot get from analytics.

Interview by asking about their **past behavior**, never about your idea. "What did you do the last time this happened?" beats "would you use this?" — the second question has no wrong answer and therefore no information. At n=20, this is a week of calendar, not a program.

### Check where the value actually accrues
A growing market does not mean a growing market **for your category**. Ask who captures the money in this ecosystem today — and whether that is the category you're in. If the volume accrues to a neighboring category, that is a positioning problem sitting upstream of every channel decision, and no amount of channel work fixes it.

### Timing is a variable, not a constant
Some markets are **event-driven**: attention and new users arrive in spikes around scheduled catalysts, then fall hard. Launching into the trough between events looks like a product failure and isn't.

Before committing to a date, ask what the demand calendar looks like and whether the window is rising, flat, or just past a peak. If you must launch into a trough, know that you are, and set expectations to match.

### Every decision names its falsifier
A distribution decision without a measurement that would prove it wrong is a preference. For each one, write down: *what will I measure, by when, and what result makes me reverse this?*

Express thresholds in **units you can actually count** at your scale. At n=20, "conversion improves 15%" is unmeasurable noise; "3 of the next 10 conversations end with someone asking for access" is a real test.

## Honest-warrant discipline
Distribution advice is unusually contaminated: most of what is written about it is content marketing by people selling the channel. Hold three warrant tiers apart and never write them in the same register:
- **Measured** — a real number with a stated method.
- **Converging cases plus a failed search for a counterexample** — strong.
- **Structural inference from two examples** — a reason to prefer the cheap reversible option, not a certainty.

Named cases are all survivors; the matched losers who made the same choice and died are not written up. And every well-known launch has a confound — prior audience, timing, a wave. **A rule that no evidence could break is not a rule.**

## Refusal templates
- **No distribution in the plan:** "Every item here makes the product better for people who already use it. Which one puts it in front of someone who doesn't know us?"
- **Personalized surface first:** "This needs an account and a connected source before it does anything. What's the version a stranger gets value from in one interaction — and can that go first?"
- **Gate with no mechanism:** "This gate screens nothing and protects no capacity — it's friction, not strategy. Either give it a real admission interaction or open the door and gate the expensive surface instead."
- **Vanity number:** "That count can't go down. What user outcome is it a proxy for, and did that move?"
- **Channel portfolio:** "Five channels at 20% each gets zero on all five. Which one, how deep, by when, and what result makes us abandon it?"
- **Borrowed benchmark:** "That figure traces to a vendor blog with no method. Either we measure our own or we state that no reliable number exists — we don't launder theirs."

## What this skill is NOT
It is not a growth-hacking tactics list, and it is not optimism. It assumes an operator who can already build and whose scarce resource is honest signal about whether anyone wants it. Name the violated property, offer the cheapest test that would settle it, and cut the hand-holding — not the rigor.
