# CORTEX

A menu-driven launcher for pentest tools. Python 3, no shell=True, no
piped-curl-into-bash installer. CORTEX doesn't reimplement nmap or sqlmap —
it's a front end that calls the real tools on your system.

## Menu

- Information Gathering — nmap, whois, host-to-IP, WPScan, whatweb, dork helper
- Password Attacks — hydra, ncrack, cupp
- Wireless Testing — airodump-ng, reaver, pixiewps
- Exploitation Tools — sqlmap, commix, msfconsole, shellnoob
- Sniffing & Spoofing — setoolkit, sslstrip, tcpdump
- Web Hacking — WPScan plugin enum, gobuster, brutex, arachni
- Post Exploitation — netcat listener, weeman, shell checker

## Install

Debian/Ubuntu/Kali:

```bash
git clone https://github.com/<you>/cortex.git
cd cortex
chmod +x install.sh
./install.sh
```

Read `install.sh` before running it. It's short on purpose.

macOS / other platforms: apt isn't there, so run CORTEX inside a Debian or
Kali Docker container or VM, or install each tool's package manually with
brew/pip where it exists.

### Docker

```bash
docker-compose build
docker-compose up -d
docker-compose exec cortex python3 cortex.py
docker-compose down   # tear it down
```

## Run

```bash
python3 cortex.py
```

## Updating / uninstalling

```bash
./update.sh      # git pull + re-run installer for new deps
./uninstall       # remove installed packages + ~/.cortex
```

See `docs/usage.md` for per-category notes and `CONTRIBUTING.md` for how to
add a new tool wrapper.

Each menu item is tagged `[not installed]` if the underlying binary isn't on
your PATH, so you know before you pick it.

## Scope

This is a launcher, not a magic box. It wraps real, well-known security
tools for authorized testing and research. Point it at systems you own or
have explicit permission to test.

## License

MIT — see `LICENSE`.
