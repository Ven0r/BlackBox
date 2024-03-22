#!/bin/bash

# Check if a file path is provided as an argument
if [ $# -eq 0 ]; then
	echo "Usage: $0 <scope_file>"
	exit 1
fi

SCOPE_FILE="$1"

# Check if the scope file exists
if [ ! -f "$SCOPE_FILE" ]; then
	echo "Scope file not found: $SCOPE_FILE"
	exit 1
fi

# Filter out domains starting with '*' and remove the '*' prefix for enumeration
grep '^\*\.' "$SCOPE_FILE" | sed 's/^\*\.//' >enumerate_domains.txt

# Filter out domains not starting with '*' for direct inclusion
grep -v '^\*\.' "$SCOPE_FILE" >direct_domains.txt

# Check if there are any domains to enumerate
if [ ! -s enumerate_domains.txt ] && [ ! -s direct_domains.txt ]; then
	echo "No domains found in the scope file for processing."
	exit 0
fi

echo "Running Subfinder and Amass for the domains listed in enumerate_domains.txt"

# Run Subfinder and Amass using the filtered domains file
subfinder -dL enumerate_domains.txt -o subfinder_subdomains.txt
amass enum -norecursive -timeout 20 -df enumerate_domains.txt -o amass_subdomains.txt

# Combine all the domains (subdomains from tools + direct domains) and remove duplicates
cat subfinder_subdomains.txt amass_subdomains.txt direct_domains.txt | sort | uniq >combined_domains.txt

echo "Subdomain enumeration completed. Running httpx on the combined list."

# Run httpx on the combined list and save the result
httpx -l combined_domains.txt -o httpx_output.txt -fc 404 -title -sc -ip -cl -ct

echo "HTTPX probing completed. Results are in httpx_output.txt"
