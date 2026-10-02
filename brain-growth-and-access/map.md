# Brain Growth and Access

## Destination

Reach decision-ready designs for handling larger and more varied inputs, keeping published knowledge and search reliable as the Brain grows, and making the Brain easier for people and agents to use. The map is complete when the remaining implementation work can be handed off as focused specs or tickets.

## Notes

Use the domain vocabulary in `CONTEXT.md`, especially `Artifact`, `Classification Decision`, `Knowledge Projection`, `Publication`, `Knowledge Variant`, `Area`, and `Catalog`. Preserve deterministic authorization and atomic Publication behavior. This map remains an exploration map; the user explicitly authorized implementation of ticket 01, while the other topics remain exploratory.

Related work: the LLM classification maps define the current classification contract and JEV-compatible typed-decision seam. The audience-aware publication map already records Artifact semantic profiles and targeted placement; semantic-profile generation was implemented in application commits `13920b3` and `eae2688`. Reconcile with those efforts instead of reopening settled decisions.

## Decisions so far

- [01: Analyze Artifacts before typed classification](issues/01-combine-semantic-profiling-and-classification.md) is resolved. The classifier module runs structured Artifact Analysis, feeds its compact summary to a typed classification judgment, and retries uncertain/abstaining results once with exact source excerpts. It also derives the Installation-shared semantic profile from the analysis response, without another profile LLM call.
- [02: Understand and preprocess non-text Artifacts](issues/02-understand-and-preprocess-non-text-artifacts.md) is resolved. Use a format-neutral hybrid processing extension point; keep the original payload and one direct or processor-produced Text representation with the Artifact in the Realm, recording the process category used.
- [03: Handle documents beyond model context](issues/03-handle-documents-beyond-model-context.md) is resolved. Use bounded, recursive section processing to build a layered source-linked Artifact overview; cache it locally and reuse it across classification changes while rerunning Realm-specific evidence analysis. Configure per-call usable context with model selection and cap total per-document work separately; incomplete processing is resumable and cannot finalize classification.
- [Isolate Intake and worker failures](issues/04-isolate-intake-and-worker-failures.md) is resolved. Processing failures stay visible per item, and delayed retries do not block eligible work; retry policy distinguishes failures to connect from provider errors and connected timeouts.
- [Configure provider parallelism](issues/05-configure-provider-parallelism.md) is resolved. Provider-scoped concurrency is gated by a shared in-memory dispatcher with a default of 1 and a current maximum of 2; durable work queues retain retry and restart recovery.
- [Retire obsolete Publication data](issues/06-retire-obsolete-publication-data.md) is resolved. Keep superseded revisions only for a configurable five-minute in-flight read grace; all reads remain gated by the selected Publication's safety-drift availability, and older revisions are not rollback targets.

## Not yet specified

- Which capabilities should be prioritized for implementation, and whether any need to be split into separately deliverable efforts.
- How much of the web UI should be a read-only browser versus an alternate Intake surface, including the supported actions and local access model.

## Out of scope

- Changing the established authorization model or making generated Profiles, Catalog data, or Knowledge Projections canonical Realm data.
- Implementing map capabilities beyond the specifically authorized ticket 01.
