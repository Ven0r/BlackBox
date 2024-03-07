#!/bin/bash

# Define the file paths
output_dir="./subfinder_outputs"
httpx_output="alive_domains.txt"
temp_httpx_output="temp_alive_domains.txt"
new_domains_found="new_domains_found.txt"

# Create a directory for subfinder outputs if it doesn't exist
mkdir -p "$output_dir"

# Empty the temp file for httpx results
>"$temp_httpx_output"

# Loop through each domain provided as an argument
for domain in "$@"; do
	echo "Processing domain: $domain"

	# Run subfinder and output to a domain-specific file
	subfinder_output="${output_dir}/${domain}_subfinder.txt"
	subfinder -d "$domain" -o "$subfinder_output"

	# Run httpx on the subfinder output, append results to temp file
	cat "$subfinder_output" | httpx --title --cname --sc --ct --location >>"$temp_httpx_output"
done

# Function to send notifications via Python script
send_notification() {
	local message_file="$1"
	python3 discord_notifier.py "$(cat "$message_file")"
}

# After running httpx and generating temp_alive_domains.txt or new_domains_found
if [ ! -f "$httpx_output" ]; then
	# First run, entire output is considered new
	echo "First run, sending all domains to Discord..."
	send_notification "$temp_httpx_output"
	cp "$temp_httpx_output" "$httpx_output"
else
	# Find new domains by comparing current httpx output with the previous
	grep -Fxvf "$httpx_output" "$temp_httpx_output" >"$new_domains_found"

	if [ -s "$new_domains_found" ]; then
		echo "New domains found, sending to Discord..."
		send_notification "$new_domains_found"

		# Append new domains to alive_domains.txt
		cat "$new_domains_found" >>"$httpx_output"
	else
		echo "No new domains found."
	fi
fi

# Optional: Clean up temporary files
rm -f "$temp_httpx_output" "$new_domains_found"
