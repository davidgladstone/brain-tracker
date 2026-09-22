param(
    [Parameter(Mandatory = $true)][string]$Label,
    [string[]]$Packages = @('./internal/projection'),
    [string]$Filter = '^TestSnapshotEligibilityFiltersArtifactsWithinOneMemory$',
    [int]$PackageParallelism = 0,
    [string]$Timeout = '60s',
    [switch]$TraceGit
)
$ErrorActionPreference = 'Stop'
$taskRoot = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
if ($Label -notmatch '^[a-zA-Z0-9-]+$') { throw 'Label must contain only letters, digits and hyphens.' }
$outputRoot = Join-Path $PSScriptRoot "runs/$Label"
if (Test-Path -LiteralPath $outputRoot) { throw 'Use a new label; prior evidence will not be overwritten.' }
New-Item -ItemType Directory -Path $outputRoot -Force | Out-Null
$priorEnvironment = @{}
foreach ($name in @('GOCACHE', 'GOPATH', 'GOTELEMETRY', 'GIT_TRACE2_EVENT')) {
    $priorEnvironment[$name] = [Environment]::GetEnvironmentVariable($name, 'Process')
}
$testExit = 1
Push-Location $taskRoot
try {
    $env:GOCACHE = Join-Path $taskRoot '.gocache-issue08'
    $env:GOPATH = Join-Path $taskRoot '.gopath-issue08'
    $env:GOTELEMETRY = 'off'
    $gitTrace = Join-Path $outputRoot 'git.jsonl'
    [Environment]::SetEnvironmentVariable('GIT_TRACE2_EVENT', $null, 'Process')
    if ($TraceGit) { $env:GIT_TRACE2_EVENT = $gitTrace.Replace('\', '/') }
    $goBinary = (Get-Command go -ErrorAction Stop).Source
    $arguments = @('test') + $Packages + @('-run', $Filter, '-count=1', "-timeout=$Timeout", '-json')
    if ($PackageParallelism -gt 0) { $arguments += @('-p', "$PackageParallelism") }
    $watch = [Diagnostics.Stopwatch]::StartNew()
    & $goBinary @arguments | Tee-Object -FilePath (Join-Path $outputRoot 'tests.jsonl')
    $testExit = $LASTEXITCODE
    $watch.Stop()
    Write-Output "Go exit=$testExit; wall_seconds=$($watch.Elapsed.TotalSeconds)"
    $events = Get-Content (Join-Path $outputRoot 'tests.jsonl') | ForEach-Object { $_ | ConvertFrom-Json }
    $events | Where-Object { $_.Action -in @('pass', 'fail', 'skip') -and $_.Test } |
        Sort-Object Elapsed -Descending | Select-Object -First 20 Package, Test, Action, Elapsed | Format-Table -AutoSize
    # Parent/subtest durations overlap: do not sum these rows.
    $events | Where-Object { $_.Action -in @('pass', 'fail', 'skip') -and -not $_.Test } |
        Select-Object Package, Action, Elapsed | Format-Table -AutoSize
    if (Test-Path -LiteralPath $gitTrace) {
        $gitEvents = Get-Content $gitTrace | ForEach-Object { $_ | ConvertFrom-Json }
        Write-Output "Git launches=$(@($gitEvents | Where-Object event -eq 'start').Count)"
    }
}
finally {
    foreach ($name in $priorEnvironment.Keys) {
        [Environment]::SetEnvironmentVariable($name, $priorEnvironment[$name], 'Process')
    }
    Pop-Location
}
exit $testExit
