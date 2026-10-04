# Test-suite performance: October diagnosis and implementation handoff

Status: resolved
Application baseline: `57979f8`
Measured: 2026-10-04/05, Pacific/Auckland, Windows amd64, Go 1.26.7.

## Outcome and implementation order

The full Go suite passes in **68.491 seconds** outside the sandbox. **Curation is the critical path at 65.038 seconds**. The current bottleneck is repeated canonical filesystem validation and fixture construction, not the old Git-on-every-authorization defect. The September work already fixed that defect; do not reimplement its historical handoff.

The user subsequently authorized implementation, completed on 2026-10-05. See [implementation results](implementation-results.md) for the final changes, verification, timings, and deferred opportunities. Tickets [01: test runner](issues/01-select-git-integration-tests.md), [02: fixture copies](issues/02-copy-independent-fixtures.md), [03: staging validation](issues/03-bound-staging-validation.md), and [04: polling](issues/04-cheap-publication-waits.md) are resolved. The diagnosis below describes the original baseline; its source-level bottleneck descriptions precede the fixes. Temporary probes were removed.

The user requested that Git-related tests run only when changing that functionality. This policy is now in application [AGENTS.md](../../AGENTS.md), with commands and selection rules in [docs/agents/testing.md](../../docs/agents/testing.md), linked from [README.md](../../README.md). The current ordinary command excludes real Git behavior tests but keeps application tests that merely use Git for fixtures. Until those fixtures are improved, ordinary verification can still need execution outside the sandbox.

## Measured baseline

Command: `go test ./... -count=1 -timeout=15m -json`, using existing default dependency/build caches, outside the sandbox. Exit 0; 22 passing packages; 385 passing top-level tests; 673 passing parent/subtest events; seven skip events. Six skips concern Windows file-symlink privilege, and one is the opt-in live LLM test. None is a performance exclusion.

| Measurement | Seconds |
| --- | ---: |
| Shell wall time | 68.491 |
| First-to-last Go JSON event window | 65.039 |
| Curation | 65.038 |
| Projection | 27.988 |
| Classification | 25.370 |
| Installation | 23.808 |
| Read | 20.581 |
| Daemon | 19.946 |
| Realm | 18.512 |
| CLI | 13.844 |
| MCP server | 10.898 |

Use [baseline-summary.json](evidence/baseline-summary.json) for exact emitted package durations; rounded values above are for reading. The sum of package times is 254.634 seconds because packages overlap. It is not the suite duration. Parent/subtest timings overlap too. The 3.45-second difference between shell and event timings includes startup/build overhead and teardown; it is not a precise compiler-only measurement.

The slowest top-level tests include:

| Test | Seconds |
| --- | ---: |
| `TestRunSchedulesRealmSyncAndRebuildsOnlyAffectedLocalAudience` | 8.03 |
| `TestDreamingControllerSkipsUnchangedAudienceAndRetriesFailedWork` | 7.68 |
| `TestDreamingControllerResumesBoundedBatchesBeforeAtomicPublication` | 7.46 |
| `TestInstallationSearchRequiresCurrentCatalog` | 6.34 |
| `TestSnapshotPublicationRechecksAtPointerCommit` | 6.00 |
| `TestInstallationReadProfilesAndProvenance` | 5.55 |
| `TestSnapshotPublicationIsLocalAndReauthorizesEveryRealm` | 5.49 |
| `TestSyncRejectsMissingOrIncorrectOriginBeforeFetch` | 4.95 |
| `TestSnapshotLocalPathsRejectRealmSymlinks` | 4.87 |

Curation contains 55 passing top-level tests, executed sequentially within its package. There are no `t.Parallel()` calls in the current Go tests. Curation additionally holds the process-wide `runMu` during `Service.run`; adding parallel tests would still serialize those calls and could create fixture contention. Do not make broad parallelization the first fix.

## Why it costs this much

### 1. Repeated filesystem validation dominates processing

