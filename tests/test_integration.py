import unittest
from unittest.mock import patch
from src.post_deployment_validation import validate_monitoring, validate_issue_management
from src.compliance_validation import validate_encryption

class TestIntegration(unittest.TestCase):
    @patch("os.path.exists")
    def test_monitoring_and_encryption(self, mock_exists):
        # Simulate monitoring and encryption configurations being present
        mock_exists.side_effect = lambda path: path in [
            "/etc/monitoring/config.yaml",
            "/etc/security/encryption_keys.pem"
        ]

        with self.assertLogs(level="INFO") as log:
            validate_monitoring()
            validate_encryption()

            self.assertIn("Monitoring configuration found.", log.output[0])
            self.assertIn("Encryption keys found.", log.output[1])

    @patch("os.path.exists")
    def test_issue_management(self, mock_exists):
        # Simulate issue management configuration being present
        mock_exists.return_value = True

        with self.assertLogs(level="INFO") as log:
            validate_issue_management()
            self.assertIn("Issue tracker configuration found.", log.output[0])

if __name__ == "__main__":
    unittest.main()