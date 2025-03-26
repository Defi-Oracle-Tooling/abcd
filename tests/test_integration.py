import unittest
from unittest.mock import patch
from src.post_deployment_validation import validate_monitoring, validate_issue_management
from src.compliance_validation import validate_encryption
from scripts.create_repositories import create_repository, initialize_submodule
from scripts.delete_repositories import force_delete_repository, remove_submodule

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

    def test_create_and_delete_repository(self):
        repo_name = "test-repo"

        # Test repository creation
        self.assertTrue(create_repository(repo_name))

        # Test submodule initialization
        self.assertTrue(initialize_submodule(repo_name))

        # Test repository deletion
        self.assertTrue(force_delete_repository(repo_name))

        # Test submodule removal
        self.assertTrue(remove_submodule(repo_name))

if __name__ == "__main__":
    unittest.main()