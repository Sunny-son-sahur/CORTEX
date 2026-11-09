#!/usr/bin/env bash
#
# CORTEX installer — apt (Debian/Ubuntu/Kali) and dnf (Fedora/Nobara/RHEL).
# Run it yourself after reading it: ./install.sh
# Do NOT pipe this from a URL into bash without having read it first.

set -euo pipefail

CORTEX_HOME="$HOME/.cortex"
BIN_DIR="$HOME/.local/bin"
LAUNCHER="$BIN_DIR/cortex"

echo "[*] CORTEX installer"

# ---- detect package manager ----
if command -v apt-get &>/dev/null; then
    PM="apt"
elif command -v dnf &>/dev/null; then
    PM="dnf"
else
    echo "[!] neither apt-get nor dnf found. Install dependencies manually"
    echo "    or run CORTEX inside the Docker container (docker-compose up)."
    exit 1
fi
echo "[*] detected package manager: $PM"

# ---- package names per distro family ----
# Not everything maps cleanly. Fedora/Nobara don't ship several of these
# in their default repos at all (Metasploit, WPScan, Commix, Reaver,
# Pixiewps, SSLstrip, BruteX, Arachni, CUPP, Weeman, Setoolkit) — those
# are noted below instead of silently failing or faking a package name.
if [[ "$PM" == "apt" ]]; then
    PACKAGES=(
        nmap whois whatweb wpscan hydra ncrack cupp aircrack-ng reaver
        pixiewps sqlmap commix metasploit-framework sslstrip tcpdump
        gobuster arachni netcat-openbsd curl
    )
    MANUAL_NOTE=""
else
    # dnf: Fedora/Nobara. Only what's realistically in the official
    # or RPM Fusion repos.
    PACKAGES=(
        nmap whois sqlmap hydra aircrack-ng tcpdump nmap-ncat curl
    )
    MANUAL_NOTE="wpscan (ruby gem: sudo gem install wpscan), commix/reaver/
pixiewps/sslstrip/brutex/arachni/cupp/ncrack/weeman/setoolkit are not in
Fedora/Nobara repos — install from their GitHub repos manually, or just
run CORTEX via Docker instead, where the apt-based image handles all of
this for you."
fi

echo "[*] about to install: ${PACKAGES[*]}"
read -rp "proceed? [y/N] " confirm
if [[ "${confirm,,}" != "y" ]]; then
    echo "[*] aborted."
    exit 0
fi

if [[ "$PM" == "apt" ]]; then
    sudo apt-get update
    for pkg in "${PACKAGES[@]}"; do
        echo "[*] installing $pkg..."
        sudo apt-get install -y "$pkg" || echo "[!] $pkg failed or needs a separate repo — skipping."
    done
else
    for pkg in "${PACKAGES[@]}"; do
        echo "[*] installing $pkg..."
        sudo dnf install -y "$pkg" || echo "[!] $pkg not found in your repos — skipping."
    done
    echo ""
    echo "[!] not available via dnf, install manually if you need them:"
    echo "$MANUAL_NOTE"
fi

# ---- install CORTEX itself so it runs as a global command ----
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo ""
echo "[*] installing CORTEX to $CORTEX_HOME ..."
mkdir -p "$CORTEX_HOME"
cp -r "$SCRIPT_DIR"/* "$CORTEX_HOME"/

mkdir -p "$BIN_DIR"
cat > "$LAUNCHER" << 'LAUNCHER_EOF'
#!/usr/bin/env bash
exec python3 "$HOME/.cortex/cortex.py" "$@"
LAUNCHER_EOF
chmod +x "$LAUNCHER"

if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
    echo "[!] $BIN_DIR isn't on your PATH yet. Add this to your ~/.bashrc or ~/.zshrc:"
    echo "    export PATH=\"\$HOME/.local/bin:\$PATH\""
    echo "    then restart your shell or 'source' that file."
fi

echo "[*] done. run it from anywhere with: cortex"
