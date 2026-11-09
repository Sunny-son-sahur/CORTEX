#!/usr/bin/env bash
#
# CORTEX installer — apt (Debian/Ubuntu/Kali) and dnf (Fedora/Nobara/RHEL).
# Run it yourself after reading it: ./install.sh
# Do NOT pipe this from a URL into bash without having read it first.

set -euo pipefail

CORTEX_HOME="$HOME/.cortex"
BIN_DIR="$HOME/.local/bin"
LAUNCHER="$BIN_DIR/cortex"
TOOLS_DIR="$HOME/.cortex-tools"   # for git-cloned installers (brutex, etc)

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

if ! command -v git &>/dev/null; then
    echo "[*] git not found, installing it first..."
    if [[ "$PM" == "apt" ]]; then
        sudo apt-get install -y git
    else
        sudo dnf install -y git
    fi
fi

# ---- package names per distro family ----
if [[ "$PM" == "apt" ]]; then
    PACKAGES=(
        nmap whois whatweb wpscan hydra ncrack cupp aircrack-ng reaver
        pixiewps sqlmap commix metasploit-framework sslstrip tcpdump
        gobuster arachni netcat-openbsd curl ruby ruby-dev golang-go
    )
else
    # dnf: Fedora/Nobara. What's actually in Fedora's official + RPM Fusion repos.
    PACKAGES=(
        nmap whois sqlmap hydra aircrack-ng tcpdump nmap-ncat curl
        ruby ruby-devel gcc make redhat-rpm-config golang
    )
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
fi

# ---- fill the gaps dnf (and some apt setups) leave: wpscan, gobuster,
#      commix, reaver/pixiewps, ncrack, cupp, brutex, arachni, sslstrip,
#      setoolkit, weeman — chase each down through its real install path
#      instead of pretending a dnf package exists for it.
echo ""
echo "[*] installing tools not covered by $PM..."
mkdir -p "$TOOLS_DIR"

install_gem() {
    local gem="$1"
    if ! command -v "$gem" &>/dev/null; then
        echo "[*] gem install $gem"
        sudo gem install "$gem" || echo "[!] $gem gem install failed — skipping."
    fi
}

install_go_tool() {
    local name="$1" module="$2"
    if ! command -v "$name" &>/dev/null; then
        echo "[*] go install $module"
        go install "$module@latest" 2>&1 | tail -5 || echo "[!] $name go install failed — skipping."
    fi
}

clone_and_run() {
    local name="$1" repo="$2" installer="${3:-install.sh}"
    if ! command -v "$name" &>/dev/null; then
        echo "[*] cloning + installing $name from $repo"
        local dest="$TOOLS_DIR/$name"
        if [[ ! -d "$dest" ]]; then
            git clone --depth=1 "$repo" "$dest" || { echo "[!] clone of $name failed — skipping."; return; }
        fi
        (cd "$dest" && chmod +x "$installer" && sudo ./"$installer") \
            || echo "[!] $name installer failed — may need manual setup, see $dest"
    fi
}

install_gem wpscan
install_go_tool gobuster github.com/OJ/gobuster/v3
clone_and_run setoolkit https://github.com/trustedsec/social-engineer-toolkit
clone_and_run weeman https://github.com/evait-security/weeman
clone_and_run brutex https://github.com/1N3/BruteX

if [[ "$PM" == "dnf" ]]; then
    # these have no dnf package and no clean auto-installer — commix/
    # reaver/pixiewps/ncrack/cupp/sslstrip/arachni. Note instead of lying
    # about having fixed it.
    MISSING_MANUAL="commix reaver pixiewps ncrack cupp sslstrip arachni"
    echo ""
    echo "[!] still need manual install (no dnf package, no reliable auto-install):"
    echo "    $MISSING_MANUAL"
    echo "    check their GitHub repos directly, or run CORTEX via Docker"
    echo "    instead where the apt image covers these."
fi

if command -v go &>/dev/null; then
    GOBIN_PATH="$(go env GOPATH 2>/dev/null)/bin"
    if [[ ":$PATH:" != *":$GOBIN_PATH:"* ]]; then
        echo "[!] add this to your ~/.bashrc or ~/.zshrc so go-installed tools (gobuster) resolve:"
        echo "    export PATH=\"$GOBIN_PATH:\$PATH\""
    fi
fi

# ---- install CORTEX itself so it runs as a global command ----
# Hardcoded clone instead of copying from $SCRIPT_DIR: when this script is
# run via `bash <(curl ...)`, there IS no real script path on disk to copy
# from (it's a process-substitution fd). Cloning fresh works no matter how
# this script was invoked — local file, piped, whatever.
REPO_URL="https://github.com/Sunny-son-sahur/CORTEX.git"

echo ""
if [[ -d "$CORTEX_HOME/.git" ]]; then
    echo "[*] $CORTEX_HOME already exists, pulling latest..."
    git -C "$CORTEX_HOME" pull --ff-only
else
    echo "[*] cloning CORTEX to $CORTEX_HOME ..."
    rm -rf "$CORTEX_HOME"
    git clone --depth=1 "$REPO_URL" "$CORTEX_HOME"
fi

mkdir -p "$BIN_DIR"
cat > "$LAUNCHER" << 'LAUNCHER_EOF'
#!/usr/bin/env bash
# Most menu items here (raw sockets, monitor-mode wireless, binding low
# ports) need root anyway, so this re-execs itself with sudo if it isn't
# already running as one. That means EVERYTHING run from this menu,
# including mistakes, runs as root. Know that going in.
if [[ "$(id -u)" -ne 0 ]]; then
    exec sudo python3 "$HOME/.cortex/cortex.py" "$@"
else
    exec python3 "$HOME/.cortex/cortex.py" "$@"
fi
LAUNCHER_EOF
chmod +x "$LAUNCHER"

if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
    echo "[!] $BIN_DIR isn't on your PATH yet. Add this to your ~/.bashrc or ~/.zshrc:"
    echo "    export PATH=\"\$HOME/.local/bin:\$PATH\""
    echo "    then restart your shell or 'source' that file."
fi

echo ""
echo "[*] done. run it from anywhere with: cortex"
echo "[*] it will now prompt for your sudo password every launch — that's expected."
