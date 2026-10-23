#!/bin/bash
{
# Truncation guard: this brace group opens on line 2 and closes on the last
# line, so bash must read the entire file before it runs any command. On the
# `curl ... | bash` path, a download cut off anywhere before the final `}` is
# an unterminated compound command, which bash reports as a syntax error at
# EOF without running anything. Without the guard, a cut right after `set`
# would run the bare builtin and print every shell variable, and a cut right
# after `main` would run the installer without the caller's flags.
#
# ULTAPALTA installer — one line from anywhere:
#   curl -fsSL https://raw.githubusercontent.com/raaj33b/ultapalta/main/install.sh | bash
#
# Adapted from the REA installer (morluto/rea, MIT) with Bengali-first step
# messaging, npm-latest default resolution, and Termux support.
set -euo pipefail

PACKAGE="ultapalta"
REPOSITORY="raaj33b/ultapalta"
numeric_identifier='(0|[1-9][0-9]*)'
prerelease_identifier="(${numeric_identifier}|[0-9A-Za-z-]*[A-Za-z-][0-9A-Za-z-]*)"
build_identifier='[0-9A-Za-z-]+'
version_pattern="${numeric_identifier}\\.${numeric_identifier}\\.${numeric_identifier}(-${prerelease_identifier}(\\.${prerelease_identifier})*)?(\\+${build_identifier}(\\.${build_identifier})*)?"
version="${ULTAPALTA_VERSION:-}"
version_requested=false
dry_run=false
start_setup=true
verbose=false

# Termux reports Linux with OSTYPE=linux-android and prefixes everything with
# /com.termux. Treat it as a first-class install target with its own npm layout.
termux=false
if [ "${OSTYPE:-}" = "linux-android" ] || case "${PREFIX:-}" in /com.termux*) true;; *) false;; esac; then
  termux=true
fi

fail() {
  printf 'উল্টাপাল্টা installation failed: %s\n' "$1" >&2
  exit 1
}

note() {
  printf '%s\n' "$1"
}

# Bash can return status 0 while parsing an incomplete [[ condition. Keep that
# grammar in a constant quoted expression so truncated downloads fail while
# parsing the outer brace group. eval parses only this literal; the arguments
# are expanded as data by the conditional, not interpolated into shell code.
matches() {
  eval '[[ "$1" =~ $2 ]]'
}

banner() {
  cat <<'EOF'
┌───────────────────────────────────────────────┐
│   উল্টাপাল্টা · ULTAPALTA                      │
│   কাজের জিনিস, আজব স্টাইলে।                    │
└───────────────────────────────────────────────┘
EOF
}

usage() {
  cat <<'EOF'
Usage: install.sh [--version VERSION] [--dry-run] [--no-setup] [--no-prompt] [--verbose]

Installs the ULTAPALTA CLI (Bengali-first reverse-engineering toolkit), then
starts `ultapalta setup` interactively to configure Hopper and agents when a
terminal is available. Pass --no-setup (or --no-prompt) to skip setup and run
`ultapalta setup` later.

Environment:
  ULTAPALTA_VERSION   same as --version
  ULTAPALTA_LANG=en   English CLI messages (default: Bengali)
EOF
}

# Exit with actionable remediation when the active Node.js is unsupported.
# The engine floor stays in sync with package.json#engines.node — change both.
fail_node_version() {
  local observed="$1"
  if [ "$termux" = true ]; then
    printf 'উল্টাপাল্টা installation failed: Node.js %s is unsupported (need 22.19+/24.11+/26+).\n\n' "$observed" >&2
    printf 'On Termux run:\n  pkg install nodejs\nThen rerun this installer.\n' >&2
    exit 1
  fi
  printf 'উল্টাপাল্টা installation failed: Node.js %s is unsupported.\n\n' "$observed" >&2
  printf 'ULTAPALTA requires Node.js 22.x (>=22.19), 24.x (>=24.11), or 26+. Install one via:\n' >&2
  printf '  nvm:  nvm install 24 && nvm use 24      (https://github.com/nvm-sh/nvm)\n' >&2
  printf '  fnm:  fnm install 24 && fnm use 24      (https://github.com/Schniz/fnm)\n' >&2
  printf '  Direct download: https://nodejs.org/dist/latest-v24.x/\n' >&2
  printf 'Then rerun this installer.\n' >&2
  exit 1
}

