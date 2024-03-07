import requests
import logging
import os
import sys
import re

def remove_ansi_escape_sequences(text):
    """
    Removes ANSI escape sequences from the given text.
    """
    ansi_escape_pattern = re.compile(r'\x1B(?:[@-Z\\-_]|\[[0-?]*[ -/]*[@-~])')
    return ansi_escape_pattern.sub('', text)


# Configure logging
logging.basicConfig(level=logging.INFO, filename='app.log', filemode='w',
                    format='%(name)s - %(levelname)s - %(message)s')

def send_discord_notification(message):
    webhook = os.getenv("RECON_BOT")
    
    if not webhook:
        logging.info("Webhook not found in environment variables")
        return
    
     # Clean the message of ANSI escape codes before chunking
    clean_message = remove_ansi_escape_sequences(message)
    
    # Discord's character limit per message
    char_limit = 1999
    
    # Split the clean message into chunks of 1999 characters
    chunks = [clean_message[i:i+char_limit] for i in range(0, len(clean_message), char_limit)]

    for chunk in chunks:
        code_block_chunk = f'```{chunk}```'
        data = {
            'content': code_block_chunk,
            'username': 'Recon Bot'
        }
        response = requests.post(webhook, json=data)
        if response.status_code == 204:
            logging.info('Notification sent successfully.')
        else:
            logging.info('Failed to send notification. Response: {}'.format(response.text))

if __name__ == "__main__":
    if len(sys.argv) > 1:
        message = ' '.join(sys.argv[1:])
        send_discord_notification(message)
    else:
        logging.info("No message provided for Discord notification.")

