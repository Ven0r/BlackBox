import requests
import logging
import os
import time
import re

def remove_ansi_escape_sequences(text):
    """
    Removes ANSI escape sequences from the given text.
    """
    ansi_escape_pattern = re.compile(r'\x1B(?:[@-Z\\-_]|\[[0-?]*[ -/]*[@-~])')
    return ansi_escape_pattern.sub('', text)

def send_discord_notification(message):
    webhook_url = os.getenv("RECON_BOT")
    if not webhook_url:
        logging.error("Discord webhook URL is not set.")
        return False

    clean_message = remove_ansi_escape_sequences(message)

    headers = {'Content-Type': 'application/json'}
    payload = {'content': clean_message, 'username': 'Recon Bot'}
    max_retries = 3  # Set the max number of retries
    retry_delay = 3  # Initial retry delay in seconds, could be adjusted based on the retry_after value

    for attempt in range(max_retries):
        response = requests.post(webhook_url, json=payload, headers=headers)
        if response.status_code == 204:
            time.sleep(2)
            return True
        elif response.status_code == 429:  # Rate limited
            retry_data = response.json()
            retry_after = retry_data.get('retry_after', retry_delay)  # Use the suggested retry delay if available
            logging.info(f"Rate limited. Retrying after {retry_after} seconds.")
            time.sleep(retry_after)
        else:
            logging.error(f"Failed to send message. HTTP {response.status_code}: {response.text}")
            break  # Break on other types of errors

    logging.error("Max retries reached. Failed to send message.")
    return False

def chunk_message(message, chunk_size=1900):
    """Yield successive chunk_size chunks from message."""
    for i in range(0, len(message), chunk_size):
        yield message[i:i + chunk_size]

if __name__ == "__main__":
    logging.basicConfig(level=logging.WARNING, format='%(asctime)s - %(levelname)s - %(message)s')

    # Read the content of your file
    file_path = 'alive_domains.txt'
    with open(file_path, 'r', encoding='utf-8') as file:
        file_content = file.read()

    # Process the file content in chunks
    chunks = chunk_message(file_content)
    total_chunks = sum(1 for _ in chunk_message(file_content))  # Count chunks for logging

    for idx, chunk in enumerate(chunks, start=1):
        logging.info(f"Sending chunk {idx}/{total_chunks} with length {len(chunk)}")
        if not send_discord_notification(chunk):
            logging.error(f"Failed to send chunk {idx}. Stopping.")
            break

