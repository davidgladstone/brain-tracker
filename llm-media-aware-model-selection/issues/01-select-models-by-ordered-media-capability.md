# 01: Select models by ordered media capability

**What to build:** LLM operations use the highest-preference configured model that supports their required media types. Text-only and image-processing operations can therefore select different models from the same ordered configuration, while local model execution continues to avoid swapping a model that is busy with an incompatible operation.

**Blocked by:** None (can start immediately).

**Status:** resolved

- [x] Configuration represents models in preference order, with each entry declaring the media types it supports; existing preferred and alternate settings are migrated or handled compatibly.
- [x] Each LLM operation declares the media types it requires, and model selection chooses the first configured model supporting all of them.
- [x] When a local runtime has an incompatible model loaded or busy, the operation waits or is deferred for retry rather than forcing a model swap.
- [x] When no configured model supports an operation's required media types, the operation fails with a clear, actionable configuration error.
- [x] Tests cover preference ordering, capability matching, no-compatible-model behavior, and deferral while an incompatible local model is loaded.

## Comments

### 2026-10-07 resolution

Added ordered `llm.models` configuration and `brain config set-llm-models`, with explicit text/image capabilities. Legacy preferred/alternate settings remain readable and migrate as text-only. Operations select the first compatible model; a loaded incompatible llama-swap model defers the call, and missing compatible configuration returns an actionable error. ADR 0031 records the migration and selection contract.

Verification: focused config, LLM, web API, classification-worker, and CLI tests passed. The full ordinary runner passed all Go packages and all nine JavaScript tests.