A CPU profile of the whole curation package shows these cumulative stacks: `realm.Store.Verify` 44.73%, `realm.ValidateCanonical` 43.96%, `installation.LoadSnapshot` 31.52%, `Snapshot.WithValidatedRead` 29.67%, `BeginRead` 17.06%, and `Service.checkInputs` 14.76%. These are nested contributions, not independent percentages to add. Windows syscall stacks dominate; `runtime.cgocall` here includes Windows syscall dispatch and is not proof that SQLite or a C library is the cause. See [curation-profile.txt](evidence/curation-profile.txt).

The profiled run passed in 76.756 seconds shell time / 75.552 seconds package time and included the temporary 3.47-second curation probe. Profiling changes timing; this run is attribution evidence, not a clean serial-versus-parallel comparison. Package contention remains possible but unproven. Do not infer that changing `-p` will help from these runs.

The concrete call chain is visible in [projection.go](../../internal/projection/projection.go), [snapshot.go](../../internal/projection/snapshot.go), and [curation.go](../../internal/curation/curation.go):

1. `Staging.policy()` calls `freshSnapshot`, which validates the original snapshot and loads another current snapshot.
2. `Staging.sources()` runs eligibility, which uses `WithValidatedRead` with required entry/capture/exit checks.
3. `WriteVariant` and each variant checked by `Validate` authorize through `snapshot.Allows`, which reloads the snapshot again.
4. `WriteArea`, `CopyArea`, `CopyVariant`, and `CopyAreaIfUnchanged` independently capture policy. A successful `CopyAreaIfUnchanged` calls `CopyArea` and repeats policy validation.
5. Curation calls `stage.Validate()` before auditing and then `stage.Publish()`, whose implementation validates again before committing the pointer. This ordering may be intentional: simply deleting the first validation could audit an invalid candidate. Preserve the semantics until the design explicitly accounts for them.

[dreaming.go](../../internal/curation/dreaming.go) also constructs `realm.NewRepository` inside the per-source fingerprint loop. [NewRepository](../../internal/realm/records.go) verifies the whole Realm. This creates another artifact-count-dependent validation path. It is a source-level scaling concern; the current profile does not isolate its share, so measure it separately before prioritizing a fix.

### 2. Ordinary integration fixtures repeatedly do expensive setup

[localCurationFixture](../../internal/curation/snapshot_test.go) initializes two Realms, configures and validates origins, submits content, rewrites approved classification, attaches both Realms, writes Audiences, and loads a snapshot. Similar setup exists in [projection](../../internal/projection/snapshot_test.go), [read](../../internal/read/installation_test.go), and [MCP](../../internal/mcpserver/installation_realms_test.go). Read/MCP fixtures publish two Audiences before the request assertions even start.

The curation profile attributes 19.23% cumulatively to `localCurationFixture`. This overlaps verification costs above. Table-driven mutation tests often repeat the entire fixture per row, including rows that skip afterward for missing file-symlink privilege. Windows directory-junction fallback additionally launches PowerShell; preserve those cases, but avoid paying repeated Realm creation first.

The existing [snapshotFixtureCopies](../../internal/installation/snapshot_test.go) demonstrates the safe optimization: create one valid seed per parent test, copy every mutable root independently, rewrite `realms.yaml` attachment paths, and validate each copy before mutation. Reuse that pattern instead of sharing writable roots or weakening production validation.

### 3. Git setup is real, but the old hot-path defect is fixed

Both new phase probes record eight Git launches during their two-Realm setup, followed by zero Git launches in ordinary processing. The traced existing slow controller test also records exactly eight launches: two each of `init`, `remote add`, `remote`, and `config --get-all remote.origin.url`. There is no fetch/push in that test. Git backup/sync integration tests are a separate verification lane under the new policy.

