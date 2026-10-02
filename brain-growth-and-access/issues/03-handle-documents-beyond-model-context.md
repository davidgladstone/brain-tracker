# Handle documents beyond model context

Type: grilling
Status: resolved
Claimed by: Codex

## Question

How should Brain process a document whose extracted or native content exceeds a provider's usable context? Compare chunking and staged synthesis with retrieval of relevant sections or other bounded strategies. Define how the approach preserves document-wide context, evidence locations, uncertainty, and complete Artifact coverage without making per-chunk model calls unbounded.

## Comments

- **Resolution:** Process oversized Artifact Text with bounded, section-aware recursive summarization. Every section contributes to a layered Artifact overview containing a whole-document synopsis, section summaries, and source locations; the overview guides analysis and retrieval but does not replace canonical Text or exact evidence. Generate and cache the content-focused overview on demand in the Installation, keyed to the source Text and processing/model versions, so Realm classification changes can reuse it. Realm-specific classification analysis and exact evidence checks still use the current rules and may retrieve source Text again. Each LLM call must fit the usable input/output budget declared in model selection/configuration, while a separate per-document aggregate work budget bounds total calls/tokens. If that aggregate cap is reached, preserve progress as incomplete and allow resume/retry with a higher cap; never finalize classification from partial coverage.