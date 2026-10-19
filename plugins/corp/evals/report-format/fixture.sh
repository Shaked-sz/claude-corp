#!/usr/bin/env bash
set -e
mkdir -p "$(dirname 'README.md')"
cat > 'README.md' <<'FIXTURE'
# Demo

## Install

Run the installer.
FIXTURE
