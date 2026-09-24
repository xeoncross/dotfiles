#!/usr/bin/env bash
# Global npm packages and `go install` tools that Homebrew does not provide.
set -euo pipefail

for brew in /opt/homebrew/bin/brew /usr/local/bin/brew; do
  [[ -x $brew ]] && eval "$("$brew" shellenv)" && break
done

npm install -g skills gh-axi chrome-devtools-axi gnhf
go install github.com/kunchenguid/no-mistakes/cmd/no-mistakes@latest
