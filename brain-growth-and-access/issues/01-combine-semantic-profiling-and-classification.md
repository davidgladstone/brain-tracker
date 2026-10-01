# Analyze Artifacts before typed classification

Type: grilling
Status: resolved

## Question

Should Brain add a classification-aware Artifact Analysis stage that produces a concise summary and useful evidence in one LLM call, followed by a cheaper Realm-specific JEV-style classification judgment? Decide what evidence the second call may rely on, how analysis is scoped and invalidated when Realm classification inputs change, how uncertainty or missing details are handled, and how both provider capabilities and deterministic classification authority are preserved.

## Comments

- **Decision:** implement two ordinary LLM stages. Artifact Analysis receives the source plus the current Realm's classification definitions and emits structured summary, source-general semantic profile terms, and exact source quotes grouped by Controlled Tag. A typed JEV-style classification judgment consumes the compact summary; if it abstains or any tag is uncertain, the module retries once with validated source excerpts. Existing policy code remains authoritative for applying proposals.
- The Classification Module owns the complete operation behind the existing runtime interface. Provider-specific prompt/output strategies, retries, analysis caching, profile persistence, and the evidence fallback are private to the module. Model and profile configuration can be overridden separately for analysis and classification; the initial structured analysis profile is `structured-analysis-v1`.
- Analysis cache identity includes Artifact content, guidance/version, classification definitions, and analysis profile identity. Cached semantic profiles remain Installation-local and source-general, shared across Realms and Audiences per ADR 0013. A classifier context change causes a new analysis result without changing the shared profile for unchanged content.
- The normal uncached path uses two LLM calls, while deriving the semantic profile from Artifact Analysis avoids a third profile-generation call. Large-document extraction, binary preprocessing, broader concurrency controls, old-publication cleanup, SQLite synchronization, the local web UI, and MCP discoverability remain separate exploration topics.
- Implemented in the application workspace; build checked with `go build ./...` (tests were not run).
