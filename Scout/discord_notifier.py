import requests
import logging
import os
import sys
import time
import re

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

def remove_ansi_escape_sequences(text):
    """Removes ANSI escape sequences from the given text."""
    ansi_escape_pattern = re.compile(r'\x1B(?:[@-Z\\-_]|\[[0-?]*[ -/]*[@-~])')
    return ansi_escape_pattern.sub('', text)

def send_discord_notification(message, webhook_url):
    """Sends a message to the Discord webhook."""
    data = {'content': message, 'username': 'Recon Bot'}
    response = requests.post(webhook_url, json=data)

    if response.status_code == 204:
        logging.info('Notification sent successfully.')
    elif response.status_code == 429:  # Rate limited
        retry_after = response.json().get('retry_after', 1)
        logging.info(f"Rate limited. Waiting for {retry_after} seconds.")
        time.sleep(retry_after)
        send_discord_notification(message, webhook_url)  # Retry sending the message
    else:
        logging.error(f"Failed to send notification. Status: {response.status_code}, Response: {response.text}")

def chunk_and_send(file_path, webhook_url):
    """Reads file content, chunks it, and sends each chunk as a Discord message."""
    try:
        with open(file_path, 'r', encoding='utf-8') as file:
            content = remove_ansi_escape_sequences(file.read())

        chunk_size = 1900  # To stay below the Discord limit including code block markdown
        chunks = [content[i:i+chunk_size] for i in range(0, len(content), chunk_size)]

        for chunk in chunks:
            send_discord_notification(chunk, webhook_url)
            time.sleep(3)  # Wait a bit between each message to avoid rate limits
    except FileNotFoundError:
        logging.error(f"File not found: {file_path}")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        logging.error("Usage: python3 discord_notifier.py <path_to_output_file>")
        sys.exit(1)

    webhook_url = os.getenv("RECON_BOT")
    if not webhook_url:
        logging.error("Environment variable 'RECON_BOT' not set.")
        sys.exit(1)

    file_path = sys.argv[1]
    chunk_and_send(file_path, webhook_url)

