---
name: searching-patterns
description: Look up the canonical pattern and its matching anti-pattern from primary sources before writing unfamiliar or security-sensitive code. Use when about to code a third-party API, endpoint, or price from a spec, PRD, ticket, or memory rather than its current docs; when writing an unfamiliar API or library, a non-obvious or security-sensitive pattern (auth, secrets, retries, concurrency, SQL, path handling), or picking a library/API shape; when unsure how a framework wants something done or which major version you are on; or to confirm a best practice during a code review — even if nobody asks. Skip it for trivial, well-known code.
---

# Searching Patterns

Before writing something you're not sure about, find how it's *actually* done now — then carry back both the canonical pattern and the anti-pattern it replaces. Models confidently generate plausible-but-wrong or outdated API usage; a 60-second lookup against primary sources prevents a class of bugs and a round of review churn.

## When to search (and when not)

Search when getting it wrong is likely or expensive:

- **Unfamiliar API or library** — you haven't used this exact version, or you're choosing between libraries and need to see the real API shape.
- **Any third-party SaaS/API client** — for pricing, endpoints, response shape, or auth headers, fetch the *current official* docs at implementation time. A prior spec/PRD/design-doc or an earlier memory is an **input, never the authoritative reference** — a stale internal spec is a trap masquerading as a source, and it'll send you to confidently code last quarter's endpoint.
- **Non-obvious pattern** — concurrency, caching, auth flows, retries, framework lifecycle hooks: areas where the wrong-but-plausible version compiles and then misbehaves.
- **Security-sensitive surface** — anything touching authn/authz, secrets, deserialization, SSRF, path handling, SQL. The cost of the wrong pattern here is a vulnerability, not a nit.
- **Confirming a best practice** during review — when you flag "this isn't how X is done," verify it instead of asserting it.

Don't search for trivial, well-trodden code you'd write correctly from memory (a loop, a standard library call, basic string handling). The lookup is overhead; spend it only where it buys correctness.

**And stop when you have the answer, not when the sources are exhausted.** The stop condition is: *you can name the pattern and its anti-pattern*, or *two independent primary sources converge on the same one*. Everything past that is restatement, and restatement is where a lookup quietly turns into a research project — a broad question over a good corpus returns mostly the same finding in different words, so it is the **question**, not the number of sources, that decides what a lookup costs. Ask one question that names the decision it will settle; if you cannot state it in a sentence, you are not ready to search yet. This is the same instinct as catching an agent's architectural dead end early rather than nitpicking lines.

## How: read the primary source

The default tools need zero setup. Reach for the heaviest one that fits, lightest first:

- **Check the local convention first.** If the repo already has an established shape for this — a house wrapper, an AGENTS.md/CLAUDE.md rule, a pattern in neighboring files — that overrides the external canonical one. Match the local shape; don't import a clashing "correct" pattern. Only reach outward when the repo has no precedent. Preserve an existing design system's established patterns rather than replacing them.
- **The copy you actually installed** — `node_modules/<lib>` and its `.d.ts`, `site-packages/<pkg>`, the vendored source. It *is* the API contract, it is version-exact by construction (a lockfile-vs-docs mismatch is impossible), and it costs one `grep` with no network — which is also why it is the only rung that survives a sandboxed run. Read it first when the question is a signature, a parameter, an enum, an error class or a default; go outward when the question is *why* or how the pieces are meant to compose, which types don't carry.
- **A docs-MCP server** (context7-style `resolve-library-id` + `query-docs`), *when one is available* — the lightest step for library/framework docs: it returns the current, version-pinned API surface without you hunting a URL. Prefer it ahead of `WebSearch`/`WebFetch`; fall through to those when no such server is wired up.
- **`WebSearch`** — find the current canonical page when you don't have the URL ("`<lib> <version>` retry middleware docs").
- **`WebFetch`** — read one known page (a docs section, a guide). The common case.
- **`gh`** — read the upstream repo directly: `gh api` for file contents, releases, or the `CHANGELOG`; `gh search code` to see how the library itself uses a thing. This is how you reach the *real* source and private/authed pages — pin it to the tag in your lockfile, because the default branch is HEAD, not the version you're running.

