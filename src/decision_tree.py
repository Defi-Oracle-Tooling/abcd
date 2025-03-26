class DecisionTree:
    def __init__(self):
        self.technologies = {
            "Hyperledger": ["Besu", "Cacti", "Fabric", "Firefly", "Indy"],
            "Consensys": ["Linea", "Quorum"],
            "Polygon": ["Edge", "Supernets", "PolygonID"],
            "Other": ["LayerZero"]
        }

    def recommend_technology(self, use_case):
        """Recommend a technology based on the provided use case."""
        if "supply chain" in use_case.lower():
            return "Hyperledger Fabric"
        elif "financial services" in use_case.lower():
            return "Consensys Quorum"
        elif "identity management" in use_case.lower():
            return "PolygonID"
        else:
            return "LayerZero"

if __name__ == "__main__":
    tree = DecisionTree()
    use_case = input("Enter your use case: ")
    recommendation = tree.recommend_technology(use_case)
    print(f"Recommended Technology: {recommendation}")