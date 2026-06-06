---
name: searching-patterns
description: Look up the canonical, current way to do something before implementing it — drive real docs and GitHub pages with the agent-browser CLI, then extract the right pattern and its matching anti-pattern. Use when about to write an unfamiliar API, a non-obvious or security-sensitive pattern, or pick a library/API shape; when unsure how a framework wants something done; or to confirm a best practice during a code review. Skip it for trivial, well-known code.
---

# Searching Patterns

Before writing something you're not sure about, find how it's *actually* done now — then carry back both the canonical pattern and the anti-pattern it replaces. Models confidently generate plausible-but-wrong or outdated API usage; a 60-second lookup against real sources prevents a class of bugs and a round of review churn.

## When to search (and when not)

Search when getting it wrong is likely or expensive:

- **Unfamiliar API or library** — you haven't used this exact version, or you're choosing between libraries and need to see the real API shape.
- **Non-obvious pattern** — concurrency, caching, auth flows, retries, framework lifecycle hooks: areas where the wrong-but-plausible version compiles and then misbehaves.
- **Security-sensitive surface** — anything touching authn/authz, secrets, deserialization, SSRF, path handling, SQL. The cost of the wrong pattern here is a vulnerability, not a nit.
- **Confirming a best practice** during review — when you flag "this isn't how X is done," verify it instead of asserting it.

Don't search for trivial, well-trodden code you'd write correctly from memory (a loop, a standard library call, basic string handling). The lookup is overhead; spend it only where it buys correctness. This is the same instinct as catching an agent's architectural dead end early rather than nitpicking lines.

## How: drive real pages with agent-browser

`agent-browser` is installed. It drives real docs and GitHub pages deterministically via the accessibility tree (stable refs, not screen-scraping), so you read the *current* source/docs rather than recalling stale training data. Use `--json` when you want to parse output; use a `--session` to carry state across a multi-page lookup.

```bash
agent-browser open <url>            # launch + navigate (e.g. the docs page or a GitHub file)
agent-browser snapshot              # accessibility tree with refs
agent-browser snapshot -i           # interactive elements only (links, inputs, buttons)
agent-browser snapshot --json       # machine-readable, for parsing
agent-browser get text <sel>        # extract text content from a region
agent-browser get html <sel>        # innerHTML when structure matters
agent-browser find text <text> <action>          # locate by visible text
agent-browser find role <role> <action> [value]  # locate by ARIA role
agent-browser --session <name> ...  # isolated, reusable session across pages
```

A typical lookup: `open` the official docs page or the canonical example file in the upstream GitHub repo → `snapshot` to orient → `get text` on the relevant section → if it's spread across pages, reuse a `--session` and `find`/`open` your way through. Prefer the library's own repo and docs over blog posts and forum answers — primary sources outrank secondary ones. For private/authed pages, `agent-browser` won't help; use `gh` or an authenticated tool instead.

(Plain web search or `WebFetch` is fine for a quick fact. Reach for `agent-browser` when you need to *navigate* — follow links, read a specific file in a repo, page through multi-section docs — rather than read one static URL.)

## What to extract: pattern + anti-pattern + why

Don't just copy the snippet. A lookup is only useful if it captures three things:

1. **The canonical pattern** — the current, idiomatic way the library/framework intends it, with the version it applies to (APIs drift; note what you're targeting).
2. **The matching anti-pattern** — the wrong-but-tempting version it replaces, and how to recognize it. This is what stops the same mistake recurring; the canonical pattern alone doesn't inoculate against the trap.
3. **Why** — one line on what the right way buys (avoids a race, preserves the cache, closes an injection path). The reason generalizes to cases the example didn't cover.

Then *use* both:

- **Feed it into the plan.** Write the canonical pattern (with its source) into the implementation plan so the implementer codes from the real shape, not a guess.
- **Feed it into the review.** Hand the anti-pattern to the pattern check during recheck (compound-v:recheck) — "does the diff contain the anti-pattern we found?" turns a vague best-practice opinion into a concrete, checkable test.

## Tool design is an interface (ACI)

When the thing you're building is itself a *tool* for an agent — an MCP tool, a CLI an agent will call, a function exposed to an LLM — apply the same care here as you would to a human UI. The agent is a non-deterministic caller that will call the wrong tool, with the wrong args, in the wrong order, unless the interface prevents it. So when you look up or design a tool's shape:

- **Poka-yoke the arguments** — make wrong calls hard to express. Requiring **absolute paths** instead of relative ones eliminated a whole error class on real benchmarks. Constrain types and enums so invalid states can't be passed.
- **Minimal overlap.** If a human engineer can't say which of two tools to use in a situation, neither can the agent. Curate a small set of distinct tools; consolidate (one `search_x` that does the work) rather than exposing every low-level endpoint.
- **Describe it like a docstring for a junior.** State what it does, when to use it, when *not* to, and what it returns. Return high-signal semantic fields (names, types) over cryptic IDs (`uuid`, `mime_type`). Small refinements to a tool's description yield outsized improvements in how reliably it's used.
