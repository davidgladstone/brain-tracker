# Reuse a valid seed in expensive mutation tables

Type: task
Status: resolved
Blocked by: 01

## Scope

Test helpers only. Start with `internal/curation/snapshot_paths_test.go`, then `internal/projection/snapshot_commit_test.go` and the publication mutation table in `snapshot_test.go`. Use `internal/installation/snapshot_test.go:snapshotFixtureCopies` as the reference. The [diagnosis](../spec.md) measured 0.745/0.823 seconds for fresh curation/projection fixtures.

## Steps

1. Time `go test ./internal/curation -run '^TestSnapshotLocalPaths' -count=1 -json` and `go test ./internal/projection -run '^TestSnapshotPublication' -count=1 -json` before editing. Use valid outside-sandbox execution when needed.
2. Add a package-local helper that builds one seed at parent-test scope. Return a factory accepting the child `*testing.T`; each invocation copies the Installation and every attached Realm into that child's separate `t.TempDir()` directories using `os.CopyFS`. Copy regular files/directories, preserving needed `.git` layout. No hard links or shared writable paths.
3. Clone the attachment slice before rewriting paths. Rewrite each attachment's `Path` to its copied Realm; persist `realms.yaml` using the existing YAML conventions. Keep Realm IDs and content bytes unchanged. Load and validate the copied snapshot successfully before a negative mutation.
4. Call the factory within each subtest. Each subtest still performs its own corruption/symlink/classification/publication mutation and all original assertions. Build a separate seed for different fixture shapes. Keep seeds before symlink injection; `os.CopyFS` does not solve copying a deliberately linked fixture.
5. Verify two copies are independent by modifying an existing file in one and checking the other copy and seed retain their original bytes. Inspect rewritten attachment paths. Retain Windows symlink privilege skips and directory-junction coverage.
6. Rerun the focused commands, then ordinary full verification. Compare parent timings and setup count. Document which repeated seeds were eliminated. Stop if copying is slower or the copied baseline cannot validate.

## Done

The targeted tables initialize one real seed per parent, retain independent mutable children and all prior assertions, and improve equivalent focused timings. Production files, Git behavior tests, authorization checks, and publication boundaries are unchanged. Do not introduce a package-global seed owned by the first test's `t.TempDir()`; that directory disappears when that test ends. Broader package-lifetime reuse is a separate task.

## Comments

2026-10-05: Added the shared `internal/testutil.SnapshotCopies` helper and applied it to both curation path tables and both projection publication mutation tables. The helper validates seeds/copies, rewrites attachment paths, and shares no writable files. A real policy-corruption test confirms the other copy and seed remain authorized. Focused and complete ordinary checks pass; timings and comparison limits are in [results](../implementation-results.md).
