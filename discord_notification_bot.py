import requests
import logging
import os

# Configure logging
logging.basicConfig(level=logging.INFO, filename='app.log', filemode='w',
                    format='%(name)s - %(levelname)s - %(message)s')

def send_discord_notification(message):
    webhook = os.getenv("RECON_BOT")
    
    if not webhook:
        logging.info("Webhook not found in environment variables")  # Corrected to logging.info()
        return
    
    data = {
        'content': message,
        'username': 'Recon Bot'
    }

    response = requests.post(webhook, json=data)

    if response.status_code == 204:
        logging.info('Notification sent successfully.')  # Corrected to logging.info()
    else:
        logging.info('Failed to send notification.')  # Corrected to logging.info()

# Example usage
#send_discord_notification("This is a test notification.")

