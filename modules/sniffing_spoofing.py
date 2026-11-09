from modules import run, prompt, menu_loop


def setoolkit():
    print("[*] launching Social-Engineer Toolkit.")
    run(["setoolkit"])


def sslstrip_run():
    port = prompt("listen port (default 8080)") or "8080"
    run(["sslstrip", "-l", port])


def tcpdump_sniff():
    iface = prompt("interface (e.g. eth0, en0)")
    if iface:
        run(["tcpdump", "-i", iface])


MENU = {
    "1": ("Setoolkit (social engineering)", setoolkit, "setoolkit"),
    "2": ("SSLstrip (HTTPS downgrade)", sslstrip_run, "sslstrip"),
    "3": ("tcpdump (packet capture)", tcpdump_sniff, "tcpdump"),
}


def menu():
    menu_loop("SNIFFING & SPOOFING", MENU)
