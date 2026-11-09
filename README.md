# CORTEX

A menu-driven launcher for pentest tools. Python 3, no shell=True, no
piped-curl-into-bash installer by default — one-liners below are opt-in.
CORTEX doesn't reimplement nmap or sqlmap; it's a front end that calls the
real tools on your system.

## Menu

- Information Gathering — nmap, whois, host-to-IP, WPScan, whatweb, dork helper
- Password Attacks — hydra, ncrack, cupp
- Wireless Testing — airodump-ng, reaver, pixiewps
- Exploitation Tools — sqlmap, commix, msfconsole, shellnoob
- Sniffing & Spoofing — setoolkit, sslstrip, tcpdump
- Web Hacking — WPScan plugin enum, gobuster, brutex, arachni
- Post Exploitation — netcat listener, weeman, shell checker

# Installation

## Linux

[Linux](https://wikipedia.org/wiki/Linux)

```bash
git clone https://github.com/Sunny-son-sahur/CORTEX.git
cd CORTEX
chmod +x install.sh
./install.sh
```

Or the one-liner:

```bash
bash <(curl -sL https://tinyurl.com/CORTEX-DOWNLOAD)
```

## Termux (Android)

Download [Termux](https://play.google.com/store/apps/details?id=com.termux)

```bash
pkg install git python -y
git clone https://github.com/Sunny-son-sahur/CORTEX.git
cd CORTEX
chmod +x install.sh
./install.sh
```

## Windows

[Windows](https://wikipedia.org/wiki/Microsoft_Windows)

CORTEX's installer is apt-based, so native Windows won't run it directly. Use one of:

- [WSL](https://learn.microsoft.com/en-us/windows/wsl/install) (Ubuntu) — then follow the Linux steps above
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) — see Docker Usage below
- [Cygwin](https://www.cygwin.com/) if you want a bare bash-like layer (you'll still need Docker/WSL for apt)

## Docker Usage

### Dependencies

[Docker](https://www.docker.com/) · [Docker Compose](https://docs.docker.com/compose/install/)

```bash
docker-compose build
docker-compose up -d
docker-compose exec cortex python3 cortex.py
docker-compose down   # destroys instance
```

## Run

```bash
python3 cortex.py
```

Each menu item is tagged `[not installed]` if the underlying binary isn't on
your PATH, so you know before you pick it.

## Updating / Uninstalling

```bash
./update.sh      # git pull + re-run installer for new deps
./uninstall       # remove installed packages + ~/.cortex
```

Or the one-liners:

```bash
bash <(curl -sL https://tinyurl.com/CORTEX-UPDATE)      # update
bash <(curl -sL https://tinyurl.com/CORTEX-UNDOWNLOAD)  # uninstall
```

Note: the update one-liner only works if you already have a cloned copy of
this repo in your current directory — `update.sh` runs `git pull`, which
needs an actual git checkout to pull into. If you ran it from somewhere
else, it'll just tell you so instead of doing anything destructive.

See `docs/usage.md` for per-category notes and `CONTRIBUTING.md` for how to
add a new tool wrapper.

## Scope

This is a launcher, not a magic box. It wraps real, well-known security
tools for authorized testing and research. Point it at systems you own or
have explicit permission to test.

## License

MIT — see `LICENSE`.
