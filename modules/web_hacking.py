from modules import run, prompt, menu_loop


def wp_plugin_scan():
    url = prompt("wordpress URL")
    if url:
        run(["wpscan", "--url", url, "--enumerate", "p"])


def dir_finder():
    url = prompt("target URL (https://target.com)")
    wordlist = prompt("wordlist path (default /usr/share/wordlists/dirb/common.txt)") \
        or "/usr/share/wordlists/dirb/common.txt"
    if url:
        run(["gobuster", "dir", "-u", url, "-w", wordlist])


def brutex_scan():
    target = prompt("target IP/host")
    if target:
        run(["brutex", target])


def arachni_scan():
    url = prompt("target URL")
    if url:
        run(["arachni", url])


MENU = {
    "1": ("WPScan plugin enumeration", wp_plugin_scan, "wpscan"),
    "2": ("Directory/file finder (gobuster)", dir_finder, "gobuster"),
    "3": ("BruteX (brute force all open services)", brutex_scan, "brutex"),
    "4": ("Arachni (web app scanner)", arachni_scan, "arachni"),
}


def menu():
    menu_loop("WEB HACKING", MENU)
