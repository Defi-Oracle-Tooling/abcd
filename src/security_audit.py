import os
import subprocess
import logging

# Load environment variables
SLACK_WEBHOOK_URL = os.getenv("SLACK_WEBHOOK_URL")
PAGERDUTY_API_KEY = os.getenv("PAGERDUTY_API_KEY")

# Ensure required environment variables are set
if not SLACK_WEBHOOK_URL or not PAGERDUTY_API_KEY:
    raise EnvironmentError("Slack or PagerDuty credentials are not set in the .env file.")

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S"
)

def check_open_ports():
    logging.info("Checking for open ports...")
    try:
        result = subprocess.run(["netstat", "-tuln"], capture_output=True, text=True)
        logging.info(f"Open ports:\n{result.stdout}")
    except Exception as e:
        logging.error(f"Failed to check open ports: {e}")

def check_weak_permissions():
    logging.info("Checking for weak file permissions...")
    try:
        result = subprocess.run(["find", "/etc", "-type", "f", "-perm", "-o+w"], capture_output=True, text=True)
        if result.stdout:
            logging.warning(f"Files with weak permissions:\n{result.stdout}")
        else:
            logging.info("No files with weak permissions found.")
    except Exception as e:
        logging.error(f"Failed to check file permissions: {e}")

def main():
    logging.info("Starting security audit...")
    check_open_ports()
    check_weak_permissions()
    logging.info("Security audit completed.")

if __name__ == "__main__":
    main()