# Test-suite performance: diagnosis and implementation handoff

Status: ready-for-agent
Application baseline: `67a35d4`
Measured: 2026-09-22, Windows amd64, Go 1.26.7, Git 2.51.1.windows.1.

## Objective

Reduce test execution time by removing repeated expensive validation and unnecessary fixture work. Preserve authorization, canonical integrity, and atomic publication behavior. This document proposes implementation work; the diagnosis did not change application code or tests permanently.

Start with the small changes below and measure after each. Do not begin by increasing timeouts, adding broad `t.Parallel`, replacing Git with a successful stub, or skipping integration coverage.

Read `AGENTS.md`, `CONTEXT.md`, and ADRs 0001, 0002, 0004, 0005 and 0007 before implementation. Use local repository skills. Tracker documents belong in this separate `.scratch` worktree; application changes belong in the application repository.

The user clarified during diagnosis: Git is a backup mechanism and should not normally be on a hot path. ADR 0007 records this requirement. The primary target is therefore **zero Git process launches during ordinary processing after setup**, not merely fewer origin checks. Retain real Git checks for initialization, explicit attachment setup, backup, and synchronization.

## What is actually slow

The dominant measured cost is repeated Git process execution during Installation snapshot validation. Tests trigger production code that reloads the entire Installation for individual tag operations. Publication fixtures repeat those operations many times.

This is not evidence of a Git/network hang: the traced commands are local `git remote` and `git config --get-all remote.origin.url`, and the bounded probe completes. The previous task's assertion that the failures were merely an environmental problem was not established. Windows process overhead magnifies redundant work in the application.

### Measurements

The phase probe used two attached Realms and three Artifacts from `snapshotSources(t)`. Timing excludes compilation. Git counts are Trace2 `start` events, not estimates.

| Operation | Calls | Total elapsed | Git launches |
| --- | ---: | ---: | ---: |
| `snapshotSources(t)` fixture | 1 | 2.182 s | 18 |
| `installation.LoadSnapshot` | 3 | 2.325 s | 24 |
| `Snapshot.Allows` | 3 | 2.465 s | 24 |
| One Realm's `Store.Verify` | 3 | 30.390 ms | 0 |
| `installation.BeginRead` | 1 | 26.530 ms | 0 |
| `ReadSession.Allows` | 1,000 | 0.553 ms | 0 |
| `EligibleSourcesForSnapshot` | 1 | 7.335 s | 72 |
| `EligibleSourcesForRead` on captured session | 1 | below timer resolution | 0 |
| `ReadSession.Finish` | 1 | 32.799 ms | 0 |
| `writeSnapshotStage(t, s)` helper, before Publish | 1 | 29.522 s | 288 |

The probe passed in 44.00 s and recorded 426 Git launches. Source and output are in `evidence/diagnostic_performance_test.go.txt` and `evidence/phases.txt`. The probe was removed from `internal/projection` after measurement.

The existing `TestSnapshotEligibilityFiltersArtifactsWithinOneMemory`:

- Failed a deliberate 10-second diagnostic timeout, after 96 Git starts. This is the small red performance reproduction, not a proposed permanent timing assertion.
- Passed with a 60-second budget in 25.24 s with tracing, recording 242 Git starts.
- Passed in 15.34 s without tracing, with warm dependency/build caches and `-count=1`.

Trace overhead and machine variability affect elapsed time. Compare traced counts with traced counts and untraced timing with untraced timing. Do not infer a precise tracing overhead from one pair of runs. Git's own reported internal durations exclude some launch/wait overhead; they are not the full cost to the Go caller.

Previous-turn full runs timed out at 180 seconds per package; a standalone projection run timed out at 300 seconds while progressing through publication tests. Those are incomplete runs, not measurements of the complete suite. A daemon queue-readiness assertion also failed in the parallel run. Whether that assertion is solely load-related remains unproven.

### Causal chain and files

