# Test-suite performance implementation results

Status: resolved
Measured: 2026-09-22/23, Windows amd64, Go 1.26.7, Git 2.51.1.windows.1.

## Outcome

Both final full-suite runs pass with `-count=1`, without excluding any package or test. Normal-parallel execution fell from 54.910s to 31.784s (42.1%) between the passing baseline and final run. These numbers span the first through last Go JSON events, excluding build/startup before the first event. The baseline shell wall time was 56.883s; the final parallel shell wall time was not retained by the console-tail filter, so no exact end-to-end parallel wall time is claimed.

The final serial run took 186.151s shell wall time, with a 164.334s Go event window. Six existing file-symlink cases skip on this Windows host due to unavailable privilege, unchanged from the passing baseline. There are 554 passing test/subtest events in each final run, zero failures, and 18 passing packages. Parent/subtest timings overlap and must not be added together.

Earlier sandboxed full runs failed during real Git fixture cloning with `sh.exe: couldn't create signal pipe, Win32 error 5`. The daemon scheduling test failed at the same clone setup, not at a readiness assertion. A focused real sync test passed outside the sandbox, followed by a passing full baseline and both final suites with approved execution. No Git configuration, sync behavior, timeout, or test exclusion was changed to address those permission failures.

## Changes

- Ordinary attachment validation opens and validates the Realm filesystem and checks its ID, without Git origin checks. `Attach` explicitly checks the new attachment's origin; real sync origin/fetch/push checks remain intact.
- `LoadSnapshot` starts with `openLocal`, eliminating duplicate attachment traversal through `Open`. The cheap `.git` directory layout requirement remains and is documented on `Store.Verify`; deleting `.git` is not supported by this change.
- `Snapshot.WithValidatedRead` owns eligibility's entry validation, private capture comparison, callback evaluation, capture finish, and final original-snapshot validation. Dependencies for boundary tests are scoped to an invocation. Successful operations perform two snapshot loads and two read captures, independent of callback authorization count. Public `Snapshot.Allows` still revalidates freshness.
- `EligibleSourcesForSnapshot` delegates evaluation to the captured read path and returns no sources on validation failure. Source ordering, qualified identities, text/content hashes, possible classifications, metadata exclusion, and atomic publication checks remain covered. ADR 0008 records the consistency trade-off.
- `writeSnapshotStage` now performs setup only. Its repeated omitted-tag assertion moved to `TestWriteVariantRejectsOmittedQualifiedTags`.
- All 15 ACL truth-table cases moved to `TestAllowsForRequiresMembershipAndEveryDefinedControlledTag`; `TestSnapshotAllowsWiresCurrentAudiencePolicy` retains real allow/deny wiring checks, alongside existing mutation/integrity tests.
- The invalid-local-policy and canonical-mutation groups build a real Git fixture once per parent test, then copy all mutable Installation/Realm files separately for each subtest. Each copied fixture is successfully loaded before applying the negative mutation. No hard links or writable roots are shared.
- CLI tests lazily build one real executable per test-binary run and remove it in `TestMain`; test configuration and data remain independent. All prior direct builds now use this helper.

## Measurements

Warm dependency/build caches were reused (`.gocache-issue08`, `.gopath-issue08`). All runs used `-count=1`. Passing full suites used approved execution outside the sandbox; the baseline precedes the fixture/CLI optimisations but includes the first production performance changes.

| Measurement | Passing parallel baseline | Final parallel |
| --- | ---: | ---: |
| Go event window | 54.910s | 31.784s |
| Installation package | 54.782s | 30.179s |
| CLI package | 45.873s | 18.736s |
| Projection package | 33.469s | 31.670s |
| Invalid-local-policy test group | 23.86s | 3.52s |

The earlier targeted untraced eligibility test improved from the handoff's 15.34s baseline to 1.23s. The final retained phase probe, run with Git Trace2, gave:

| Phase | Calls | Elapsed | Git starts |
| --- | ---: | ---: | ---: |
| Real fixture setup/attachment | 1 | 1.350s | 8 |
| LoadSnapshot | 3 | 39.900ms | 0 |
| Snapshot.Allows | 3 | 38.633ms | 0 |
| Realm Verify | 3 | 22.867ms | 0 |
| BeginRead | 1 | 18.474ms | 0 |
| ReadSession.Allows | 1,000 | 0.516ms | 0 |
| Snapshot eligibility | 1 | 58.745ms | 0 |
| Captured-session eligibility | 1 | below timer resolution | 0 |
| ReadSession.Finish | 1 | 16.552ms | 0 |
| Stage fixture before Publish | 1 | 219.309ms | 0 |

The original traced stage fixture took 29.522s with 288 Git starts. The temporary phase-probe file was removed after measurement. No debug instrumentation remains.

## Verification and retained evidence

Raw local JSON is ignored under `runs/`:

- `baseline-approved-default`: passing baseline before fixture/CLI changes.
- `fixtures-optimized`: invalid-policy group 3.26s, 10 Git starts for one real setup instead of setup per case.
- `final-phases`: phase timings and counts above.
- `final-suite-serial`: all packages pass, `-p 1 -timeout=15m`.
- `final-suite-default`: all packages pass, default package parallelism, `-timeout=15m`.

New/strengthened checks cover Git-free Installation loading, Realm lookup, authorization, eligibility, publication, intake, deterministic classification, deterministic curation, and existing MCP retrieval. Origin changes preserve local authorization but explicit sync rejects the changed origin. Boundary tests reject valid replacement before capture, changes in the callback, changes after Finish, forged root/versions, callback errors, and nil callbacks. Independent canonical-discovery/read-image comparison checks the complete ordered source results. Existing pointer-commit, stale-marker, possible-classification, partial-Memory visibility, hash/integrity, and attachment/synchronization tests pass.

Further staging/catalog/polling refactoring was deferred: the measured staging helper is now 219ms and the suite passes comfortably. Projection is now the longest parallel package; further work should profile its fixture and filesystem costs separately. The earlier daemon readiness claim was not reproduced in the approved baseline or final runs. No additional ADR is needed for reversible fixture-copy/build reuse; production consistency is recorded in ADR 0008 and the Git boundary in ADR 0007.
