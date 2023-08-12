### Port Scanner

The **Port Scanner** is a command-line tool designed to facilitate quick and efficient port scanning on a list of hosts. Leveraging the capabilities of Nmap, a powerful network scanning tool, this script allows you to identify open ports and discover available services on the specified hosts.

---

### Features

- **Swift Scanning:** The script streamlines the process of port scanning by automating the Nmap command execution, enabling rapid assessment of multiple hosts in a single command.
- **Customizable:** You can specify the target hosts, port numbers, and scan types (TCP, SYN, UDP) as per your requirements.
- **Informative Output:** The tool provides clear and concise output, displaying the status of the scanned ports, making it easy to identify open ports and the corresponding services.
- **Color-coded Output:** The script utilizes ANSI color codes to enhance readability, highlighting essential information for quick identification.
- **Network Analysis:** Useful for network administrators, security enthusiasts, and penetration testers to assess network connectivity and discover potential vulnerabilities.
- **User-friendly:** With a straightforward command-line interface, it is accessible to users with varying levels of technical expertise.

---

### Usage

1. Clone or download the repository.
2. Open a terminal window and navigate to the script's directory.
3. Run the script using the following format:./port_scanner.sh -h <host_file> -p  -s <scan_type>Replace `<host_file>`, `<port>`, and `<scan_type>` with your specific parameters.

---

### Example

To scan port 80 using TCP Connect scan on a list of hosts from "hosts.txt" file: ./port_scanner.sh -h hosts.txt -p 80 -s T

---

### Dependencies

- Nmap: The script requires Nmap to be installed on your system.