main() {
  while (($# > 0)); do
    case "$1" in
      --version)
        (($# >= 2)) || fail "--version requires a value."
        version="$2"
        version_requested=true
        shift 2
        ;;
      --dry-run)
        dry_run=true
        shift
        ;;
      --no-setup|--no-prompt)
        start_setup=false
        shift
        ;;
      --verbose)
        verbose=true
        shift
        ;;
      --help|-h)
        usage
        exit 0
        ;;
      *) fail "unknown option: $1" ;;
    esac
  done

  if [ "$verbose" = true ]; then
    set -x
  fi

  banner
  note "ধাপ ১/৫ — এনভায়রনমেন্ট দেখে নিচ্ছি (checking environment)…"

  platform="$(uname -s)"
  if [ "$termux" = true ]; then
    note "  ◇ Termux ডিটেক্ট করেছি — Android-এই চলবে।"
  elif case "$platform" in MINGW*|MSYS*|CYGWIN*) true;; *) false;; esac; then
    note "  ◇ Windows (Git Bash/MSYS) ডিটেক্ট করেছি — চলবে, তবে পারলে install.ps1-ই ভালো।"
  else
    [ "$platform" = "Darwin" ] || [ "$platform" = "Linux" ] || fail "ULTAPALTA supports macOS, selected 64-bit Linux distributions, Termux, and Git Bash on Windows."
  fi
  command -v curl >/dev/null 2>&1 || fail "curl is required. Install curl, then rerun this installer."
  if [ "$termux" = true ] && ! command -v ps >/dev/null 2>&1; then
    note "  ! procps নেই — কিছু analysis-র জন্য দরকার হয়। চাইলে পরে চালাও: pkg install procps"
  fi

  note "ধাপ ২/৫ — Node.js চেক করছি (need 22.19+, 24.11+, or 26+)…"
  if ! command -v node >/dev/null 2>&1; then
    if [ "$termux" = true ]; then
      fail "Node.js is required. Run: pkg install nodejs — তারপর আবার এই installer চালাও।"
    fi
    fail "Node.js 22.x (>=22.19), 24.x (>=24.11), or 26+ is required; install it from https://nodejs.org and retry."
  fi
  command -v npm >/dev/null 2>&1 || fail "npm is required; install it with Node.js and retry."

  node_version="$(node -p 'process.versions.node' 2>/dev/null || true)"
  IFS=. read -r node_major node_minor _node_patch <<<"$node_version"
  matches "$node_major" '^[0-9]+$' && matches "$node_minor" '^[0-9]+$' || fail "the active Node.js version could not be read. Check that node works and is on PATH, then retry."
  if ! matches "$_node_patch" '^[0-9]+(\+[0-9A-Za-z.-]+)?$' ||
    ! ((node_major == 22 && node_minor >= 19 || node_major == 24 && node_minor >= 11 || node_major >= 26)); then
    fail_node_version "$node_version"
  fi
  note "  ◇ Node.js ${node_version} — ঠিক আছে।"

  note "ধাপ ৩/৫ — ভার্সন ঠিক করছি (resolving version)…"
  if [ "$version_requested" = true ] || [ -n "$version" ]; then
    matches "$version" "^${version_pattern}$" || fail "version must be an exact semantic version."
  else
    # Default to the npm `latest` dist-tag so installs keep working before the
    # first GitHub release exists on raaj33b/ultapalta.
    version="latest"
  fi

  # npm's exact-version resolver cleans build metadata from the requested version,
  # so it may install the base release and make the post-install identity check fail.
  if matches "$version" '\+'; then
    fail "npm cannot install an exact version with build metadata. Pass a version without build metadata, then retry."
  fi

  install_args=(install --global)
  if [ "$platform" = "Linux" ] && [ "$termux" = false ]; then
    install_args+=(--prefix "$HOME/.local")
    install_bin="$HOME/.local/bin/ultapalta"
  else
    npm_prefix="$(npm prefix --global)" || fail "the npm global prefix could not be read. Repair the npm configuration, then retry."
    install_bin="$npm_prefix/bin/ultapalta"
  fi
  install_args+=("$PACKAGE@$version")

  note "ধাপ ৪/৫ — ইনস্টল প্ল্যান (install plan):"
  printf '  Version: %s\n' "$version"
  printf '  Runtime: Node.js %s\n' "$node_version"
  printf '  Command:'
  printf ' %q' npm "${install_args[@]}"
  printf '\n'
  printf '  Binary:  %s\n' "$install_bin"
  printf '  Setup:   %s\n' "$([ "$start_setup" = true ] && printf 'টার্মিনাল পেলে শুরু হবে (starts when a terminal is available)' || printf 'স্কিপ (skipped)')"

  if [ "$dry_run" = true ]; then
    note "ড্রাই রান শেষ — কিছুই বদলানো হয়নি (dry run complete; no changes made)।"
    exit 0
  fi

  note "  ◇ ইনস্টল হচ্ছে (installing)…"
  npm "${install_args[@]}" || fail "npm could not install ULTAPALTA. Check registry access and npm permissions, then retry. (npm-এ `ultapalta` পাওয়া না গেলে GitHub থেকে source install করো: দেখো README-র \"source থেকে ইনস্টল\" অংশ।)"
  [ -x "$install_bin" ] || fail "npm completed without installing the ultapalta command. Check the npm global bin directory and PATH, then retry."

  installed_version="$("$install_bin" --version 2>/dev/null | tr -d '[:space:]')" || fail "the installed ULTAPALTA version could not be read. Reinstall the requested version, then retry."
  [ -n "$installed_version" ] || fail "the installed ULTAPALTA version could not be read. Reinstall the requested version, then retry."
  if [ "$version" != "latest" ]; then
    [ "$installed_version" = "$version" ] || fail "installed version $installed_version does not match $version. Reinstall the requested version, then retry."
  fi

  note "ধাপ ৫/৫ — সেটআপ (setup)…"
  note "✓ হয়ে গেছে! উল্টাপাল্টা ${installed_version} ইনস্টল হয়ে গেছে।"
  if [ "$start_setup" = true ] && [ -r /dev/tty ] && [ -w /dev/tty ] && [ -t 1 ] && [ -t 2 ]; then
    note "  সেটআপ উইজার্ড শুরু করছি — agent বাছাই করো (starting setup wizard)…"
    "$install_bin" setup </dev/tty >/dev/tty
  else
    note "  পরে চালাও: ultapalta setup  (হোপার/agent কনফিগার করার জন্য)"
    note "  সব ঠিকঠাক কি না দেখতে:  ultapalta doctor"
  fi
}

main "$@"
exit $?
}
