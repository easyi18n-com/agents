#!/bin/sh
# Finds or installs the easyi18n CLI this plugin is pinned to (../cli-version).
#
#   ensure-cli.sh            SessionStart/Setup hook: silent when nothing to do
#   ensure-cli.sh exec ARGS  what bin/easyi18n-mcp runs: `easyi18n ARGS`
#
# Candidates, in order: `easyi18n` on PATH, `dart pub global run`, the binary
# cached in $CLAUDE_PLUGIN_DATA. One counts only if its --version is exactly
# the pin: someone else's npm package also installs an `easyi18n`, and an old
# one from pub.dev has no `mcp`. A cache that fails that check is reinstalled
# from the pinned Release with that Release's own install.sh, which verifies
# the sha256.
#
# Nothing goes to stdout before the exec: under MCP it is the JSON-RPC channel.
set -eu

root="$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)"
pin="$(tr -d '\r\n' < "$root/cli-version")"
data="${CLAUDE_PLUGIN_DATA:-${HOME}/.cache/easyi18n-plugin}"
case "$(uname -s)" in
  MINGW* | MSYS* | CYGWIN*) bin="$data/cli/$pin/easyi18n.exe" ;;
  *) bin="$data/cli/$pin/easyi18n" ;;
esac

mode=check
if [ "${1:-}" = exec ]; then
  mode=exec
  shift
fi

die() {
  echo "easyi18n plugin: $*" >&2
  exit 1
}

reports_pin() {
  out="$("$@" --version 2>/dev/null)" || return 1
  [ "$(printf %s "$out" | tr -d '\r')" = "easyi18n $pin" ]
}

use() {
  [ "$mode" = exec ] || exit 0
  exec "$@"
}

if command -v easyi18n >/dev/null 2>&1 && reports_pin easyi18n; then
  use easyi18n "$@"
fi
if command -v dart >/dev/null 2>&1 && reports_pin dart pub global run easyi18n_cli:easyi18n; then
  use dart pub global run easyi18n_cli:easyi18n "$@"
fi

if ! reports_pin "$bin"; then
  releases="${EASYI18N_RELEASES_URL:-https://github.com/liontude/easyi18n-dart/releases}"
  url="$releases/download/cli-v$pin/install.sh"
  tmp="$(mktemp -d "${TMPDIR:-/tmp}/easyi18n-plugin.XXXXXX")"
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL -o "$tmp/install.sh" "$url" >&2 || { rm -rf "$tmp"; die "download failed: $url"; }
  elif command -v wget >/dev/null 2>&1; then
    wget -q -O "$tmp/install.sh" "$url" >&2 || { rm -rf "$tmp"; die "download failed: $url"; }
  else
    rm -rf "$tmp"
    die "needs curl or wget to install easyi18n $pin"
  fi
  EASYI18N_VERSION="$pin" EASYI18N_INSTALL_DIR="$(dirname "$bin")" EASYI18N_RELEASES_URL="$releases" \
    sh "$tmp/install.sh" >&2 || { rm -rf "$tmp"; die "could not install easyi18n $pin"; }
  rm -rf "$tmp"
  for old in "$data/cli"/*; do
    [ "$old" = "$data/cli/$pin" ] || rm -rf "$old"
  done
fi
use "$bin" "$@"
