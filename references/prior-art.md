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
