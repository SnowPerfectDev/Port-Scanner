#!/bin/bash

# Define ANSI color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to display help
show_help() {
    echo "Usage: $0 -h <host_file> -p <port> -s <scan_type>"
    echo "Options:"
    echo "  -h : File containing list of hosts"
    echo "  -p : Port to be scanned"
    echo "  -s : Scan type (TCP, SYN, UDP)"
}

# Function to handle argument errors
handle_argument_error() {
    echo "Error: Insufficient arguments."
    show_help
    exit 1
}

# Default options
port=""
scan_type="T"  # Set to "T" for TCP Connect scan
host_file="hosts.txt"

# Check for arguments
if [ $# -eq 0 ]; then
    handle_argument_error
fi

# Parse command line options
while getopts "h:p:s:" opt; do
    case $opt in
        h) host_file="$OPTARG";;
        p) port="$OPTARG";;
        s) scan_type="$OPTARG";;
        \?) show_help; exit 1;;
    esac
done

# Check dependency
if ! command -v nmap &>/dev/null; then
    echo "Nmap is not installed. Please install it first."
    exit 1
fi

# Check existence of host file
if [ ! -f "$host_file" ]; then
    echo "Hosts file '$host_file' not found."
    exit 1
fi

# Print informative header
echo -e "${YELLOW}----------------- Scan Results -----------------${NC}"

# Loop through hosts and perform scans
while IFS= read -r host; do
    echo -e "${GREEN}Scanning $host on port $port using $scan_type scan${NC}"
    nmap -sT -p "$port" "$host" | awk '/^PORT/{flag=1} flag; /^$/{flag=0}' | grep "open"
    echo -e "${YELLOW}-------------------------------${NC}\n"
done < "$host_file"
