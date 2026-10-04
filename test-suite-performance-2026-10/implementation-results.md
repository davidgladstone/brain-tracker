# Test-suite performance implementation results

Status: resolved
Completed: 2026-10-05, Pacific/Auckland.
Application starting commit: `57979f8`; application edits remain in the working tree for review.

## Result

The new ordinary lifecycle runner passes in **58.732 seconds**, including all seven JavaScript tests. The initial unfiltered Go diagnostic took **68.491 seconds**. This is a 9.76-second reduction in observed routine verification time, but the commands have different scopes: the ordinary runner deliberately excludes 19 Git integration parent tests and includes JavaScript. It is not an equal-coverage whole-suite performance claim.

The curation package retains its 55 original top-level tests and drops from **65.038 to 55.717 seconds** (14.3% in these runs). This provides evidence of improvement beyond test selection; machine load and cross-package contention still vary, so there is no precise isolated attribution to each fix. Curation remains the critical path. Projection includes new regression tests in its final 26.687-second run, versus 27.988 seconds originally.

| Package | Original unfiltered diagnostic | Final ordinary runner |
| --- | ---: | ---: |
| Curation | 65.038 s | 55.717 s |
| Projection | 27.988 s | 26.687 s |
| Classification | 25.370 s | 23.978 s |
| Installation | 23.808 s | 17.962 s |
| Read | 20.581 s | 19.033 s |
| Daemon | 19.946 s | 11.365 s |
| Realm | 18.512 s | 4.755 s |
| CLI | 13.844 s | 7.828 s |

Realm, Installation, CLI, and daemon timings include changed test selection; compare them as verification-lifecycle measurements. Package durations overlap and must not be summed for suite duration. The default runner never uses cached test results: it passes `-count=1` and preserves existing dependency/build caches.

## Implemented changes

- `scripts/test.ps1` runs ordinary Go verification plus JavaScript by default. `-IncludeGitIntegration` runs the unfiltered Go suite plus JavaScript when the changed functionality requires it. `-ListGitIntegration` displays the authoritative exact-name inventory. Failure from either suite propagates even if the other passes. `AGENTS.md` points to the lifecycle rules; README links them.
- `internal/testutil.SnapshotCopies` makes independent copies from one parent-owned valid seed. Both curation path-mutation tables and both projection publication mutation tables use it. Every copied Installation rewrites its attachment paths and successfully loads before its negative mutation. A policy-corruption regression checks copy/seed isolation.
- `Staging.Validate` and `WriteVariant` use `withSourceInputs` to own one `Snapshot.WithValidatedRead` operation. Captured Audience metadata, versions, source discovery, and authorization share the private read. `ReadSession.Audience` copies ACL slices, all Brief slices, and generation options so a caller cannot change captured metadata. Legacy staging retains its policy/source path.
- Each successful staging call now uses the existing wrapper's two snapshot loads and two read captures, independent of the number of variants authorized within the call. A regression observes one validated-read operation for one versus ten variants, and rejects policy/canonical changes during validation. The existing Installation wrapper regression verifies its exact two-load/two-capture boundaries. No global or lifetime cache was added.
- Daemon publication waits read cheap pointer bytes before validated resolution. An unchanged candidate is retried at most once per 250 ms; a changed pointer triggers immediate validation. Real content checks, daemon failure observation, deadlines, and diagnostics remain.
- [ADR 0023](../../docs/adr/0023-staging-operation-scoped-source-validation.md) records the consistency decision. The canonical domain vocabulary is unchanged. No ADR is needed for the reversible runner, fixture-copy, or test-polling changes.

Publication still performs real candidate validation, the atomic pointer-commit authorization check, and post-commit stale handling. Curation's pre-audit validation remains separate from publication validation. Tests for possible classifications, cross-Realm provenance, hidden metadata, prior-policy curation, tampered inputs, forged snapshots, pointer replacement, and post-commit staleness remain in required verification.

## Verification

All required final checks passed outside the sandbox, using Go 1.26.7 on Windows amd64:

1. `go test ./internal/curation ./internal/projection -run '^TestSnapshot(LocalPaths|Publication)' -count=1 -json` passed after fixture-copy changes. The curation rejection table took 2.13 seconds versus 4.87 seconds in the initial full run; projection's commit table took 3.36 seconds versus 6.00 seconds. Different package loads make these encouraging focused measurements, not controlled per-fix speedup claims.
2. Focused fixture independence and daemon wait checks passed. The real scheduling integration was included because the changed wait helper is shared with it.
3. The staging-capture regression first failed to compile against the missing implementation, then passed all one/ten-variant and mid-read mutation cases. The later private-Audience clone and existing capture-boundary regressions pass.
4. `go test ./internal/projection ./internal/curation ./internal/read ./internal/mcpserver -count=1 -json` passed for the first staging version. After removing its redundant policy capture, focused Installation/projection capture, Snapshot, variant, and staging checks passed using the runner's exclusion inventory for unrelated Git behavior tests.
5. **Final:** `pwsh -NoProfile -File scripts/test.ps1` passed all 22 Go packages with tests, plus seven JavaScript tests, in 58.732 seconds. Source-only retry, webui, and shared testutil packages correctly report no Go tests. See [final output](evidence/final-ordinary.txt) and [timing metadata](evidence/final-ordinary-meta.json).
6. **Final:** `go test ./internal/daemon -run '^TestRunSchedulesRealmSyncAndRebuildsOnlyAffectedLocalAudience$' -count=1 -json` passed the specifically affected real Git integration on the final code: test 5.65 seconds, package 5.738 seconds. The rest of the Git lane was not rerun for unrelated application changes.
7. `go vet ./internal/installation ./internal/projection ./internal/testutil`, Go formatting, documentation-link checks, and application/tracker `git diff --check` pass. Script inventory checks resolve all 19 names to actual tests. Process-local shell smoke checks verify include-mode argument selection, `-count=1`, Go-failure propagation, and Node-failure propagation without running another suite.

Sandboxed Go/Node permission failures from diagnosis remain documented in [the spec](spec.md); passing measurements use outside execution. The Windows symlink privilege skips and explicitly opt-in live LLM test are unchanged. No debug/probe Go files remain. Only tracker evidence and ignored local timing artifacts are retained.

## Remaining opportunities

The per-source `NewRepository` loop in Dreaming fingerprints, repeated Area/copy policy checks, and repeated curation input captures remain opportunities. Their individual shares were not isolated; they are not required unfinished tickets in this fix. Further work should measure those paths on a larger corpus and preserve generation/commit mutation checks before extending capture reuse. Package-lifetime fixture reuse also needs independent cleanup ownership; parent-scoped copies were deliberately chosen for straightforward isolation. No extra broad repetitions or parallelism changes are justified by the current passing measurements.
