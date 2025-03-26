import os
import logging

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S"
)

def validate_monitoring():
    logging.info("Validating monitoring setup...")
    try:
        if os.path.exists("/etc/monitoring/config.yaml"):
            logging.info("Monitoring configuration found.")
        else:
            raise FileNotFoundError("Monitoring configuration missing.")

        if os.path.exists("/var/log/app_logs/"):
            logging.info("Logging directory exists.")
        else:
            raise FileNotFoundError("Logging directory missing.")
    except FileNotFoundError as e:
        logging.error(e)

def validate_issue_management():
    logging.info("Validating issue management setup...")
    try:
        if os.path.exists("/etc/issue_tracker/config.json"):
            logging.info("Issue tracker configuration found.")
        else:
            raise FileNotFoundError("Issue tracker configuration missing.")
    except FileNotFoundError as e:
        logging.error(e)

def validate_data_management():
    logging.info("Validating data management setup...")
    try:
        if os.path.exists("/backups/latest_backup.tar.gz"):
            logging.info("Data backup exists.")
        else:
            raise FileNotFoundError("Data backup missing.")
    except FileNotFoundError as e:
        logging.error(e)

def validate_upgrades():
    logging.info("Validating upgrade setup...")
    try:
        if os.path.exists("/scripts/upgrade.sh"):
            logging.info("Upgrade script found.")
        else:
            raise FileNotFoundError("Upgrade script missing.")
    except FileNotFoundError as e:
        logging.error(e)

def main():
    logging.info("Starting post-deployment validation...")

    validate_monitoring()
    validate_issue_management()
    validate_data_management()
    validate_upgrades()

    logging.info("Post-deployment validation completed.")

if __name__ == "__main__":
    main()