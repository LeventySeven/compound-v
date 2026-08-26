# Prior art — recon that shrinks the build

The stage-2 method for **compound-v:get-shit-done**. Read it when a slice's *unknown* is real and
unresolved. Its whole job is to come back with less to build than you left with.

This is a different question from **compound-v:searching-patterns**, which asks *how is this API
used correctly* at the moment you write the line. This asks, before the design exists: **has
someone already solved this slice, and what does that delete?** Same sources, different output —
that one hands you a pattern; this one hands you a shorter project.

## Budget it, or it eats the day

Recon is bought with the confidence bucket from stage 1, not spent evenly:

| Slice confidence | Budget | Why |
|---|---|---|
| ~95% / ~90% | none | Looking up what you'd write correctly from memory is pure overhead. |
| ~65% | one pass, one channel deep | You have the path; you're checking the trap list. |
| ~30% | the full ladder, until the unknown resolves or is confirmed genuinely open | This is the slice that decides whether the project is what you think it is. |

Stop the moment the *unknown* is answered. Recon is not a reading assignment; it is a question with
an exit condition. A slice whose unknown survives all three channels is a real finding — say so, and
treat it as the one-way door it probably is.

## The output contract: two lists per slice

**DELETE** — what you now do not have to build. A library covers it, the platform already does it,
the vendor ships it, the hard version turns out unnecessary, or someone published the 40-line
version of the thing you were going to architect.

**FORCE** — what you now must handle that the plan did not name: a rate limit, an auth dance, a
pagination shape, a known data trap, an ordering guarantee you don't get for free.

Both go in the ledger. A deletion nobody wrote down gets rebuilt by the next session, which is the
same defect as never having found it.

**An empty DELETE list is the signal to re-run the search, not to proceed.** In practice it means
the queries were shaped as *how do I build X* rather than *who already has X*. It can be honestly
empty on novel work — say that explicitly, because silence reads as diligence and isn't.

## Channel 1 — what is already on disk

Cheapest, version-exact, works with no network, and survives a sandboxed run. In order: the
installed package (`node_modules/<lib>` and its `.d.ts`, `site-packages/<pkg>`, vendored source),
a house wrapper or `AGENTS.md`/`CLAUDE.md` rule, a neighbouring repo in the same org that solved
this, and the project's own history — `git log -S<term>` finds the last time someone touched this
problem and what they concluded.

If the environment has a local library of essays, product write-ups or talk transcripts, that is
also channel 1 and it outranks a web search: `grep -rn` over a few hundred markdown files is current
by construction and costs nothing. Route through a manifest or a heading index where one exists, and
never let a summary stand in for a source that is sitting on disk unopened — that substitution is
the most common way a grounded-looking answer turns out to be second-hand.

**Enumerate every lane the library has, live, and treat its curation tags as ordering only.** Such a
library usually holds several distinct kinds — primary essays, product write-ups, raw transcripts,
curated route-maps — often split across more than one folder and more than one naming convention,
and it grows most days. So `ls` the lanes *this run* rather than working from a remembered list or a
count written into a doc; a lane you never enumerated is invisible to every check downstream, and a
hardcoded total is stale the week after it is written. Where two folders overlap, enumerate the
superset: "they are duplicates" is true of the shared files and silently wrong about the ones only
one side has.

**And a curated library's `MUST`/`STRONG`/`OPTIONAL` grades are a human's time budget, not an agent's
read set.** They exist to rank what one person should spend an evening on. An agent reads in
parallel and does not tire, so the grade decides **order, never inclusion** — an `OPTIONAL` tag means
"low priority for a human", not "low relevance to this question". Read every source that bears on
the question regardless of grade; skip one only for a written reason about the *question*, never
because of its tag. The same goes for a guide's own "reading paths": those are routes for a person,
and following one is not the same as covering the material.

## Channel 2 — primary web sources

The maintainer's own docs and repo, pinned to your lockfile's version; the paper; the changelog; the
official conformance suite where one exists. `gh api` and `gh search code` reach the real source and
show how the library uses its own thing. Blogs and forum answers rank below all of these.

Two habits that pay: run a second query with different wording rather than trusting the top result
(SEO pages and stale majors dominate first hits), and read the version you are actually on rather
than whatever the docs render by default.

## Channel 3 — practitioners in public

Where technique appears months before documentation, and the only channel that answers *"did anyone
try this in anger and what broke?"* Also the noisiest by a wide margin, so it needs a retrieval path
that works and a filter that cuts most of what it returns.

