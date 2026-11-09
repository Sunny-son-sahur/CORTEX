#!/usr/bin/env bash
#
# CORTEX installer — Debian/Ubuntu/Kali only (apt-based).
# Run it yourself after reading it: ./install.sh
# Do NOT pipe this from a URL into bash. Download it, read it, run it.

set -euo pipefail

if ! command -v apt-get &>/dev/null; then
    echo "[!] This installer needs apt-get (Debian/Ubuntu/Kali)."
    echo "    On macOS or Arch, install the packages below manually,"
    echo "    or run CORTEX inside a Debian/Kali Docker container or VM."
    exit 1
fi

PACKAGES=(
    nmap            # recon
    whois           # recon
    whatweb         # recon
    wpscan          # recon / web hacking
    hydra           # password attacks
    ncrack          # password attacks
    cupp            # password attacks
    aircrack-ng     # wireless (provides airodump-ng)
    reaver          # wireless
    pixiewps        # wireless
    sqlmap          # exploitation
    commix          # exploitation
    metasploit-framework  # exploitation
    sslstrip        # sniffing/spoofing
    tcpdump         # sniffing/spoofing
    set             # social-engineer toolkit (may need a separate PPA/repo)
    gobuster        # web hacking
    arachni         # web hacking
    netcat-openbsd  # post exploitation
    curl            # post exploitation
)

echo "[*] CORTEX installer"
echo "[*] about to install: ${PACKAGES[*]}"
read -rp "proceed? [y/N] " confirm
if [[ "${confirm,,}" != "y" ]]; then
    echo "[*] aborted."
    exit 0
fi

sudo apt-get update
for pkg in "${PACKAGES[@]}"; do
    echo "[*] installing $pkg..."
    sudo apt-get install -y "$pkg" || echo "[!] $pkg failed or needs a separate repo — skipping."
done

echo "[*] done. some tools (setoolkit, weeman, brutex, shellnoob, pixiewps) may not be"
echo "    in default apt repos — check their GitHub repos if apt couldn't find them."
echo "[*] run CORTEX with: python3 cortex.py"
