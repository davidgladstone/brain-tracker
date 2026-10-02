# Brain Growth and Access

## Destination

Reach decision-ready designs for handling larger and more varied inputs, keeping published knowledge and search reliable as the Brain grows, and making the Brain easier for people and agents to use. The map is complete when the remaining implementation work can be handed off as focused specs or tickets.

## Notes

Use the domain vocabulary in `CONTEXT.md`, especially `Artifact`, `Classification Decision`, `Knowledge Projection`, `Publication`, `Knowledge Variant`, `Area`, and `Catalog`. Preserve deterministic authorization and atomic Publication behavior. This map remains an exploration map; the user explicitly authorized implementation of ticket 01, while the other topics remain exploratory.

Related work: the LLM classification maps define the current classification contract and JEV-compatible typed-decision seam. The audience-aware publication map already records Artifact semantic profiles and targeted placement; semantic-profile generation was implemented in application commits `13920b3` and `eae2688`. Reconcile with those efforts instead of reopening settled decisions.

## Decisions so far

- [01: Analyze Artifacts before typed classification](issues/01-combine-semantic-profiling-and-classification.md) is resolved. The classifier module runs structured Artifact Analysis, feeds its compact summary to a typed classification judgment, and retries uncertain/abstaining results once with exact source excerpts. It also derives the Installation-shared semantic profile from the analysis response, without another profile LLM call.
- [02: Understand and preprocess non-text Artifacts](issues/02-understand-and-preprocess-non-text-artifacts.md) is resolved. Use a format-neutral hybrid processing extension point; keep the original payload and one direct or processor-produced Text representation with the Artifact in the Realm, recording the process category used.

## Not yet specified

- Which capabilities should be prioritized for implementation, and whether any need to be split into separately deliverable efforts.
- The retention and cleanup policy that should follow an inventory of what currently duplicates data across Publications.
- How much of the web UI should be a read-only browser versus an alternate Intake surface, including the supported actions and local access model.

## Out of scope

- Changing the established authorization model or making generated Profiles, Catalog data, or Knowledge Projections canonical Realm data.
- Implementing map capabilities beyond the specifically authorized ticket 01.
