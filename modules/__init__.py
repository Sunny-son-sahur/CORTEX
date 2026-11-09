"""
CORTEX shared helpers.
Every module imports from here so the menu/run pattern stays identical
across categories.
"""
import shutil
import subprocess
import sys


class Colors:
    RED = "\033[91m"
    GREEN = "\033[92m"
    YELLOW = "\033[93m"
    CYAN = "\033[96m"
    BOLD = "\033[1m"
    RESET = "\033[0m"


def check_installed(binary: str) -> bool:
    """Return True if `binary` is on PATH."""
    return shutil.which(binary) is not None


def run(cmd: list[str]):
    """
    Run a command, streaming output live instead of buffering it.
    `cmd` is a list (no shell=True, no string-built commands — avoids
    shell injection from anything the user types into a prompt).
    """
    try:
        subprocess.run(cmd, check=False)
    except FileNotFoundError:
        print(f"{Colors.RED}[!] '{cmd[0]}' not found. Install it first "
              f"(see install.sh or run option 0 in this menu).{Colors.RESET}")
    except KeyboardInterrupt:
        print(f"\n{Colors.YELLOW}[*] interrupted.{Colors.RESET}")


def prompt(label: str) -> str:
    try:
        return input(f"{Colors.CYAN}{label}: {Colors.RESET}").strip()
    except (EOFError, KeyboardInterrupt):
        print()
        return ""


def print_menu(title: str, options: dict):
    print(f"\n{Colors.BOLD}{Colors.RED}== {title} =={Colors.RESET}")
    for key, (desc, _fn, *_rest) in options.items():
        tag = ""
        bin_name = _rest[0] if _rest else None
        if bin_name and not check_installed(bin_name):
            tag = f" {Colors.YELLOW}[not installed]{Colors.RESET}"
        print(f"  {Colors.GREEN}{key}{Colors.RESET}) {desc}{tag}")
    print(f"  {Colors.GREEN}0{Colors.RESET}) back")


def menu_loop(title: str, options: dict):
    """
    options = {
        "1": ("Description shown in menu", callback_fn, "required_binary_or_None"),
    }
    callback_fn takes no args.
    """
    while True:
        print_menu(title, options)
        choice = prompt("select")
        if choice == "0" or choice == "":
            return
        if choice in options:
            options[choice][1]()
        else:
            print(f"{Colors.RED}[!] invalid option{Colors.RESET}")