| Phase | Elapsed | Git launches |
| --- | ---: | ---: |
| Curation two-Realm fixture | 744.683 ms | 8 |
| Curation service construction | 10.591 ms | 0 |
| Initial Dreaming/publication | 906.807 ms | 0 |
| Unchanged Dreaming/no publication | 145.143 ms | 0 |
| Forced Dreaming/publication | 789.874 ms | 0 |
| Projection two-Realm fixture | 823.248 ms | 8 |
| Three `LoadSnapshot` calls | 38.948 ms total | 0 |
| Three public `Snapshot.Allows` calls | 35.300 ms total | 0 |
| Snapshot eligibility | 55.757 ms | 0 |
| Projection staging fixture, before Publish | 199.131 ms | 0 |

The capture's 1,000 `ReadSession.Allows` calls and captured eligibility were below the probe clock's displayed resolution; that means too small to measure here, not literally zero cost. [Projection output](evidence/projection-phases.txt), [curation output](evidence/curation-phases.txt), and [curation probe source](evidence/curation-phase-probe.go.txt) retain the evidence. The projection probe source is in the earlier tracker investigation's `evidence/diagnostic_performance_test.go.txt`.

### 4. Polling repeatedly validates while waiting

[daemon/server_test.go](../../internal/daemon/server_test.go) publication wait helpers repeatedly call `LoadSnapshot` and `ResolveForSnapshot` before sleeping 10 ms. Each resolver already validates the snapshot. This competes with the daemon doing the actual work. Shortening sleeps would increase wasted validation. A cheap pointer-change signal can avoid it while keeping the final authorization assertion real.

The full LLM package takes 1.36 seconds, and the seven JavaScript Markdown tests pass in about 0.074 seconds outside the sandbox. Neither is the critical path. The CLI already lazily builds one executable with `sync.Once`; do not spend a ticket implementing that again. Fixed sleeps in HTTP/LLM tests are small relative to the measured curation cost. No live model/network latency was present in the ordinary baseline.

## Implementation and verification discipline

Read `AGENTS.md`, `CONTEXT.md`, `docs/agents/testing.md`, and ADRs 0007/0008 before implementing. Use the individual tickets for exact file scope, step order, and completion criteria. Preserve canonical manifest/hash/graph checks, qualified identities, possible-tag authorization, private metadata exclusion, forged-snapshot rejection, and publication's atomic pointer-commit validation.

For each ticket: capture the focused before measurement, make one bounded change, run the named focused tests, then the complete suite required by `docs/agents/testing.md`. Use `-count=1` with the same caches and normal package concurrency. Run Git integration tests only when that ticket changes their functionality or shared helpers. Record any required failure or blocked command explicitly. Profile before larger changes; structural counters are more stable regression assertions than milliseconds.

Aim first for fewer setup invocations in mutation tables and fewer full captures per staging operation, independent of Artifact/variant count. The measured tiny-fixture times are diagnostic references, not portable unit-test deadlines. No defensible exact whole-suite speedup can be promised yet; selective Git execution alone will not shorten the 65-second curation critical path.

The initial diagnosis accepted no production architecture decision. Subsequent implementation records the staging capture decision in [ADR 0023](../../docs/adr/0023-staging-operation-scoped-source-validation.md). Reversible test-copy and lifecycle-runner changes do not need an ADR. The domain vocabulary remains unchanged.

## Execution limitations and retained evidence

The initial sandboxed `go test ./... -count=1 -json` failed in 8.522 seconds: build-cache reads were denied and Git remote setup failed. It is not a usable runtime baseline. `node --test internal/webui/markdown.test.js` also failed with `spawn EPERM` under the sandbox; its outside-sandbox rerun passed all seven tests. The valid full Go baseline passed outside the sandbox. None of those permission failures was treated as an application failure or fixed by changing Git behavior.

The first CPU-profile attempt used relative output paths and produced no usable profile artifact; the later absolute-path whole-package capture succeeded. The first curation probe compile exposed a temporary harness type mismatch, corrected before its passing measurement. Both diagnostic `.go` files were removed; only their evidence is retained. Raw baseline JSON, Git Trace2, and the binary CPU profile remain locally under ignored `.tmp/test-suite-analysis/`; concise evidence is committed in this tracker worktree.
