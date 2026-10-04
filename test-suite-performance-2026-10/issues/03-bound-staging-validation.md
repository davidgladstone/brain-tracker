# Design and bound repeated staging validation

Type: task
Status: resolved
Blocked by: 02

## Why design comes first

The [diagnosis](../spec.md) measures Realm verification/snapshot capture as dominant stacks. `Staging` composes fresh policy, source eligibility, and public `Snapshot.Allows` repeatedly. Authorization freshness is deliberate. A less capable implementation agent should receive a reviewed interface and invariant list before changing this boundary.

## Reviewable design steps

1. Remeasure after fixture improvements. Profile a controller test and a staging operation separately. Count full snapshot loads/read captures, variant authorization calls, and source discovery for 1 versus 10 variants/sources. Use invocation-scoped instrumentation or temporary diagnostic code; avoid mutable global hooks. Keep the measurements outside the sandbox when fixture setup needs it.
2. Design a private staging-operation context that validates the staging handle, owns one opaque validated read, and supplies captured policy, qualified sources, and authorization to private helpers. Prefer existing `Snapshot.WithValidatedRead`/`ReadSession` boundaries from ADR 0008. Specify how Audience metadata is obtained without trusting mutable exported Snapshot maps. Do not expose a caller-supplied trusted policy or keep a context across public method calls.
3. Propose `Validate` as the first migration: build the source map once, authorize every variant against the same private capture, read and check every staged file, then finish/revalidate before success. Keep validation failures fail-closed and successful results private until final checks pass.
4. After that passes, consider `WriteVariant` separately. Keep reacquisition between public calls. Changes during generation must remain detectable; do not hold Realm read locks while generation or commit requires a write.
5. Preserve `publishWith`'s `AtomicWriteValidated` pointer-commit callback and post-commit stale-marker semantics. Treat curation's pre-audit Validate and Publish's Validate as separate boundaries until audit ordering is explicitly resolved. Do not delete checks based only on duplicate names.
6. Record a reviewed design and the required ADR before assigning implementation. The implementer should add deterministic counter tests showing full validations bounded independently of unique tag/variant count, plus mutation tests at entry, during processing, and before success.

## Required implementation verification

Run `go test ./internal/installation ./internal/projection ./internal/curation ./internal/read ./internal/mcpserver -count=1`, then the ordinary full runner. These focused packages contain some Git integration behavior in installation: apply the ordinary exclusion from the runner unless Git functionality/shared integration helpers changed. Keep every forged Snapshot, canonical tamper, uncertain-tag, metadata/provenance, stale-marker, generation mutation, and pointer-commit regression passing. Measure the original controller test and curation package again without profiling before claiming improvement.

Do not accept global/TTL caches, fixture-only successful Git stubs, removed source integrity checks, or a captured session reused for the lifetime of a curation service. Per-source `NewRepository` in `dreaming.go` is a separate measured-if-needed follow-up; reusing one per Realm also requires explicit entry/exit mutation handling.

## Done

The design is reviewed, the operation preserves its security/consistency contract, deterministic counts show bounded validation work, focused and ordinary suites pass, and equivalent unprofiled timing improves. If measurements do not justify the larger change after ticket 02, record deferral with evidence.

## Comments

2026-10-05: User authorized direct implementation. Reviewed the design against ADR 0008, private Snapshot identity/version semantics, stale-curation policy requirements, and publication commit/audit ordering. `Validate` and `WriteVariant` now share one validated private read within each call. `ReadSession.Audience` returns deep-copied metadata, avoiding a separate policy reload and mutable exported Snapshot maps. Entry/exit checks and per-call reacquisition remain; pre-audit/Publish validations and commit checks remain separate. ADR 0023 records the choice. Counter/mutation/privacy regressions and the ordinary full suite pass; see [results](../implementation-results.md).