**Seed the account list from people already in your corpus, not from reach.** Anyone whose essay,
talk or paper already cleared the bar offline has cleared it as a person; their feed is the live
edge of the same judgment. Extract the author list from what you already trust, then add the
practitioners those authors cite. **Do not rank accounts by following count** — measured on 47
accounts pulled this way, engagement selects audience size, not source quality: the single account
whose essay is the one public primary behind a shape-table row returned **zero** posts clearing a
likes-and-length filter, while a million-follower account returned **75%**, nearly all of it release
news and virality commentary. A metric filter would have dropped the best practitioner and kept the
noise.

**The roster is one caliber of person: the people who would clear the corpus bar if they wrote an
essay.** Founders and CTOs who shipped and operated the thing, founding engineers, AI engineers at
frontier labs, and working developers at top-tier startups and companies — the same population the
offline corpus is built from, sampled live. That is the *only* qualification; a title at a famous
company is not one, and neither is an audience.

**But seed the person, not the org — the distinction is measured, not stylistic.** A practitioner's
personal feed and their employer's feed are different channels with different products. Widening a
roster from 66 to 120 by adding lab, vendor and company accounts pulled in vendor-blog posts,
funding coverage and event-registration pages — which the bar already cuts as *"vendor / devrel
marketing dressed as education."* Same people, wrong handle. A CTO writing in the first person about
what broke is the channel working; the company account announcing a partnership is the noise the
channel is worst at filtering, because it carries the most engagement.

**The unit to extract is the outbound link, not the post.** A practitioner's post is a pointer;
the essay it points at is the source, and the corpus bar is written for essays. Pull
`entities.urls[].expanded_url`, drop self-links and media, and dedupe against what the corpus
already holds — the survivors are the channel's actual product. Measured on 66 accounts seeded this
way: **1,081 original posts → 166 links the corpus did not already have → 71 essay-shaped, about
7% of posts.** The other 95 were product pages, release notes, jobs, events, gists and one Google
Form. A low yield is the channel working correctly; it is a discovery lane, worth one pass and never
a standing sweep.

**Engagement over-selects announcements — reliably in direction, not in size.** Measured on two
independent harvests: announcement-shaped links out-engaged the rest by **7.8x mean / 6.8x median**
on a 66-account roster and **2.7x / 3.2x** on a broader 120-account one; announcements filled **9 of
the top 10** by likes in the first and **3 of 10** in the second, against ~10% of each tail. The
direction held both times and the magnitude did not — it tracks how **exec-heavy the roster is**,
because a founder's most-liked post is a launch and a researcher's is not. So the rule is
directional: **never rank by engagement, and never quote a multiplier as if it were a constant.**
A frontier-lab press release is the single most-liked thing this channel produces, and the corpus
bar cuts it on sight as *"news, hype takes, 'X just dropped' reactions with no durable insight."*

**Roster composition decides which noise class you get, so name it before you harvest.** The
exec-and-company-heavy roster produced a vendor-blog and event-page class the personal-account
roster did not (Databricks, Dell, NVIDIA, event registration pages — 4% of links) — the bar's
*"vendor / devrel marketing dressed as education"* row, arriving as a measurable share rather than
as a warning. Yield itself was stable across both: **6.6% and 6.1% of posts.** Expect ~6-7%, expect
the noise to change shape with the roster, and re-measure the mix rather than inheriting it.

**Two stages, and the second one is a read.** A cheap mechanical pass narrows — drop replies and
retweets, drop anything opening with an announcement marker (*excited to*, *introducing*, *now
available*, *check this out*), keep what carries causal or mechanism language or a number with its
cause. Measured: **705 original posts → 109 claim-shaped, about 15%**, which is the "expect to keep a
minority" rule showing up as a number. But the mechanical pass **cannot make the call** — its
numeric signal reliably promotes news that happens to quote figures (a model release, a traffic
share). Read the survivors and decide on the claim. A regex narrows; a read decides, and pretending
otherwise is how a filter that was working starts passing polished noise.

### Retrieval — check before you trust

Access to X in particular changes without notice, and the failure is silent-looking rather than
loud. Verify the path in the current environment before building a recon pass on it; each check is
one call.

- **Search-with-domain-filter is the workhorse.** A web-search tool constrained to `x.com` returns
  real post URLs *and* an extracted digest of their substance, with no setup and no credentials.
  This is the default; start here.
- **Expect a plain fetch of a post URL to fail.** X serves paywall/authorization responses to
  unauthenticated fetchers, and a headless browser with a fresh profile gets the login wall on
  search and an access-denied on a single post. Neither is a bug to debug — it is the wall.
- **Full bodies need an authenticated path**: a browser driving the user's *own* logged-in session,
  or an X API with a key. Long-form X "articles" hide their body behind a link shim rather than in
  the post text, so a naive read of the post returns a teaser and looks like a thin result.
