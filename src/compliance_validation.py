import os
import logging

# Load environment variables
DEFENDER_API_KEY = os.getenv("DEFENDER_API_KEY")
DEFENDER_API_SECRET = os.getenv("DEFENDER_API_SECRET")

# Ensure required environment variables are set
if not DEFENDER_API_KEY or not DEFENDER_API_SECRET:
    raise EnvironmentError("OpenZeppelin Defender API credentials are not set in the .env file.")

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S"
)

def validate_encryption():
    logging.info("Validating encryption setup...")
    try:
        if os.path.exists("/etc/security/encryption_keys.pem"):
            logging.info("Encryption keys found.")
        else:
            raise FileNotFoundError("Encryption keys missing.")
    except FileNotFoundError as e:
        logging.error(e)

def validate_access_control():
    logging.info("Validating access control setup...")
    try:
        if os.path.exists("/etc/security/access_control.yaml"):
            logging.info("Access control policies found.")
        else:
            raise FileNotFoundError("Access control policies missing.")
    except FileNotFoundError as e:
        logging.error(e)

def validate_data_privacy():
    logging.info("Validating data privacy setup...")
    try:
        if os.path.exists("/etc/compliance/gdpr_config.json"):
            logging.info("GDPR compliance configuration found.")
        else:
            raise FileNotFoundError("GDPR compliance configuration missing.")
    except FileNotFoundError as e:
        logging.error(e)

def main():
    logging.info("Starting compliance validation...")

    validate_encryption()
    validate_access_control()
    validate_data_privacy()

    logging.info("Compliance validation completed.")

if __name__ == "__main__":
    main()