from modules import run, prompt, menu_loop


def airodump_scan():
    iface = prompt("monitor-mode interface (e.g. wlan0mon)")
    if iface:
        run(["airodump-ng", iface])


def reaver_attack():
    iface = prompt("monitor-mode interface")
    bssid = prompt("target BSSID")
    channel = prompt("channel")
    if not (iface and bssid):
        return
    cmd = ["reaver", "-i", iface, "-b", bssid, "-vv"]
    if channel:
        cmd += ["-c", channel]
    run(cmd)


def pixiewps_attack():
    pke = prompt("PKE")
    pkr = prompt("PKR")
    e_hash1 = prompt("E-Hash1")
    e_hash2 = prompt("E-Hash2")
    authkey = prompt("Authkey")
    e_nonce = prompt("E-Nonce")
    args = ["pixiewps"]
    for flag, val in (("-e", pke), ("-r", pkr), ("-s", e_hash1),
                       ("-z", e_hash2), ("-a", authkey), ("-n", e_nonce)):
        if val:
            args += [flag, val]
    run(args)


MENU = {
    "1": ("Airodump-ng (capture/scan)", airodump_scan, "airodump-ng"),
    "2": ("Reaver (WPS attack)", reaver_attack, "reaver"),
    "3": ("Pixiewps (offline WPS PIN)", pixiewps_attack, "pixiewps"),
}


def menu():
    menu_loop("WIRELESS TESTING", MENU)