- **Never mint a credential to get past this**, and never paste one into a tool that echoes its
  input. If the only way through is the user's own session and you don't have it, the honest output
  is "this channel is closed in this run" — see **compound-v:agent-security**.

**The digest a search tool returns is a paraphrase, not the text.** It is fine for deciding whether
a source matters and useless as a quotation. Anything you carry into a plan as a fact needs the
actual words from an opened source; anything else is marked as unverified or dropped. Save the full
text of every keeper to a local file as you go — these links rot, get deleted, and go behind walls.

### Filter — most of what you retrieve is noise

Five gates, all of which a keeper must pass. They are calibration knobs, not measurements:

1. **Primary** — the person who did the thing, in their own words. Not a commentary account
   re-explaining them.
2. **Non-obvious** — something only real experience or frontier work reveals. If a two-minute
   search answers it, cut.
3. **Changes a decision** — a mental model, a trade-off, a piece of taste. Pure how-to-do-a-chore
   usually fails.
4. **Insight ≥ length** — dense. One idea stretched to 3,000 words fails even if every word is true.
5. **Not stale consensus** — unless it is the canonical statement of the idea.

Cut on sight regardless of polish: anything ending in a sales CTA or pitching a paid stack; a single
post mirrored as an "article" whose title is the whole payload; a teaser that promises the payoff
later; documented mechanics relabelled as a masterclass; "N tips" listicles; hustle content; hot
takes on a release; a summary of someone else's work; and pointers whose real content is a linked
paper you should read instead.

**Verify the author before you weigh the claim.** Where the authority rests on a claim — *"I work on
X at Y"* — the profile has to support it, because an invented insider is the single largest category
of fake technical content and it is cheap to manufacture.

**Judge the payload, not the byline.** This is the rule that actually bites: impeccable authors post
feature toggles, launch announcements and tips lists, and those are cuts. A credible name on a thin
post is the most common way noise gets through a filter that was working. Expect to keep a minority
of any batch — that ratio is a calibration expectation, not a law, but keeping most of a batch means
the bar slipped, and padding a keep-list to hit a number is the failure this filter exists to
prevent. Keeping zero is a normal outcome.

## The dispatch block — paste this into every agent you launch

**A worker inherits none of this file.** The orchestrator reads the channels and the filter; the
worker gets what the brief says and nothing else, so the method has to travel with the work. This is
the whole of "give the agents the search patterns": not an index of the corpus — the corpus grows
most days and an index rots while `grep -n` stays current by construction — but the *method*, handed
over per dispatch. Paste it verbatim, fill the four slots, change nothing else.

> **Tool affirmation.** You have full tool access (Read, Grep, Bash, WebSearch/WebFetch, silver).
> Nothing below restricts your *inputs*. Do NOT answer from memory — open and read the source first.
>
> **Enumerate live, never from a remembered list.** `ls` and `grep` your assigned folders *this run*;
> they grow. Do not build or consult an index.
>
> **Burst the query before running it.** Write 5–8 differently-worded variants first: the literal
> term, its aliases, its verb form, the phrasing a *speaker* would use, its failure mode, its
> opposite. One `grep -il <topic>` under-retrieves prose by construction — a file about "the top
> navigation" is named `header.tsx`.
>
> **Rank, then read; never open a file to decide whether to open it.** Score by how many of your
> variants surfaced it, tie-broken by hits per 1,000 lines. Declare the cut in writing.
>
> **Size-triggered reading.** `wc -l` first. ≤2,000 lines: read it whole. Larger: `grep -nE '^#{1,2} '`
> for the heading index, then `sed -n 'A,Bp'` in ≤1,500-line chunks. **Never open a file over
> `<MAX_LINES>` lines.** This one is not style: a worker that opens a 200,000-line transcript stalls
> and returns nothing at all, which costs more than a shallow answer.
>
> **Round two, on the proper nouns the sources actually used — required, not optional.** After your
> first reads, collect every product, person, paper title, config constant and API name the text
> itself named, and `grep -n` those exact strings across the corpus. Say which terms you harvested
> and what they surfaced. This is the one step that finds the file discussing your topic without
> ever using your keyword, and it is why mining is recursive rather than a single sweep.
>
> **The bar, and it is the same bar on disk and on the web.** Primary — the person who did the thing,
> in their own words, not a commentary account summarising them. Non-obvious — not answerable by a
> two-minute search. Load-bearing — it changes the decision in front of you. Cut on sight regardless
> of polish: listicles, SEO "ultimate guide" pages, summaries of summaries, vendor content dressed as
> education, and a credible name on a thin post, which is the most common way noise gets through a
> filter that was working. **Expect to keep a minority.** Returning few or zero is the correct
> outcome when nothing clears; padding to hit a count is the failure this bar exists to prevent.
>
> **Budget: at most `<N>` tool calls**, then return what you have. Stop when a round returns mostly
> files you have already seen.
>
> **Then read your sources against each other, not just one at a time.** Take the two or three that
> bear on the same decision, put them side by side, and write down the claim that follows from them
> **jointly and that none of them states alone**. Return it as a `CONNECTION`: one claim, an `AT` for
> each source it rests on, and one line naming what each contributes. A connection is only real if you
> can say what each source adds and neither states the conclusion — if one of them already says it,
> that is a quote, not a connection. Report at most three; this is the step that produces something
> the corpus does not already contain, and three real ones beat ten restatements.
>
> **Return inline as text, at most `<K>` findings.** Never write a file — the harness forbids worker
> report files and the attempt is wasted. Each finding: a one-sentence CLAIM, ONE verbatim line as
> QUOTE, and `path:LINE` as AT. Every quote is relocated with
> `sed -n '<LINE>p' <path> | grep -Fq -e "$Q"` — one that does not relocate gets the whole finding
> dropped, so copy bytes exactly and use one line only. Any value not inside a quote is `[ASSUMED]`,
> and a number and its causal explanation must come from the same sentence or the explanation goes.
> **"I could not ground this" is an accepted, non-penalised return** — never invent a citation to
> finish tidily.

