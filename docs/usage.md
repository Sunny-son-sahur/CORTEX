# CORTEX usage notes

Extra detail that didn't fit in the main README.

## Per-category notes

**Information Gathering** — `nmap`'s "stealth" mode (`-sS -T2`) needs root
on Linux/macOS (raw sockets). Run CORTEX with `sudo` if you pick it and it
silently fails.

**Password Attacks** — hydra/ncrack expect wordlist files you already have.
Common ones (rockyou.txt etc.) aren't bundled here; grab them from
SecLists (`github.com/danielmiessler/SecLists`) and point the prompt at the
path.

**Wireless Testing** — airodump-ng/reaver require a wireless adapter in
monitor mode and won't do anything useful through a USB-passthrough VM
unless the adapter supports packet injection. Check adapter compatibility
before assuming a failure is CORTEX's fault.

**Exploitation Tools** — `msfconsole` hands off entirely to Metasploit;
CORTEX just launches it, nothing more.

**Web Hacking** — `gobuster` needs a wordlist; the default path assumes a
Kali-style `/usr/share/wordlists/dirb/common.txt`. Override it at the
prompt if your system doesn't have that layout.

**Post Exploitation** — the netcat listener (`nc -lvnp <port>`) is just a
raw listener. Pair it with a matching reverse-shell payload on the target
side; CORTEX doesn't generate payloads itself.

## Scope reminder

Every wrapper in this repo assumes you have authorization to run these
tools against the target. That's on you, not on the menu.
