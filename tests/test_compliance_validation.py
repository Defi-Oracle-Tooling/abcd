import unittest
from unittest.mock import patch
from src.compliance_validation import validate_encryption, validate_access_control, validate_data_privacy

class TestComplianceValidation(unittest.TestCase):
    @patch("os.path.exists")
    def test_validate_encryption(self, mock_exists):
        mock_exists.return_value = True
        with self.assertLogs(level="INFO") as log:
            validate_encryption()
            self.assertIn("Encryption keys found.", log.output[0])

    @patch("os.path.exists")
    def test_validate_access_control(self, mock_exists):
        mock_exists.return_value = True
        with self.assertLogs(level="INFO") as log:
            validate_access_control()
            self.assertIn("Access control policies found.", log.output[0])

    @patch("os.path.exists")
    def test_validate_data_privacy(self, mock_exists):
        mock_exists.return_value = True
        with self.assertLogs(level="INFO") as log:
            validate_data_privacy()
            self.assertIn("GDPR compliance configuration found.", log.output[0])

if __name__ == "__main__":
    unittest.main()