#!/usr/bin/env bash
# Global npm packages and `go install` tools that Homebrew does not provide.
# Run after scripts/homebrew.sh. DRY_RUN=1 prints commands without running them.
set -euo pipefail

for brew in /opt/homebrew/bin/brew /usr/local/bin/brew; do
  [[ -x $brew ]] && { eval "$("$brew" shellenv)"; break; }
done

for tool in npm go; do
  if ! command -v "$tool" >/dev/null; then
    echo "error: $tool not found. Run scripts/homebrew.sh first." >&2
    exit 1
  fi
done

run() {
  echo "+ $*"
  [[ ${DRY_RUN:-0} == 1 ]] || "$@"
}

run npm install -g skills gh-axi chrome-devtools-axi gnhf
run go install github.com/kunchenguid/no-mistakes/cmd/no-mistakes@latest
