<#
  উল্টাপাল্টা · ULTAPALTA — one-line Windows installer (PowerShell)

  Main attraction — anyone with a terminal can run:
    irm https://raw.githubusercontent.com/raaj33b/ultapalta/main/install.ps1 | iex

  What it does, serially:
    ধাপ ১/৫  environment check (Windows, PowerShell)
    ধাপ ২/৫  Node.js check (22.19+ / 24.11+ / 26+; winget offer when missing)
    ধাপ ৩/৫  version + install plan
    ধাপ ৪/৫  npm global install (source-install fallback from GitHub)
    ধাপ ৫/৫  `ultapalta setup` wizard (agent registration)

  Flags (when running as a file):
    .\install.ps1 [-Version 3.0.0] [-DryRun] [-NoSetup] [-NoPrompt]

  Environment equivalents (when piped through iex):
    $env:ULTAPALTA_VERSION / $env:ULTAPALTA_NO_SETUP = '1'

  Adapted from the REA project (morluto/rea, MIT). No elevation required:
  the CLI installs into the user's npm global prefix.
#>
[CmdletBinding()]
param(
  [string]$Version = '',
  [switch]$DryRun,
  [switch]$NoSetup,
  [switch]$NoPrompt
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 2.0

$Package = 'ultapalta'
$Repository = 'raaj33b/ultapalta'
if ($env:ULTAPALTA_VERSION) { $Version = $env:ULTAPALTA_VERSION }
if ($env:ULTAPALTA_NO_SETUP -eq '1') { $NoSetup = $true }

try { [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 } catch { }

function Write-Step($Number, $Message) {
  Write-Host ''
  Write-Host ("ধাপ {0}/৫ — {1}" -f $Number, $Message) -ForegroundColor Yellow
}

function Write-Ok($Message) { Write-Host ("  ◇ {0}" -f $Message) -ForegroundColor Green }
function Write-Warn2($Message) { Write-Host ("  ! {0}" -f $Message) -ForegroundColor DarkYellow }
function Fail($Message) {
  Write-Host ("  ✗ উল্টাপাল্টা installation failed: {0}" -f $Message) -ForegroundColor Red
  exit 1
}

function Test-NodeVersion([string]$RawVersion) {
  if ($RawVersion -notmatch '^v?(\d+)\.(\d+)\.(\d+)') { return $false }
  $major = [int]$Matches[1]; $minor = [int]$Matches[2]
  return (($major -eq 22 -and $minor -ge 19) -or ($major -eq 24 -and $minor -ge 11) -or $major -ge 26)
}

function Get-CommandOrNull($Name) {
  return Get-Command $Name -ErrorAction SilentlyContinue
}

function Update-PathFromMachine() {
  $machinePath = [Environment]::GetEnvironmentVariable('Path', 'Machine')
  $userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
  if ($machinePath) { $env:Path = "$machinePath" }
  if ($userPath) { $env:Path = "$env:Path;$userPath" }
}

function Install-FromSource([string]$ResolvedVersion) {
  # npm রেজিস্ট্রিতে `ultapalta` না পেলে GitHub source থেকে ইনস্টল।
  Write-Warn2 'npm registry-তে প্যাকেজ পাওয়া যায়নি — GitHub source থেকে ইনস্টল করছি (falling back to source install)…'
  $tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) ('ultapalta-src-' + [guid]::NewGuid().ToString('N').Substring(0, 8))
  $git = Get-CommandOrNull 'git'
  if (-not $git) { Fail 'git is required for the source-install fallback. Install git (winget install Git.Git) and retry.' }
  $cloneArgs = @('clone', '--depth', '1')
  if ($ResolvedVersion -and $ResolvedVersion -ne 'latest') {
    $cloneArgs += @('--branch', "v$ResolvedVersion")
  }
  $cloneArgs += @("https://github.com/$Repository.git", $tempRoot)
  & git @cloneArgs | Out-Null
  if ($LASTEXITCODE -ne 0) { Fail 'git clone failed. Check network access to github.com and retry.' }
  Write-Warn2 '  dependencies নামাচ্ছি (npm install — একটু সময় লাগবে)…'
  Push-Location $tempRoot
  try {
    & npm install --no-audit --no-fund | Out-Null
    if ($LASTEXITCODE -ne 0) { Fail 'npm install failed inside the source checkout.' }
    & npm install --global . | Out-Null
    if ($LASTEXITCODE -ne 0) { Fail 'npm could not link the source install globally.' }
  } finally {
    Pop-Location
  }
}

# ───────────────────────── শুরু ─────────────────────────
Write-Host ''
Write-Host '┌───────────────────────────────────────────────┐' -ForegroundColor Cyan
Write-Host '│   উল্টাপাল্টা · ULTAPALTA                        │' -ForegroundColor Cyan
Write-Host '│   কাজের জিনিস, আজব স্টাইলে।                    │' -ForegroundColor Cyan
Write-Host '└───────────────────────────────────────────────┘' -ForegroundColor Cyan
Write-Host '  Reverse-engineering toolkit — Bangla-first CLI + MCP server.'

Write-Step 1 'এনভায়রনমেন্ট দেখে নিচ্ছি (checking environment)…'
# Windows PowerShell 5.1 predates $IsWindows; PSVersion major < 6 implies Windows.
$isWin = ($PSVersionTable.PSVersion.Major -lt 6) -or $IsWindows
if (-not $isWin) {
  Fail 'this installer is for Windows. On macOS/Linux/Termux use: curl -fsSL https://raw.githubusercontent.com/raaj33b/ultapalta/main/install.sh | bash'
}
$shell = $PSVersionTable.PSVersion.ToString()
Write-Ok ("PowerShell {0} — ঠিক আছে।" -f $shell)

Write-Step 2 'Node.js চেক করছি (need 22.19+, 24.11+, or 26+)…'
$node = Get-CommandOrNull 'node'
$nodeOk = $false
if ($node) {
  $nodeVersion = (& node -p 'process.versions.node' 2>$null)
  if ($LASTEXITCODE -eq 0 -and (Test-NodeVersion $nodeVersion)) {
    $nodeOk = $true
    Write-Ok ("Node.js {0} — ঠিক আছে।" -f $nodeVersion)
  }
}
if (-not $nodeOk) {
  $observed = if ($node) { $nodeVersion } else { 'not found' }
  $winget = Get-CommandOrNull 'winget'
  $interactive = (-not $NoPrompt) -and (-not $env:CI) -and ([Environment]::UserInteractive)
  if ($winget -and $interactive) {
    $answer = Read-Host ("  Node.js নেই/পুরনো ({0})। winget দিয়ে Node.js LTS ইনস্টল করব? [y/N]" -f $observed)
    if ($answer -match '^[Yy]') {
      & winget install --id OpenJS.NodeJS.LTS --source winget --accept-package-agreements --accept-source-agreements | Out-Null
      if ($LASTEXITCODE -ne 0) { Fail 'winget could not install Node.js. Install it manually from https://nodejs.org and rerun.' }
      Update-PathFromMachine
      $node = Get-CommandOrNull 'node'
      $nodeVersion = (& node -p 'process.versions.node' 2>$null)
      if (-not $node -or -not (Test-NodeVersion $nodeVersion)) { Fail ("Node.js is still unsupported after install ({0}). Open a new terminal and rerun." -f $nodeVersion) }
      Write-Ok ("Node.js {0} ইনস্টল হয়ে গেছে।" -f $nodeVersion)
    } else {
      Fail 'Node.js 22.19+/24.11+/26+ is required. Install it from https://nodejs.org and rerun. (কোনো tension নাই — ইনস্টল করে আবার চালাও।)'
    }
  } else {
    Fail ("Node.js {0} is unsupported. Install 22.19+/24.11+/26+ from https://nodejs.org (or winget install OpenJS.NodeJS.LTS) and rerun." -f $observed)
  }
}
$npm = Get-CommandOrNull 'npm'
if (-not $npm) { Fail 'npm is required; it ships with Node.js. Repair the Node.js install and retry.' }

Write-Step 3 'ভার্সন ঠিক করছি (resolving version)…'
if ($Version) {
  if ($Version -notmatch '^(\d+)\.(\d+)\.(\d+)(?:-([0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*))?$') {
    Fail 'version must be an exact semantic version, e.g. 3.0.0'
  }
  $installSpec = "$Package@$Version"
} else {
  $Version = 'latest'
  $installSpec = "$Package@latest"
}
$npmPrefix = (& npm prefix --global)
if ($LASTEXITCODE -ne 0) { Fail 'the npm global prefix could not be read. Repair the npm configuration and retry.' }
$installBin = Join-Path $npmPrefix 'ultapalta.cmd'

Write-Host ''
Write-Host '  ইনস্টল প্ল্যান (install plan):' -ForegroundColor Cyan
Write-Host ("    Version: {0}" -f $Version)
Write-Host ("    Runtime: Node.js {0} / PowerShell {1}" -f $nodeVersion, $shell)
Write-Host ("    Command: npm install --global {0}" -f $installSpec)
Write-Host ("    Binary:  {0}" -f $installBin)
Write-Host ("    Setup:   {0}" -f $(if ($NoSetup) { 'স্কিপ (skipped)' } else { 'উইজার্ড শুরু হবে (wizard starts after install)' }))

if ($DryRun) {
  Write-Host ''
  Write-Host '  ড্রাই রান শেষ — কিছুই বদলানো হয়নি (dry run complete; no changes made)।'
  exit 0
}

Write-Step 4 'ইনস্টল হচ্ছে (installing)…'
$npmOutput = & npm install --global $installSpec 2>&1
if ($LASTEXITCODE -ne 0) {
  $asText = ($npmOutput | Out-String)
  if ($asText -match 'E404') {
    Install-FromSource $Version
  } else {
    Write-Host $npmOutput
    Fail 'npm could not install ULTAPALTA. Check registry access and npm permissions, then retry.'
  }
} else {
  Write-Ok "npm install শেষ।"
}

$ultapalta = Get-CommandOrNull 'ultapalta'
if (-not $ultapalta) {
  Update-PathFromMachine
  $ultapalta = Get-CommandOrNull 'ultapalta'
}
if (-not $ultapalta) { Fail ("the ultapalta command was not found on PATH after install. Check {0} and reopen the terminal." -f $npmPrefix) }
$installedVersion = (& ultapalta --version 2>$null)
if ($LASTEXITCODE -ne 0 -or -not $installedVersion) { Fail 'the installed ULTAPALTA version could not be read. Reinstall and retry.' }
Write-Ok ("উল্টাপাল্টা {0} রেডি।" -f $installedVersion)

Write-Step 5 'সেটআপ (setup)…'
$interactive = (-not $NoSetup) -and ([Environment]::UserInteractive) -and ($Host.Name -eq 'ConsoleHost')
if ($interactive) {
  Write-Host '  সেটআপ উইজার্ড শুরু করছি — agent বাছাই করো (starting setup wizard)…'
  & ultapalta setup
} else {
  Write-Host '  পরে চালাও: ultapalta setup   (agent কনফিগার করার জন্য)'
  Write-Host '  সব ঠিকঠাক কি না দেখতে: ultapalta doctor'
}

Write-Host ''
Write-Host '✓ হয়ে গেছে! এখন ঘাঁটাঘাঁটি শুরু — try:' -ForegroundColor Green
Write-Host '    ultapalta capabilities'
Write-Host '    ultapalta analyze-javascript-application "D:\apps\example"'
Write-Host ''
Write-Host '  ভালো লাগলে GitHub-এ একটা ⭐ দিয়ে থাকো:' -ForegroundColor Cyan
Write-Host "    https://github.com/$Repository"
Write-Host ''
