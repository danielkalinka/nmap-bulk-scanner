# Nmap Bulk Scanner

A universal Bash script for scanning multiple IP addresses with specific ports using nmap. Perfect for penetration testers and security researchers who need to scan different services running on various ports across multiple hosts.

## Features

- **Interactive nmap options**: Enter any nmap parameters at runtime
- **Bulk scanning**: Process multiple IP:PORT pairs from a file
- **Progress tracking**: Shows scan progress with counters
- **Error handling**: Validates input format and handles scan failures
- **Detailed output**: Saves timestamped results to file
- **Format validation**: Ensures proper IP:PORT format
- **Comment support**: Skip lines starting with # in input file

## Prerequisites

- Linux/Unix system with Bash
- nmap installed and accessible in PATH
- Appropriate permissions to run nmap scans

## Installation

1. Clone this repository:
```bash
git clone https://github.com/danielkalinka/nmap-bulk-scanner.git
cd nmap-bulk-scanner
```

2. Make the script executable:
```bash
chmod +x nmap-bulk-scanner.sh
```

## Usage

### 1. Prepare Input File

Create a text file with IP addresses and ports in the format `IP:PORT` (one per line):

```
192.168.1.10:80
192.168.1.15:443
10.0.0.5:22
203.0.113.1:8080
# This is a comment - will be skipped
198.51.100.10:3389
```

Save this as `input.txt` (or modify the script to use a different filename).

### 2. Run the Scanner

```bash
./nmap-bulk-scanner.sh
```

The script will:
1. Display information about the input file
2. Ask for nmap options (without `-p` and IP address)
3. Show the command that will be executed
4. Ask for confirmation before starting

### 3. Example nmap Options

When prompted for nmap options, you can enter any combination such as:

- `--script vuln` - Run vulnerability scripts
- `-sV --script http-title` - Service detection with HTTP title
- `-A --script /path/to/custom.nse` - Aggressive scan with custom script
- `-sS -O` - SYN scan with OS detection
- `--script smb-enum-shares` - SMB enumeration
- `-sC -sV` - Default scripts with service detection

## Output

The script generates a timestamped output file (`results.txt`) containing:
- Scan timestamp and used nmap options
- Individual results for each IP:PORT pair
- Error messages for failed scans
- Progress indicators and separators

Example output structure:
```
Mon Jan 15 10:30:45 UTC 2024
Used nmap options: -sV --script http-title
===========================================

========== [1/5] 192.168.1.10:80 ==========
Time: Mon Jan 15 10:30:45 UTC 2024

Starting Nmap 7.94 ( https://nmap.org ) at 2024-01-15 10:30 UTC
Nmap scan report for 192.168.1.10
...
```

## Configuration

You can modify these variables at the top of the script:

- `input_file`: Name of the file containing IP:PORT pairs (default: `input.txt`)
- `output_file`: Name of the output file for results (default: `results.txt`)

## Use Cases

- **Penetration Testing**: Scan specific services across multiple hosts
- **Security Auditing**: Check for vulnerabilities on known service ports
- **Network Discovery**: Identify services running on non-standard ports
- **Vulnerability Assessment**: Run targeted scripts against specific services

## Error Handling

The script handles various error conditions:
- Missing input file
- Invalid IP:PORT format
- Empty lines and comments in input file
- Failed nmap scans
- User cancellation

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Disclaimer

This tool is intended for authorized security testing and educational purposes only. Users are responsible for ensuring they have proper authorization before scanning any networks or systems. The author are not responsible for any misuse of this tool.

## Security Note

Always ensure you have explicit permission to scan the target systems. Unauthorized network scanning may be illegal in your jurisdiction and could violate terms of service or organizational policies.