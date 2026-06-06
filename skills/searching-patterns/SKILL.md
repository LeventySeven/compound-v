---
name: searching-patterns
description: Look up the canonical pattern and its matching anti-pattern from primary sources before writing unfamiliar or security-sensitive code, then feed both forward into the plan and the review. Use when about to write an unfamiliar API, a non-obvious or security-sensitive pattern, or pick a library/API shape; when unsure how a framework wants something done; or to confirm a best practice during a code review. Skip it for trivial, well-known code.
---

# Searching Patterns

Before writing something you're not sure about, find how it's *actually* done now — then carry back both the canonical pattern and the anti-pattern it replaces. Models confidently generate plausible-but-wrong or outdated API usage; a 60-second lookup against primary sources prevents a class of bugs and a round of review churn.

## When to search (and when not)

Search when getting it wrong is likely or expensive:

- **Unfamiliar API or library** — you haven't used this exact version, or you're choosing between libraries and need to see the real API shape.
- **Non-obvious pattern** — concurrency, caching, auth flows, retries, framework lifecycle hooks: areas where the wrong-but-plausible version compiles and then misbehaves.
- **Security-sensitive surface** — anything touching authn/authz, secrets, deserialization, SSRF, path handling, SQL. The cost of the wrong pattern here is a vulnerability, not a nit.
- **Confirming a best practice** during review — when you flag "this isn't how X is done," verify it instead of asserting it.

Don't search for trivial, well-trodden code you'd write correctly from memory (a loop, a standard library call, basic string handling). The lookup is overhead; spend it only where it buys correctness. This is the same instinct as catching an agent's architectural dead end early rather than nitpicking lines.

## How: read the primary source

The default tools need zero setup. Reach for the heaviest one that fits, lightest first:

- **`WebSearch`** — find the current canonical page when you don't have the URL ("`<lib> <version>` retry middleware docs").
- **`WebFetch`** — read one known page (a docs section, a guide). The common case.
- **`gh`** — read the upstream repo directly: `gh api` for file contents, releases, or the `CHANGELOG`; `gh search code` to see how the library itself uses a thing. This is how you reach the *real* source and private/authed pages.

Prefer the library's own repo and docs over blog posts and forum answers — primary sources outrank secondary ones. **Pin the version**: default docs often render an older major than you're on, so read the docs for the version in your lockfile and note which version the pattern applies to.

### When you must navigate: agent-browser (optional)

`WebFetch` reads one static URL; it can't drive a JS-rendered site, page through multi-section docs behind interaction, or operate a repo UI. For that, `agent-browser` drives a real browser deterministically through the accessibility tree (stable refs, not pixel-scraping). It is **not bundled with this kit** — install once, pinned: `npm i -g agent-browser@0.27.0` (the ref-loop below assumes that version's snapshot behavior; bump only after re-verifying it).

The core loop is snapshot-driven: refs (`@e1`, `@e2`, …) are assigned fresh per snapshot and go stale the moment the page changes, so re-snapshot after anything that navigates or re-renders.

```bash
agent-browser open <url>            # 1. navigate
agent-browser snapshot -i           # 2. interactive elements, each tagged @eN
agent-browser click @e3             # 3. act on a ref from THIS snapshot
agent-browser snapshot -i           # 4. re-snapshot — refs from step 2 are now stale
agent-browser get text @e5          # extract a region's text (get html @e5 for structure)
agent-browser find text <text> <action>   # locate by visible text (find role <role> … for ARIA)
```

A typical lookup: `open` the docs or the canonical example file in the upstream repo → `snapshot -i` to orient → `get text` the section → if it spans pages, `find`/`open` your way through, re-snapshotting after each navigation. (`--session <name>` keeps an isolated reusable session across a multi-page lookup; `snapshot --json` emits machine-readable output.)

## What to extract: pattern + anti-pattern + why

Don't just copy the snippet. A lookup is only useful if it captures three things:

1. **The canonical pattern** — the current, idiomatic way the library/framework intends it, with the version it applies to. APIs drift across majors, and default docs often render an *older* major than you're on — pin the lookup to the version in your lockfile and record it, so the implementer doesn't code the v2 shape against a v4 dependency.
2. **The matching anti-pattern** — the wrong-but-tempting version it replaces, and how to recognize it. This is what stops the same mistake recurring; the canonical pattern alone doesn't inoculate against the trap.
3. **Why** — one line on what the right way buys (avoids a race, preserves the cache, closes an injection path). The reason generalizes to cases the example didn't cover.

Then *use* both:

- **Feed it into the plan.** Write the canonical pattern (with its source) into the implementation plan so the implementer codes from the real shape, not a guess.
- **Feed it into the review.** Hand the anti-pattern to compound-v:recheck as a *named, checkable* item, not a vibe. Worked end-to-end: you looked up SQL access in the **v4.2** docs (the version in your lockfile, not whatever default the docs rendered) → found the trap: a string-interpolated query is an injection hole, and v4.2's canonical form is a parameterized query → record both with the version → that becomes a concrete recheck assertion — "does the diff build any query by string interpolation?" — which turns a vague best-practice opinion into a test the review can actually run *against the right API*.

Designing your own tool's API (an MCP tool, a CLI an agent will call)? That's a different problem — see compound-v:designing-agents for the agent-computer-interface rules.
