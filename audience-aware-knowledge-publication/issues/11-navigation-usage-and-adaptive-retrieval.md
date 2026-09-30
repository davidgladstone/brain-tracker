# Add Navigation usage and adaptive retrieval

Type: task
Status: open
Labels: wayfinding:task, ready-for-agent

**Blocked by:** 10

## What to build

Record Installation-local, Audience-scoped Navigation usage and use decayed
access frequency to improve retrieval ranking and bounded Dreaming decisions.

Usage is an optimization signal only. It must never grant access, alter
provenance or coverage, or change the factual content of a Knowledge Variant.

## Requirements

- Record successful Area and Knowledge Variant retrieval events without
  retaining raw queries, source text, or unnecessary identity data.
- Scope measurements by Audience and navigation target; do not aggregate
  unrelated Audience usage into a shared publication decision.
- Store usage as rebuildable, time-bucketed derived state with configurable
  decay and retention.
- Use usage to improve search ranking, sibling ordering, bounded link
  promotion, and retrieval-cost estimates.
- Use meaningful frequency or recency threshold crossings as deterministic
  seeds for partial Dreaming; do not reorganize on every access.
- Add minimum-evidence, hysteresis, cooldown, and maximum-change rules to
  prevent navigation thrashing.
- Preserve semantic Area boundaries unless stable usage evidence justifies a
  bounded structural reorganization.
- Keep usage separate from Audience authorization, Artifact semantic profiles,
  Variant provenance, and Realm canonical history.

## Verification

- Usage from one Audience cannot change another Audience's projection.
- A single access does not trigger Dreaming or reorder the publication.
- Stable high-frequency access can produce a bounded promotion or ranking
  change after the configured threshold is crossed.
- Decay allows old popularity to lose influence.
- Usage state can be deleted or rebuilt without affecting canonical data,
  authorization, provenance, or publication validity.
