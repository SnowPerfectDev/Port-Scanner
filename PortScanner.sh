#!/bin/bash

# Define ANSI color codes
GREEN='\e[0;32m'
RED='\e[0;31m'
YELLOW='\e[1;33m'
NC='\e[0m' # No Color

# Function to display help
show_help() {
    echo -e "Usage: $0 -h <host_file> -p <port> -s <scan_type>"
    echo -e "Options:"
    echo -e "  -h : File containing list of hosts"
    echo -e "  -p : Port to be scanned"
    echo -e "  -s : Scan type (TCP, SYN, UDP)"
}

# Function to handle argument errors
handle_argument_error() {
    echo -e "${RED}Error: Insufficient arguments.${NC}"
    show_help
    exit 1
}

# Default options
port=""
scan_type="T"  # Set to "T" for TCP Connect scan
host_file="hosts.txt"
scan_speed="3" # Set the desired scan speed level (1-5)
max_hosts=3    # Maximum number of hosts to be scanned

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
    echo -e "${RED}Nmap is not installed. Please install it first.${NC}"
    exit 1
fi

# Check existence of host file
if [ ! -f "$host_file" ]; then
    echo -e "${RED}Hosts file '$host_file' not found.${NC}"
    exit 1
fi

# Print informative header
echo -e "${YELLOW}----------------- Scan Results -----------------${NC}"

# Loop through hosts and perform scans
host_count=0
while IFS= read -r host || [ -n "$host" ]; do
    if [ "$host_count" -ge "$max_hosts" ]; then
        break
    fi

    if [ -n "$host" ]; then
        echo -e "${GREEN}Scanning $host on port $port using $scan_type scan${NC}"
        nmap_result=$(nmap -T$scan_speed -sT -p "$port" "$host")
        open_ports=$(echo "$nmap_result" | awk '/^PORT/{flag=1} flag; /^$/{flag=0}' | grep "open")
        closed_ports=$(echo "$nmap_result" | awk '/^PORT/{flag=1} flag; /^$/{flag=0}' | grep -E "closed|filtered")

        if [ -n "$open_ports" ]; then
            echo -e "${GREEN}Open Ports:${NC}"
            echo "$open_ports"
        fi

        if [ -n "$closed_ports" ]; then
            echo -e "${RED}Closed/Filtered Ports:${NC}"
            echo "$closed_ports"
        fi

        echo -e "${YELLOW}-------------------------------${NC}\n"
        
        ((host_count++))
    fi
done < "$host_file"
