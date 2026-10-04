# Add an explicit ordinary/Git test runner

Type: task
Status: resolved

## Scope

Implement the lifecycle policy already recorded in application `AGENTS.md` and `docs/agents/testing.md`. Read the [diagnosis](../spec.md) first. Edit `scripts/test.ps1`, `docs/agents/testing.md`, and the README test pointer as needed. Do not modify application behavior or move every test mentioning Git into the Git lane.

## Steps

1. Create `scripts/test.ps1` with a default ordinary mode and explicit `-IncludeGitIntegration` switch. Use the current exact-name list in `docs/agents/testing.md` as the initial integration inventory. Keep one authoritative inventory in the runner; replace the duplicated documentation list with runner commands.
2. Ordinary mode runs `go test ./... -count=1 -skip <anchored-parent-pattern>`, then `node --test internal/webui/markdown.test.js`. Include mode runs unfiltered `go test ./... -count=1`, then the same JavaScript tests. Capture each exit code and exit nonzero if either command fails; do not overwrite a Go failure with a passing Node exit code.
3. Keep existing caches. Accept optional focused package/filter parameters only if their behavior is documented separately from complete verification. Do not use `-short` unless every affected test has deliberately implemented it; it currently provides no Git separation.
4. Check every inventory name against current source. Keep `DoesNotRequireGit`, canonical-layout/record-commit, publication-commit, and injected-clock/sync scheduler tests in ordinary mode. If a mixed test contains unique ordinary coverage, split that coverage into a named ordinary test before excluding its integration part.
5. Verify the default command outside the sandbox if its ordinary fixtures still require it. Run include mode only for a relevant Git change or a one-time runner selection check; document the exact purpose. Add a lightweight selection check if necessary, exercising actual runner argument generation rather than duplicating its list in a test.

## Done

The default runner excludes only documented integration behavior; explicit include mode preserves the whole Go suite; JavaScript runs in both; failures propagate. Update test documentation with one default command, one include command, and the functionality triggers. Record executed commands/results. This ticket changes lifecycle selection, not synchronization, so fixture cloning restrictions are not a reason to alter production Git.

## Comments

2026-10-05: Implemented `scripts/test.ps1` with ordinary, include, and inventory-list modes. The 19 exact names all resolve to current source. Shell smoke checks cover Go failure, Node failure, include-mode selection, and uncached arguments; the real ordinary runner passes. See [results](../implementation-results.md).