Prefer the library's own repo and docs over blog posts and forum answers — primary sources outrank secondary ones. **Pin the version**: default docs often render an older major than you're on, so read the docs for the version in your lockfile and note which version the pattern applies to. And don't stop at the first hit — the top search result is often a stale major or an SEO blog, so run a second query with different wording and prefer the result that matches your lockfile version. (Look past the first seemingly relevant result; run multiple searches with different wording, and include version numbers in technical queries.)

When the thing you're implementing ships an **official conformance suite** — a protocol, a wire format, a standard's test vectors — that suite *is* the primary source: precise, executable, and it doesn't drift the way prose docs do. Point the implementer at it and write code until those tests pass (e.g. WebAssembly's spec test suite).

### Know the canonical exemplar for your stack

For a stack you hit repeatedly, skip the discovery and go straight to its **canonical exemplar** — the reference the community already agrees on. Only two kinds qualify: the **maintainer's own** docs/examples (they track the current version; a blog doesn't), or a **large, actively-maintained real-world codebase** that uses the stack in anger.

| Stack | Go straight to |
|---|---|
| React / Next.js | Vercel's official **`vercel-labs/agent-skills`** → its `react-best-practices` skill (70 perf rules from Vercel Engineering, same `SKILL.md` format as this kit) + `nextjs.org/docs` |
| tRPC | `trpc.io/docs` for the API; `calcom/cal.com` for a large real Next + tRPC + Prisma app (read its `packages/trpc` end-to-end) |
| FastAPI (Python) | `fastapi.tiangolo.com` — the official docs *are* the reference, examples included |
| DOM / React testing | `testing-library.com` — the canonical query/interaction patterns (pairs with compound-v:test-driven-development) |

### The same table, one level up: shapes, not stacks

The rows above answer *how is this API used*. The expensive question is one level up — *what shape should this be* — and it is where an agent is weakest: it has read more code than any of us and carries none of the scar tissue, so it reaches for the architecture rather than for the two facts that collapse it. A **shape** is the architecture an experienced person would reach for, and it is only worth writing down paired with its **trap**, because the trap is what the scar tissue actually is.

| Shape | Reach for it when | Its trap |
|---|---|---|
| **Mirror + durable cursor.** Keep a local copy of the third party's data, advanced by one cursor per account that moves only after a whole page-loop succeeds; query the mirror, not the API | "one API round trip per rule per record" — any integration read many times | **The cursor expires**, so a full-resync path is a day-one requirement, not an incident runbook. And an event-type filter *filters, it does not project*: omit the delete event and the mirror never learns about deletions and diverges forever, with no error anywhere |
| **Idempotency key on a domain tuple.** Mint the key, commit it to the domain row *before* the outbound call, and put it somewhere the provider can be asked about later | any at-least-once retry that touches a third party — charge, send, publish, provision | Keying on the **job id** looks right and absorbs nothing: a re-dispatch mints a new one. It must be a domain tuple under a unique index. And the window between "they accepted" and "we committed" is never closed, only narrowed — what closes it is a *probe on the next attempt*, which means the key has to be queryable back out of the provider |
| **Append-only with a validity interval.** Never overwrite; append a new value with its interval and the actor, and define "current" as the projection where the interval is open | anything you will later be asked "who set this, when, what was it before" — CRM fields, agent memory, any column both a human and a job write | **There is no delete, and deleting the source does not delete what was derived from it** — the extracted relations outlive the data they came from, so erasure and offboarding become a second subsystem nobody budgeted. Index the open-interval predicate on day one or every read scans history |
| **Desired-state reconciler.** Store what *should* be true; on a tick, read what *is*, classify absent / identical / drifted, act only on the difference | you notice you are writing a `create` path and an `update` path that are the same code | The loop **has no memory of intent**, so any out-of-band action is indistinguishable from drift and gets silently reverted on the next tick. Every reconciler grows a second piece of state to fix this — a cooldown, a "this write was mine" flag — and each is a new bug surface. The tick interval is your convergence latency *and* your load on whatever you poll, and it is almost never made configurable |
| **Frozen prefix, variance at the tail.** Freeze the system prompt and tool definitions; append everything that changes — the time, live state, task status — as a message at the end | any agent loop where cost or latency matters, which is any loop past a handful of turns | Putting the current date or a flag in the system prompt costs nothing on day one and then **invalidates the whole cache on every call**, so the bill scales with the prefix rather than with the new tokens. The tidy-up you would reach for later is the thing that breaks it |
| **One central change, auto-merged everywhere.** Open the same mechanical change as a PR against every repo that needs it and merge each on green CI, instead of asking each owner to do it by hand | "hundreds of teams doing the same operation by hand" — a version bump, an API migration across an estate | **The human reviewer you just deleted was your actual test suite.** Owners had been in the loop on every merge for years, which let them stay quietly sloppy about test automation because a person always eyeballed the diff. The instant you auto-merge, every gap that review was silently covering becomes a production defect |
| **Read-only fan-out, single-threaded writes.** Parallelise the reading and the judging; keep every write on one thread | you want parallel speed on one codebase | Parallel writers make conflicting implicit decisions — style, edge cases, patterns — and reconciling them at merge is the cost you moved, not the cost you removed |
| **A check the author cannot see.** Apply the grading check from outside the workspace, after the run | the same agent writes both the code and its test | A check the author can read is a check the author can satisfy. The failure is silent: everything passes and nothing was measured |