**Why the connection step exists, and why it is the only "make the agent reason" instruction here.**
Structure that tells a model *how to think* measures inert or worse — a structured rendering of the
same document lost 8.4–27.4 percentage points, and prompt scaffolding recovers ~73% of a *base*
model's gap but only ~7% of a post-trained one. The connection step is not that: it carries
information the model does not have. A model pre-trained on 20,000 relations recalls them at **99%
when they are in context** and scores **"absolutely zero"** on held-out reversals, with fine-tuning
scoring *below chance* — so the implied conclusion genuinely does not exist anywhere until something
writes it down. Reading sources **together** is what puts it in context, and writing it down is what
makes it survive the session. Measured locally: an agent reading note pairs side by side produced
**18 verified novel connections and found six real defects** in hand-written notes, including a
stale cross-reference and two sibling notes making mutually exclusive claims about the same data.
No retriever finds those, because they are not in any single source.

**This is not a graph, and do not build one.** Constructing an explicit knowledge graph as a study
step lost to plain retrieval practice by roughly half the retention (0.45 vs 0.67, *d* = 1.50), and
the initial maps contained *more* ideas than the initial recalls — a better-looking artifact that
worked worse. What retrieval rewards is **cue diagnosticity**, how uniquely a cue picks out one
item, and denser linking hurts it by enlarging the candidate set. Sparse and specific beats dense
and associative: one pointer that uniquely identifies a source beats ten associative links.

Fill `<MAX_LINES>` from the corpus you are pointing it at (5,000 is a safe default over a transcript
library), `<N>` from the confidence band in **compound-v:get-shit-done** stage 2, and `<K>` at about
8 — forty small findings bury the one that mattered.

## Reading the result: demo or production?

The most useful thing recon returns is often *how much less* the thing is than it looked — and the
most dangerous is a demo mistaken for a solution.

The tell is the success criterion. Cognition, reviewing the famous large agent builds — a browser at
200k LOC, a C compiler, a training-script optimizer — noted they *"all share a property most real
software doesn't: a simple, verifiable success criterion."* A compiler tells you it is wrong. A
storyboard-reminder bot does not. So when prior art shows something shipped fast, ask what told them
it worked; if the answer is a test suite the domain handed them for free and your slice has no
equivalent, you have found a technique, not a timeline.

The inverse read is the one that shrinks projects, and it is the more common outcome: an intimidating
capability turns out to be a loop, three tools and some elbow grease, and the person who built it
says so plainly in public. Take that at face value and check it with a spike before you take it as
architecture.

## Red flags

| Smell | What it means |
|---|---|
| Recon finished; the plan grew | The queries asked *how to build*, not *who already built*. Re-run for DELETE. |
| A quote in the plan that came from a search digest | That was a paraphrase. Open the source or drop the claim. |
| The channel-3 pass returned most of what it found | The filter didn't run. A minority survives a real pass. |
| "No prior art exists" after one query burst | Almost never true, and it is the most expensive thing to be wrong about. Try the problem's other name — practitioners rarely use your term for it. |
| Recon ran on every slice | The budget table was skipped. The ~95% slices were supposed to cost nothing. |
| A credential minted or a login automated to reach a source | Stop. **compound-v:agent-security**. The source is not worth it. |
