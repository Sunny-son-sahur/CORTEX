#!/usr/bin/env bash
# Pull the latest CORTEX from git and re-sync dependencies.

set -euo pipefail

if [[ ! -d .git ]]; then
    echo "[!] not a git checkout — can't auto-update. git clone the repo instead."
    exit 1
fi

echo "[*] fetching latest..."
git pull --ff-only

echo "[*] re-running installer to pick up any new dependencies..."
chmod +x install.sh
./install.sh

echo "[*] update complete."
