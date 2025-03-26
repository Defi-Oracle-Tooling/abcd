import unittest
from src.decision_tree import DecisionTree

class TestDecisionTree(unittest.TestCase):
    def setUp(self):
        self.tree = DecisionTree()

    def test_supply_chain_use_case(self):
        result = self.tree.recommend_technology("supply chain management")
        self.assertEqual(result, "Hyperledger Fabric")

    def test_financial_services_use_case(self):
        result = self.tree.recommend_technology("financial services")
        self.assertEqual(result, "Consensys Quorum")

    def test_identity_management_use_case(self):
        result = self.tree.recommend_technology("identity management")
        self.assertEqual(result, "PolygonID")

    def test_unknown_use_case(self):
        result = self.tree.recommend_technology("unknown use case")
        self.assertEqual(result, "LayerZero")

if __name__ == "__main__":
    unittest.main()