1. `internal/installation/snapshot.go:LoadSnapshot` calls `Open(root)`.
2. `internal/installation/config.go:Open` validates every attachment. Each `validateAttachment` runs full Realm validation and `validateOrigin`, which launches two Git commands.
3. `LoadSnapshot` then loops over the attachments and calls `validateAttachment` again. With two Realms this is eight Git launches per snapshot load; the same attachments were checked twice.
4. `Snapshot.Allows`, `EffectiveTags`, and `ValidatedRoot` call `Snapshot.current`, which loads another complete snapshot each time.
5. `internal/projection/snapshot.go:freshSnapshotWith` calls `ValidatedRoot` and then another load, intentionally checking for replacement between captures. `EligibleSourcesForSnapshot` subsequently reloads for each distinct tag-set qualification and authorization, and performs a final root check.
6. For the measured fixture, discovery performs nine snapshot loads: two at entry, six for three distinct tag sets, and one at exit. Nine times eight gives 72 Git launches. Existing `cachedTags`/`cachedAuthorization` only cache identical sets within one pass.
7. `Staging.policy`, `sources`, `WriteVariant`, `WriteArea`, `Validate`, and `publishWith` compose these expensive entry points. `catalog/installation.go` composes them again during publication resolution and catalog rebuilds.

The 288-launch fixture breakdown is: Start 16, eligibility 72, deliberately invalid WriteVariant 88, valid WriteVariant 96, WriteArea 16. `writeSnapshotStage` embeds a negative omitted-tag assertion in every setup call. Publication tests call this helper twice in multiple subtests.

`internal/read/installation_test.go:localFixture` and `internal/mcpserver/installation_realms_test.go:localFixture` publish two Audiences through this path before tests reach their read assertions. Even `TestMCPQueryDoesNotRequireGit` pays Git-heavy setup costs, although its actual requests already use the fast read-session path.

Secondary costs:

- `realm.ValidateCanonical` walks directories, verifies manifest hashes, and validates the record graph. The repeated scans are real, but much smaller than Git in the small measured fixture. Large-Realm scaling was not measured.
- `internal/daemon/server_test.go` publication polling helpers load a snapshot and resolve a publication repeatedly, followed by a 10 ms sleep. Each iteration does expensive work; reducing the sleep cannot help.
- Concurrent package execution may increase process/filesystem contention. This is plausible from previous failures, but has not been isolated by a controlled serial-versus-parallel experiment. Measure it; do not present it as the primary proven cause.
- New cache directories caused downloads and compilation in an earlier full run. They do not explain the measured time inside individual tests. Reuse warm caches for comparisons.

## Implementation sequence

### 1. Separate filesystem validation from Git operations

In `internal/installation/config.go`, separate the current `validateAttachment` responsibilities. The ordinary attachment validator must open and validate the Realm filesystem and compare its Realm ID with the attachment. It must not call `validateOrigin`. Call `validateOrigin` explicitly from `Attach` for the attachment being configured. `Open` and `Installation.Realm` should use the filesystem-only validator; callers must be able to load an existing Installation and find an attached Realm without launching Git.

Change `LoadSnapshot` to load Installation layout/configuration through existing private `openLocal`, then retain its one attachment-validation loop. This also removes the duplicate Realm filesystem traversal currently performed through `Open`. Preserve malformed-layout/configuration handling, Realm ID checking, symlink checks, strict policy parsing, manifest hashes, record-graph checks and fail-closed errors. Do not move Git configuration parsing into the normal validator as a substitute for spawning Git: remote configuration is outside ordinary authorization entirely.

`internal/realm/git.go:syncWithGit` already invokes `validateSyncOrigin` before network operations, including fetch/push URL checks. Preserve that validation and the sync tests. `Installation.SyncRealm` resolves the Realm through `Installation.Realm` and then calls `realm.Sync`, so removing origin checking from ordinary lookup does not remove the sync check. Keep `TestAttachRejectsMissingOrInvalidRemote` and the real Realm sync tests.

Compatibility detail: `realm.Store.Verify` currently requires a `.git` directory via `os.Stat`, and tests cover that layout rule. This task removes process/remote-config dependencies; it does not need to redesign Realm format or missing-backup-metadata recovery. Keep that cheap layout check for now, document it, and do not claim that deletion of `.git` is supported. Canonical changes still invalidate snapshots even when Git configuration changes do not.

Completion: real fixtures are set up with Git available, then `Open`, `Realm`, `LoadSnapshot`, `Snapshot.Allows`, eligibility, and publication succeed with Git absent from PATH. Changing origin configuration after attachment does not deny valid local processing; explicit sync still rejects an invalid configured origin. No Git command runs in ordinary operations; creation/setup Git calls remain expected.

### 2. Make fixtures setup-only and move repeated logic tests to inexpensive seams

