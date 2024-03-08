#!/bin/bash

# Define file paths relative to the script location
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
output_dir="$script_dir/subfinder_outputs"
domains_file="$script_dir/domains.txt" # File to store the list of domains
httpx_output="$script_dir/alive_domains.txt"
temp_httpx_output="$script_dir/temp_alive_domains.txt"

# Create output directory if it doesn't exist
mkdir -p "$output_dir"

# Create or clear the domains file
>"$domains_file"

# Write each domain provided as an argument to the domains file
for domain in "$@"; do
	echo "$domain" >>"$domains_file"
done

# Run subfinder using the domains file
subfinder -dL "$domains_file" -o "$temp_httpx_output"

# Process the subfinder output with httpx
cat "$temp_httpx_output" | httpx -title -cname -sc -ct -location >>"$httpx_output"

# Call the Python script to send notifications, ensuring the correct file path is passed
python3 "$script_dir/discord_notifier.py" "$httpx_output"

# Optional: Clean up
rm -f "$temp_httpx_output" "$domains_file"