**A recon earns a row here only when the shape will recur**, and most will not — which is the same discipline the stack table runs on, and the reason both stay short enough to stay true. Do not turn this into an index of the corpus: that has been tried and refused, because an index over a growing source set rots while `grep -n` over it is current by construction, and a production findings-cache measured zero hits in 133 attempts. A dozen curated pairs beat a thousand retrievable ones.

Most stacks have no row here and that is the rule working, not a gap — the "primary source over a blog" rule above covers the long tail. It deliberately excludes the contested layers (state management, auth, the ORM wars, any "best-practices" listicle): no single right answer there, so a named pick is just an opinion aging into wrong — read the primary sources and say the choice is contested rather than asserting one. And these are **starting points, not pins** — still read the version in your lockfile, because even the canonical exemplar moves.

### When you must navigate: drive a real browser

`WebFetch` reads one static URL; it can't drive a JS-rendered site, page through multi-section docs behind interaction, or operate a repo UI. For that, reach for whatever **browser-automation tool your environment provides** — prefer one that works through the accessibility tree (stable element refs) over pixel-scraping.

The loop is snapshot-driven and tool-agnostic: **open** the page → **snapshot** the interactive elements (each gets a fresh ref) → **act** on a ref from *this* snapshot → **re-snapshot after anything that navigates or re-renders**, because refs go stale the moment the page changes. A typical lookup: open the docs or the canonical example in the upstream repo, snapshot to orient, read the section, then page through multi-section docs by re-snapshotting after each navigation.

## What to extract: pattern + anti-pattern + why

Don't just copy the snippet. A lookup is only useful if it captures three things:

1. **The canonical pattern** — the current, idiomatic way the library/framework intends it, with the version it applies to. APIs drift across majors, and default docs often render an *older* major than you're on — pin the lookup to the version in your lockfile and record it, so the implementer doesn't code the v2 shape against a v4 dependency.
2. **The matching anti-pattern** — the wrong-but-tempting version it replaces, and how to recognize it. This is what stops the same mistake recurring; the canonical pattern alone doesn't inoculate against the trap.
3. **Why** — one line on what the right way buys (avoids a race, preserves the cache, closes an injection path). The reason generalizes to cases the example didn't cover.

Then *use* both:

- **Feed it into the plan.** Write the canonical pattern (with its source) into the implementation plan so the implementer codes from the real shape, not a guess.
- **Feed it into the review.** Hand the anti-pattern to compound-v:recheck as a *named, checkable* item, not a vibe. Worked end-to-end: you looked up SQL access in the **v4.2** docs (the version in your lockfile, not whatever default the docs rendered) → found the trap: a string-interpolated query is an injection hole, and v4.2's canonical form is a parameterized query → record both with the version → that becomes a concrete recheck assertion — "does the diff build any query by string interpolation?" — which turns a vague best-practice opinion into a test the review can actually run *against the right API*.

**A different question, one level up.** This skill asks *how is this used correctly* at the moment you write the line, and hands back a pattern. Asking *has someone already solved this whole slice, and what does that let me delete* — before a design exists, with the answer measured in work removed rather than in a snippet — is stage 2 of **compound-v:get-shit-done**, and its method (budgeting research by uncertainty, the practitioner/X channel and its filter) is in **references/prior-art.md**. Same sources, different output. Use this one when you are about to type; use that one when you are about to commit to building something.

Designing your own tool's API (an MCP tool, a CLI an agent will call)? That's a different problem — see compound-v:designing-agents for the agent-computer-interface rules.
