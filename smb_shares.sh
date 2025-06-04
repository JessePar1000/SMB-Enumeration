#!/bin/bash

# ===============================
# SMB Share Brute Forcer Script
# ===============================
# This script checks for accessible SMB shares on a target IP address using a list of common share names.
# It supports both authenticated and anonymous access.
# It uses flags for input and requires 'smbclient' from the Samba suite.

# ------------------------------
# Function to Show Usage Syntax
# ------------------------------
usage() {
    echo "Usage: $0 -t <target_ip> -w <wordlist> [-p <port>] [-a <auth_mode>] [-U <username>] [-P <password>] [-m <smb_version>] [-h]"
    echo ""
    echo "The default port used by this script is 445"
    echo "The default SMB version is SMB2 (SMBv2)"
    echo ""
    echo "Options:"
    echo "  -t <target_ip>     Target SMB server IP address (required)"
    echo "  -w <wordlist>      Path to wordlist file containing share names (required)"
    echo "  -p <port>          SMB port number (default: 445)"
    echo "  -a <auth_mode>     Authentication mode: 'anonymous' or 'authenticated' (default: anonymous)"
    echo "  -U <username>      SMB username (required if auth_mode is 'authenticated')"
    echo "  -P <password>      SMB password (required if auth_mode is 'authenticated')"
    echo "  -m <smb_version>   SMB protocol version (default: NT1). Examples: NT1, SMB2, SMB3"
    echo "  -h                 Show this help message and exit"
    echo ""
    echo "Examples:"
    echo "  $0 -t 192.168.1.10 -w shares.txt -a anonymous"
    echo "  $0 -t 192.168.1.10 -w shares.txt -a authenticated -U user -P pass"
    echo "  $0 -t 192.168.1.10 -w shares.txt -p 139 -a anonymous -m SMB3"
    exit 1
}

# -------------------------
# Default values for optional variables
PORT=445                    # Default SMB port
AUTH_MODE="anonymous"       # Default mode is anonymous
USERNAME=""                 # Placeholder for username (if needed)
PASSWORD=""                 # Placeholder for password (if needed)
TARGET_IP=""                # Placeholder for target IP
WORDLIST=""                 # Placeholder for wordlist file
SMB_VERSION="SMB2"           # Default SMB version (NT1 = SMBv1)

# -------------------------
# Parse command-line flags using getopts
while getopts ":t:w:p:a:U:P:m:h" opt; do
    case $opt in
        t) TARGET_IP="$OPTARG" ;;
        w) WORDLIST="$OPTARG" ;;
        p) PORT="$OPTARG" ;;
        a) AUTH_MODE="$OPTARG" ;;
        U) USERNAME="$OPTARG" ;;
        P) PASSWORD="$OPTARG" ;;
        m) SMB_VERSION="$OPTARG" ;;
        h) usage ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            usage ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            usage ;;
    esac
done

# -------------------------
# Validate required parameters

if [[ -z "$TARGET_IP" ]]; then
    echo "Error: Target IP (-t) is required."
    usage
fi

if [[ -z "$WORDLIST" ]]; then
    echo "Error: Wordlist (-w) is required."
    usage
fi

if [[ "$AUTH_MODE" != "anonymous" && "$AUTH_MODE" != "authenticated" ]]; then
    echo "Error: Authentication mode (-a) must be 'anonymous' or 'authenticated'."
    usage
fi

if [[ "$AUTH_MODE" == "authenticated" ]]; then
    if [[ -z "$USERNAME" || -z "$PASSWORD" ]]; then
        echo "Error: Username (-U) and Password (-P) are required for authenticated mode."
        usage
    fi
fi

# ---------------------------------------
# Start Looping Through Wordlist Entries
# ---------------------------------------

while IFS= read -r SHARE; do
    SMB_OPTION="-m $SMB_VERSION"

    if [[ "$AUTH_MODE" == "anonymous" ]]; then
        smbclient "\\\\$TARGET_IP\\$SHARE" -U ""%"" -N -p "$PORT" $SMB_OPTION -g 2>/dev/null
    else
        smbclient "\\\\$TARGET_IP\\$SHARE" -U "$USERNAME%$PASSWORD" --no-pass -p "$PORT" $SMB_OPTION -g 2>/dev/null
    fi

    if [ $? -eq 0 ]; then
        echo "[+] Found share: $SHARE"
    else
        echo "[-] Not accessible: $SHARE"
    fi
done < "$WORDLIST"
