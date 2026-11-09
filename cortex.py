#!/usr/bin/env python3
"""
CORTEX — a menu-driven launcher for pentest tools.
Python 3. No shell=True anywhere. No piping unknown scripts into bash.
Run with: python3 cortex.py
"""
import sys

from modules import Colors, prompt
from modules import recon, password_attacks, wireless, exploitation
from modules import sniffing_spoofing, web_hacking, post_exploitation

BANNER = r"""
   ____ ___  ____ _____ _______  __
  / ___/ _ \|  _ \_   _| ____\ \/ /
 | |  | | | | |_) || | |  _|  \  /
 | |__| |_| |  _ < | | | |___ /  \
  \____\___/|_| \_\|_| |_____/_/\_\

  CORTEX :: pentest tool launcher
"""

TOP_MENU = {
    "1": ("Information Gathering", recon.menu),
    "2": ("Password Attacks", password_attacks.menu),
    "3": ("Wireless Testing", wireless.menu),
    "4": ("Exploitation Tools", exploitation.menu),
    "5": ("Sniffing & Spoofing", sniffing_spoofing.menu),
    "6": ("Web Hacking", web_hacking.menu),
    "7": ("Post Exploitation", post_exploitation.menu),
}


def print_top_menu():
    print(f"{Colors.RED}{Colors.BOLD}{BANNER}{Colors.RESET}")
    for key, (label, _) in TOP_MENU.items():
        print(f"  {Colors.GREEN}{key}{Colors.RESET}) {label}")
    print(f"  {Colors.GREEN}0{Colors.RESET}) exit")


def main():
    while True:
        print_top_menu()
        choice = prompt("CORTEX")
        if choice == "0":
            print("later.")
            sys.exit(0)
        elif choice in TOP_MENU:
            TOP_MENU[choice][1]()
        else:
            print(f"{Colors.RED}[!] invalid option{Colors.RESET}")


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\nlater.")
        sys.exit(0)
