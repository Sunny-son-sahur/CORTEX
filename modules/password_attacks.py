from modules import run, prompt, menu_loop


def hydra_attack():
    target = prompt("target IP/host")
    service = prompt("service [ssh/ftp/http-post-form/...] (default ssh)") or "ssh"
    user = prompt("username (or path to userlist with -L)")
    wordlist = prompt("password wordlist path")
    if not (target and user and wordlist):
        return
    run(["hydra", "-l", user, "-P", wordlist, f"{service}://{target}"])


def ncrack_attack():
    target = prompt("target IP")
    service = prompt("service [ssh/rdp/ftp] (default ssh)") or "ssh"
    wordlist = prompt("password wordlist path")
    if not (target and wordlist):
        return
    run(["ncrack", f"-p{service}", f"--user", prompt("username"), "-P", wordlist, target])


def cupp_generate():
    print("[*] CUPP builds a wordlist from personal info about the target.")
    run(["cupp", "-i"])


MENU = {
    "1": ("Hydra (network login cracker)", hydra_attack, "hydra"),
    "2": ("Ncrack (network auth cracker)", ncrack_attack, "ncrack"),
    "3": ("CUPP (common user passwords profiler)", cupp_generate, "cupp"),
}


def menu():
    menu_loop("PASSWORD ATTACKS", MENU)
