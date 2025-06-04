# SMB-Enumeration
Brute Force to enumerate SMB Shares
# 🔍 SMB Shares Enumeration by Brute Force

**SMB Shares Enumeration by Brute Force** is a simple and effective script that uses `smbclient` to discover available SMB shares on a target system using a custom wordlist.

This tool was created to assist penetration testers in finding **hidden or misconfigured SMB shares** on a Samba/Windows service. It supports both **anonymous** and **authenticated** access modes.

## 💡 Features

- Enumerate SMB shares using `smbclient`
- Supports anonymous and authenticated modes
- Custom wordlist for brute-forcing share names
- User-defined target IP, port, username, and password
- Useful for CTFs, internal assessments, and real-world pentests

## 🛠️ Usage

You can configure:
- `target` – Target IP or hostname
- `port` – SMB port (default: 445)
- `wordlist` – File containing potential share names
- `auth_mode` – `anonymous` or `authenticated`
- `username` and `password` – For authenticated mode

## 📌 Purpose

This script helps uncover **non-obvious or hidden SMB shares** that may not show up in regular enumeration, making it a valuable asset during security assessments.

## 🙌 Contribution

Pull requests, feature suggestions, and improvements are always welcome. Let’s help make SMB share discovery easier and faster for the community!
