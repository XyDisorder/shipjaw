# Design constraints (anti AI-slop)

> Read at scaffold when UI ships in v1, and whenever `shipjaw-ask` touches
> marketing/landing or primary product UI. Keep product `design-brief.md`
> as the brand source; this file is the **hard floor** agents must not
> violate even with empty brief.

## Composition (first viewport)

- One composition — not a dashboard dump (unless the product *is* a dashboard).
- Brand first: product name is a hero-level signal, not only nav text.
- Hero budget: brand + one headline + one short support line + one CTA group
  + one dominant visual. No stats strips, schedules, address blocks, or
  promo clusters in the first viewport.
- Full-bleed hero on landing/promotional surfaces by default — not inset
  cards, side panels, or collage tiles unless the brief requires it.
- No detached labels, floating badges, or promo stickers on hero media.

## Structure

- One job per section: one purpose, one headline, usually one short line.
- Default: **no cards**. Cards only when they contain a real interaction.
  If removing border/shadow/radius doesn't hurt understanding, remove them.
- Avoid pill clusters, icon rows, boxed promos, and competing text blocks.

## Visual

- Expressive fonts — avoid default stacks (Inter, Roboto, Arial, system-only).
- Background: not flat single-color; use gradient, image, or subtle pattern
  for atmosphere. Still prefer a **real** visual (product/place/context)
  over abstract decoration as the main idea.
- Pick a clear direction and CSS variables. **Avoid** these AI-default looks:
  1. purple-on-white / purple→indigo gradients
  2. warm cream (~#F4F1EA) + high-contrast serif + terracotta accent
  3. broadsheet: hairline rules, zero radius, dense newspaper columns
- Also avoid as defaults: dark-mode fetish, glow effects, rounded-full
  pill spam, multi-layer shadows, emoji decoration.

## Motion

- Ship 2–3 intentional motions for visually led surfaces.
- Motion for hierarchy/presence, not noise. Respect `prefers-reduced-motion`.

## A11y floor (with testing-and-ci)

- Keyboard reach + visible focus on primary controls.
- Axe: zero critical/serious on critical journeys.

## When brief conflicts

Follow `product/design-brief.md` and record the deviation in
`architecture.md` / decisions — don't silently revert to AI-default chrome.