In `internal/projection/snapshot_test.go`, move the intentionally invalid `WriteVariant` call out of `writeSnapshotStage` into one dedicated canonical omitted-tag rejection test. Preserve its assertion and the valid staging helper behavior. At the original baseline this avoids 88 Git launches per helper invocation.

In `internal/installation`, put the complete ACL truth table at the existing private `allowsFor` seam in an internal-package test, using small in-memory Audience and policy values. Cover all current cases, including explicit deny, unknown tags, wildcard membership and missing Realm membership. Retain representative real `Snapshot.Allows` wiring tests, and all snapshot mutation/integrity tests. Apply the same approach to pure tag qualification only if profiling still justifies it.

Keep the existing real Git integration tests for attachment, origin, and synchronization. Test data must remain independently mutable per test; do not share a writable fixture root across subtests.

Completion: each removed repeated assertion has a named replacement test; shared setup performs no intentional negative authorization exercise. ACL behavior still has exhaustive coverage without a snapshot reload for every truth-table row.

### 3. Reuse a validated capture within one eligibility operation

Remeasure after step 1: the dominant process cost should already be gone. If repeated filesystem captures still dominate, start this refactor with `EligibleSourcesForSnapshot`, not the entire read/curation stack at once. This is an optional second stage if steps 1–2 already meet the completion criteria; report that choice and measurements.

Use the existing opaque `installation.ReadSession` and `EligibleSourcesForRead` to evaluate Artifacts against one capture. Add a small Installation-owned wrapper, for example `Snapshot.WithValidatedRead(func(*ReadSession) error) error`, that owns capture and final checking. The name is proposed, not an existing interface.

Required wrapper sequence:

1. Validate the original snapshot's private identity and public root/version consistency, preserving `ValidatedRoot`'s canonical and policy checks. Obtain the root through that validated path, not exported `Realms`/Audience maps. No origin check occurs here after step 1.
2. Capture with `BeginRead(root)`. Inside the installation package, compare the captured private snapshot identity/versions with the original snapshot before invoking the callback. A changed-but-valid replacement must be rejected, not silently substituted. `SameInputs` and the private digest provide existing comparison machinery.
3. Run the callback entirely against that capture, using read-session qualification and authorization. For eligibility, collect `EligibleSourcesForRead` results locally.
4. On success, run `ReadSession.Finish`, then revalidate the original snapshot's filesystem/policy contract. Return content only if both succeed. Callback failure returns an error with no successful result. Neither final check invokes Git.

Preserve source ordering, qualified identities, possible-tag unions, source-hash checks and metadata exclusion. Review differences between `eligibleImageSources` and `discoverCanonicalSources` before delegating; equivalence must be tested, not assumed.

Use the wrapper only for operations that leave canonical data and policy unchanged. It can inspect Installation-local projections, but it is not a lifetime cache for curation runs or a replacement for publication's atomic commit check.

Keep public `Snapshot.Allows` freshness checks. Inside the operation, use `ReadSession.Allows`, whose data is private and immutable to callers. Do not expose a mutable Snapshot as a trusted authorization view, or add a global/TTL cache.

Completion if this step is needed: zero Git launches; the number of full snapshot loads/captures per eligibility operation is bounded independently of Artifact count or unique tag sets. All mutation/forged-snapshot tests pass. Document required entry/exit checks rather than deleting them to hit a timing target.

### 4. Reduce repeated publication and test polling work where still measured

Remeasure `writeSnapshotStage` after steps 1–2 and any justified step 3 work. If staging remains dominant, let one `WriteVariant` or `Validate` invocation share a captured policy, source map, and read-session authorization internally. Refactor the existing private helpers so they accept that operation's validated inputs rather than calling public snapshot methods recursively. Re-capture between public operations. Skip this larger refactor if measurements no longer justify it.

Keep the validation callback in `publishWith` at `AtomicWriteValidated`'s publication point. Keep stale-marker clearing checks after commit. Preserve the tests in `snapshot_commit_test.go`, including the test hook in `freshSnapshotWith`; combining two reads must not remove the replacement-detection scenario that hook exercises. Do not hold a Realm read lock across its own write/commit path.

For daemon test polling, observe a cheap local readiness signal first (e.g. a changed `current.yaml` pointer), then perform real validated resolution once that signal changes. An unchecked pointer is only a test wait signal; assertions still use the validated result. Preserve cancellation, bounded deadlines and useful diagnostics. Never expose this polling shortcut as production authorization.

