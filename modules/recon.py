import socket
from modules import run, prompt, menu_loop, Colors


def nmap_scan():
    target = prompt("target (IP/domain)")
    if not target:
        return
    mode = prompt("scan type [quick/full/stealth] (default quick)") or "quick"
    flags = {
        "quick": ["-T4", "-F"],
        "full": ["-T4", "-p-", "-A"],
        "stealth": ["-sS", "-T2"],
    }.get(mode, ["-T4", "-F"])
    run(["nmap", *flags, target])


def host_to_ip():
    host = prompt("hostname")
    if not host:
        return
    try:
        print(f"{Colors.GREEN}{host} -> {socket.gethostbyname(host)}{Colors.RESET}")
    except socket.gaierror as e:
        print(f"{Colors.RED}[!] resolution failed: {e}{Colors.RESET}")


def whois_lookup():
    target = prompt("domain")
    if target:
        run(["whois", target])


def wpscan():
    url = prompt("wordpress URL (https://target.com)")
    if url:
        run(["wpscan", "--url", url, "--enumerate", "vp,vt,u"])


def cms_scan():
    url = prompt("target URL")
    if url:
        print(f"{Colors.YELLOW}[*] CMSeeK / whatweb must be installed separately.{Colors.RESET}")
        run(["whatweb", url])


def dork_search():
    dork = prompt("google dork query")
    if dork:
        print(f"{Colors.YELLOW}[*] no scripted scraping here — open manually:{Colors.RESET}")
        print(f"    https://www.google.com/search?q={dork.replace(' ', '+')}")


MENU = {
    "1": ("Nmap port/service scan", nmap_scan, "nmap"),
    "2": ("Host to IP", host_to_ip, None),
    "3": ("Whois lookup", whois_lookup, "whois"),
    "4": ("WPScan (WordPress)", wpscan, "wpscan"),
    "5": ("CMS fingerprint (whatweb)", cms_scan, "whatweb"),
    "6": ("Google dork helper", dork_search, None),
}


def menu():
    menu_loop("INFORMATION GATHERING", MENU)
