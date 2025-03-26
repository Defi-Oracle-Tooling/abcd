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
        use_case = use_case.lower()
        recommendations = []

        if "supply chain" in use_case:
            recommendations.append(("Hyperledger Fabric", 0.9))
        if "financial services" in use_case:
            recommendations.append(("Consensys Quorum", 0.8))
        if "identity management" in use_case:
            recommendations.append(("PolygonID", 0.7))

        if recommendations:
            # Sort by confidence score and return the highest
            recommendations.sort(key=lambda x: x[1], reverse=True)
            return recommendations[0][0]
        else:
            return "LayerZero"  # Default recommendation

if __name__ == "__main__":
    tree = DecisionTree()
    use_case = input("Enter your use case: ")
    recommendation = tree.recommend_technology(use_case)
    print(f"Recommended Technology: {recommendation}")