Completion: the stage fixture uses zero Git launches after Realm/attachment setup, with preserved publication/tamper coverage. If polling remains a measured cost, publication wait loops no longer reload every Realm when the pointer is unchanged. Benchmark further catalog changes separately if still needed.

### 5. Verify and record the result

Use the measurement script below and retained phase probe. Structural budgets are the stable regression criteria; wall-clock improvements should be substantial on the same host/cache configuration but are not portable unit-test assertions.

Preserve or add focused tests for:

- Changed policy/ACL, missing Realm/manifest, unlisted canonical additions and edits, and forged exported snapshot fields.
- Changed-but-valid inputs between initial validation and capture, and changes during an operation's callback; discard results on final-check failure.
- Normal intake, classification, curation, publication and retrieval succeed without Git in PATH after setup. Use deterministic LLM adapters and local fixtures. Keep real origin validation tests on the attachment/sync interfaces.
- Different tag sets and additional Artifacts do not introduce Git calls. If implementing step 3, full-capture counts are bounded per operation. Prefer instance-scoped test counters or a private injected loader seam; avoid mutable process-global hooks in parallel tests.
- Source/content hash mismatches, uncertain tags and deny precedence, partial Memory visibility, and metadata exclusion.
- Publication changes at pointer commit leave the previous pointer and stale marker intact; changes after successful commit retain staleness without reporting a retryable publication failure.
- MCP request operations still succeed without Git in PATH after fixture setup (`TestMCPQueryDoesNotRequireGit`).

Run focused installation/projection checks after each change, then the complete suite with an adequate diagnostic timeout, first serially (`-p 1`) and then with normal package parallelism. `-timeout` is per package, not a whole-suite budget. Timeouts and assertion failures are both failures. Investigate the earlier daemon readiness failure if it recurs; do not relabel it as an environmental issue without a controlled reproduction.

Completion: `go test ./... -count=1` completes successfully, without excluding slow/security tests. Normal-operation phases in the retained probe show zero Git starts; trace entries for fixture initialization and attachment are expected. Aim for at least a 75% reduction from the same-host 15.34-second untraced eligibility test baseline (a performance target, not a hard unit-test clock assertion). Record wall times, package timings, Git counts, and preserved coverage. Repeated cached test results (`(cached)`) do not demonstrate an improvement. Stop broad repetitions once the checks pass.

## Running measurements

From the application root:

```powershell
pwsh -NoProfile -File .scratch/test-suite-performance/measure.ps1 -Label before -TraceGit
pwsh -NoProfile -File .scratch/test-suite-performance/measure.ps1 -Label before-untraced
# After implementation, repeat with new labels and compare equivalent runs.
pwsh -NoProfile -File .scratch/test-suite-performance/measure.ps1 -Label suite-serial -Packages './...' -Filter '.' -PackageParallelism 1 -Timeout '15m'
pwsh -NoProfile -File .scratch/test-suite-performance/measure.ps1 -Label suite-default -Packages './...' -Filter '.' -Timeout '15m'
```

For phase measurements, temporarily add `evidence/diagnostic_performance_test.go.txt` as `internal/projection/diagnostic_performance_test.go` using `apply_patch`, run the script with `-Filter '^TestDiagnosticPerformance$' -TraceGit -Timeout '90s'`, then remove the temporary file. The probe uses existing test fixtures and never changes production behavior.

Raw trace files are local diagnostics and ignored by this tracker directory. Retain concise measurements and implementation evidence in this handoff or its issue. Test fixtures use temporary local paths; review traces before sharing them because Git tracing can record command arguments.

## Scope and architecture record

ADR 0007 records the user's accepted architecture constraint: Git is outside normal processing. This deliberately removes Git-origin matching from ordinary snapshot authorization while preserving canonical filesystem and policy validation. The optional operation-scoped wrapper remains a proposed implementation detail; if it changes validation lifetime or consistency guarantees, record its trade-off separately using the domain-modeling skill. Existing stale-data, Realm/Installation, and metadata rules remain requirements.

Do not reopen classification semantics or solve unrelated Issue 08 gaps in this performance change. Document newly discovered functional defects separately. Do not declare the prior Issue 08 full-suite acceptance criterion satisfied until there is an actual successful full run.
