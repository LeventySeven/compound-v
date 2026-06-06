---
name: product-taste
description: Turns vague UI/UX verdicts into named, fixable properties and catches AI-slop defaults before they ship. Use for any design, polish, animation, latency, copy, or "does this look good?" decision — even a quick gut-check — and whenever an interface feels generic but you can't say why.
---

# Product Taste

Taste is not a gift and it's not subjective — it's a perceptual apparatus you build, and good design has objective properties (designers measurably improve over time; an eight-year-old's output is not interchangeable with a master's). So when something is wrong, the job is to **name which property is violated**, not to say "it feels off." The interface IS the product for almost every user.

As AI makes code and features cheap, *how well it's made* becomes the moat — details, polish, performance, cohesion, opinion. That's the differentiator this skill defends.

## When to use
- Any UI/UX/design/polish/animation/latency/copy decision.
- A "looks good?" / "is this done?" verdict on something visual or interactive.
- An interface feels generic, dead, or off and you can't articulate why.
- **Skip it for:** non-visual backend logic with no felt surface. This is about what the user *feels*.

## Name the property — refuse the vague verdict
*"I like it" / "feels off" / "looks clean" / "looks good"* are not verdicts; they're the absence of one. Rewrite every one into a named, copyable property: **spacing, easing, contrast, hierarchy, latency, copy clarity, motion purpose.** A taste call you can't name, you can't fix or hand off. Useful drills: "If a rival shipped this, would I be impressed or relieved?" "Name the one mechanism that makes this interaction feel alive."

## Slop detector — every default is a decision you didn't make
AI hands you mediocre defaults; the skill is knowing which to override (the load-bearing ones, not all). The slop aesthetic is recognizable — grep your own output for it:
- Uniform rounded corners on everything.
- Gradients that don't match the brand.
- Copy edited to be **inoffensive instead of clear** (rewrite for clarity and opinion — pairs with the `humanizer` skill).
- Layouts grid-perfect but tonally flat.
- Default easing curves; generic empty states.

Each hit: "was this deliberate, or did the tool decide for me?"

## The invisible-details checklist (these are the whole game)
Users can't articulate why one interaction feels alive and another dead, but the difference is specific and copyable. Most builders never notice they're leaving these on defaults:
- Dialogs/popovers scale in from **~0.8, not 0** (0 looks like a glitch; 0.8 feels physical).
- Buttons depress to **~0.96** on press.
- **`tabular-nums`** on timers and numeric columns so they don't reflow as digits change.
- **16px minimum** input font (anything smaller triggers iOS auto-zoom).
- Pause animations/loops when off-screen.
- No dead zones between adjacent list items — full-row hit targets.

## Animation gate — motion has a job or it's noise
Decoration kills UX. Run every motion through six checks; any fail → cut or fix:
1. Natural (not robotic).
2. Right speed.
3. **Clear purpose — it communicates a state change.**
4. 60fps.
5. **Interruptible mid-flight** (a spring that argues with the user when they act feels like the app fighting them).
6. Accessible (respects reduced-motion).

Motion added "because it looks nice," with no state change to communicate, fails #3 → it's decoration → cut it.

## Latency gates — perceived speed is taste work, not an infra afterthought
Hold the perceptual cliffs:
- **< 200ms** feels instant — target for interactive feedback.
- **> 500ms** feels slow — never let a core interaction cross this *perceived* without a mask.
- **< 50ms** is the bar the best hold for every interaction (Linear); Cursor's tab completion lives at ~260ms — fast enough, deliberately measured.

The levers are perceived-speed work — optimistic updates, skeleton states, streaming — applied *before* you reach for backend speed. "We'll optimize latency later, it's infra" is the wrong call; bake the masks in now.

## Constraints generate taste — remove options, don't add them
Fewer, more opinionated primitives produce more coherence than infinite flexibility. A design system should *remove* choices (Teenage Engineering's fixed palettes as a generative force; Linear collapsed 98 color variables → 3). Default to removing; justify every new variable/flag/token against the coherence it costs. The best design is opinionated — designed for specific users, not everyone. Spec is the floor, not the ceiling.

## Start from the experience, work backward to the tech
Lead with what the user *feels*, then work back to the architecture — never the reverse (the slop trap is tech-first: grid-perfect, tonally dead). Decline to spec prompts/models/plumbing before the target experience is named. Reduce scope to raise quality: build fewer things excellently.

## Refusal templates
- **Vague verdict:** "I can't ship 'looks good' — which property? The spacing reads cramped at the card edges / the easing is the default ease-in-out / the primary action has no hierarchy. Pick the one to fix."
- **Slop:** "These are tool defaults, not decisions — uniform 8px radius everywhere, an off-brand gradient, hedged copy. Which were deliberate? Let's override the load-bearing ones."
- **Decorative motion:** "This animation doesn't communicate a state change and isn't interruptible. It's decoration — cut it or give it a job."
- **Latency punt:** "Latency is a design decision. This crosses 500ms perceived — add an optimistic update / skeleton now, don't defer it to 'infra later.'"
