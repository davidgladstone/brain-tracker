# Make daemon publication wait signals inexpensive

Type: task
Status: resolved

## Scope

Only `internal/daemon/server_test.go` publication wait helpers. The [diagnosis](../spec.md) shows they repeatedly load/resolve whole Installation snapshots while waiting. Preserve real daemon execution and all final publication assertions.

## Steps

1. Measure `TestRunClassifiesCuratesAndPublishesWithDeterministicRuntime` and `TestRunRetriesUnavailableDeterministicRuntime` with `-count=1`. Keep the scheduled-real-sync test for changes to Git sync/scheduling functionality; this wait-helper change also affects that test, so it requires one focused outside-sandbox run at final verification.
2. Read the selected Audience's Installation-local `projections/<audience>/current.yaml` as a cheap test wait signal. Compare pointer bytes/revision with the prior value where waiting for a change. A missing/unchanged pointer means continue waiting; it is never authorization evidence.
3. Once it appears/changes, perform the existing `LoadSnapshot`, validated `ResolveForSnapshot`, and expected content checks. Retry if the pointer was transient or the validated content is not ready. Continue observing the daemon's `done` channel, cancellation, existing deadlines, and final failure diagnostics.
4. Avoid repeating expensive resolution on every iteration while the pointer is unchanged. On a rejected candidate, permit a bounded retry so a transient valid-publication race does not hang the test. Use local variables inside each helper, not shared caches. Keep the cheap readiness signal confined to tests.
5. Run the focused ordinary daemon tests, then the scheduled-sync test outside the sandbox because its shared helper changed, then complete ordinary verification. Compare timings and full snapshot-load count during waiting. Do not reduce deadlines to manufacture a speedup.

## Done

Unchanged pointers do not trigger repeated full captures; actual observed publications still pass validated resolution and content assertions; cancellation/daemon failure diagnostics work; all required checks pass. The measured suite impact is secondary because curation remains its longest package.

## Comments

2026-10-05: All three publication wait helpers now inspect pointer bytes before expensive validated resolution, with a 250 ms fallback retry for transient candidates. The cheap signal remains test-only. A fake-clock regression covers missing, unchanged, retried, and changed pointers. Ordinary daemon verification passes; the affected real Git scheduling integration test also passes outside the sandbox on the final code in 5.65 seconds. See [results](../implementation-results.md).
