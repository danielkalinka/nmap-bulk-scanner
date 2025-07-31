#!/bin/bash

# Configuration
input_file="input.txt"
output_file="results.txt"

# Check if the IP:port list file exists
if [[ ! -f "$input_file" ]]; then
    echo "Error: File $input_file does not exist!"
    echo "Create a file with IP addresses and ports in format: 127.127.127.127:9999"
    exit 1
fi

# Display source file information
echo "=========================================="
echo "Universal nmap Scanner"
echo "=========================================="
echo "Source file: $input_file"
echo "Output file: $output_file"
echo "Data format: IP:PORT (one entry per line)"
echo ""

# Count entries in the file
total_entries=$(wc -l < "$input_file")
echo "Found $total_entries addresses to scan"
echo ""

# Ask for nmap command options
echo "Enter nmap options (without -p and IP address - they will be added automatically):"
echo "Examples:"
echo "  --script vuln"
echo "  -sV --script http-title"
echo "  -A --script /path/to/script.nse"
echo "  -sS -O"
echo ""
read -p "Nmap options: " nmap_options

# Confirmation before starting
echo ""
echo "The following command will be executed for each IP:PORT:"
echo "nmap -p [PORT] $nmap_options [IP]"
echo ""
read -p "Do you want to continue? (y/N): " confirm

if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Cancelled."
    exit 0
fi

# Start scanning
echo ""
echo "Starting scan..."
echo "$(date)" > "$output_file"
echo "Used nmap options: $nmap_options" >> "$output_file"
echo "===========================================" >> "$output_file"
echo "" >> "$output_file"

counter=0

while IFS= read -r line; do
    # Skip empty lines and comments
    [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue
    
    # Check line format
    if [[ ! "$line" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+:[0-9]+$ ]]; then
        echo "Warning: Invalid line format: $line (skipping)"
        continue
    fi
    
    ip=$(echo "$line" | cut -d':' -f1)
    port=$(echo "$line" | cut -d':' -f2)
    
    ((counter++))
    echo "[$counter/$total_entries] Scanning $ip:$port"
    
    # Write header to output file
    echo "========== [$counter/$total_entries] $ip:$port ==========" >> "$output_file"
    echo "Time: $(date)" >> "$output_file"
    echo "" >> "$output_file"
    
    # Execute nmap scan
    if nmap -p "$port" $nmap_options "$ip" >> "$output_file" 2>&1; then
        echo "  ✓ Completed scanning $ip:$port"
    else
        echo "  ✗ Error while scanning $ip:$port"
        echo "ERROR while scanning $ip:$port" >> "$output_file"
    fi
    
    echo "" >> "$output_file"
    echo "===========================================" >> "$output_file"
    echo "" >> "$output_file"
    
done < "$input_file"

echo ""
echo "Scanning completed!"
echo "Results saved in file: $output_file"
echo "Scanned: $counter addresses"
