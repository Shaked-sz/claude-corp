#!/usr/bin/env bash
set -e
mkdir -p "$(dirname 'README.md')"
cat > 'README.md' <<'FIXTURE'
# Demo

Install teh plugin, then run it.
FIXTURE
