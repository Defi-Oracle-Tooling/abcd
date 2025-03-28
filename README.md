# abc&d - Azure Besu Configurator and Deployer

For detailed documentation, visit the [Documentation Index](./docs/index.md).

Please help brainstorm or recommend solutions based on the following considerations:

### Supported Enterprise Ethereum Blockchain Technologies
The decision tree should handle the following technologies and expand as needed:
- **Hyperledger**: Besu, Cacti, Fabric, Firefly, Indy
- **Consensys**: Linea, Quorum
- **Polygon**: Edge, Supernets, PolygonID
- **Other Technologies**: LayerZero

### Deployment Options
Deployment options should include:
1. **Local Development Server**
2. **Remote Server**
3. **Cloud Environments**:
   - Single-cloud
   - Multi-cloud
   - Hybrid single or multi-cloud

[Learn more about Deployment Options](docs/deployment-options.md)

### Cloud Deployment Considerations
Cloud deployments should support:
- **Infrastructure Types**:
  - Virtual machines (VMs)
  - Virtual machine scale sets
  - Containers
  - Container clusters (e.g., Kubernetes)
  - Other cloud-specific offerings

[Learn more about Cloud Deployment Considerations](docs/cloud-deployment-considerations.md)

- **Security and Monitoring**:
  - Real-time API and CLI automated interactions to retrieve current quotas and test deployability
  - Implementation or review of:
    - "Clouds for Industry"
    - "Well-Architected Designs"

### Deployment Best Practices
- **Parallel Execution**:
  - Identify and execute tasks in parallel wherever possible to reduce deployment time (e.g., provisioning infrastructure, configuring containers, and setting up monitoring tools).
  - Use automation tools like Terraform, Ansible, or Kubernetes to streamline parallel processes.

- **Ethical and Best Practices**:
  - Follow ethical guidelines, such as ensuring data privacy, compliance with regulations (e.g., GDPR, HIPAA), and minimizing environmental impact.
  - Adhere to industry standards for security, scalability, and maintainability.
  - Regularly review and update deployment processes to align with evolving best practices.

#### Relevant Standards
- **ISO/IEC 27001**: Information Security Management
- **ISO/IEC 27017**: Cloud Security
- **ISO/IEC 27018**: Cloud Privacy
- **ISO 14001**: Environmental Management
- **GDPR**: General Data Protection Regulation
- **HIPAA**: Health Insurance Portability and Accountability Act

- **Performance and Security**:
  - Optimize resource usage to ensure cost-efficiency and performance.
  - Implement robust security measures, such as encryption, access control, and regular vulnerability assessments.

### Post-Deployment Checklist
Post-deployment tasks should include:
1. **Monitoring**:
   - Active and passive monitoring
   - Full detailed logging
2. **Issue Management**:
   - Updated recommendations to solve issues before they become errors
   - Rapid error handling
3. **Data Management**:
   - Full data protection
   - Proper data backup
4. **Upgrades and Additions**:
   - Fully integrated upgrading
   - Adding plugins or separate blockchain networks
   - Support for multi-tenant deployments
- **Support for Multi-Tenant Deployments**:
  - Ensure proper isolation of tenant data and resources to maintain security and privacy.
  - Implement role-based access control (RBAC) to manage tenant-specific permissions.
  - Optimize resource allocation to prevent performance degradation due to tenant resource contention.
  - Provide scalability options to accommodate varying tenant workloads.
  - Include monitoring and logging mechanisms to track tenant-specific activities and ensure compliance.
  - Support customization for tenants, such as configurable deployment options or plugins.
  - Adhere to relevant compliance standards (e.g., GDPR, ISO/IEC 27001) to ensure tenant data protection.

## Getting Started

To get started with the Azure Besu Configurator and Deployer (ABCD), follow these steps:

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/your-repo/abcd.git
   cd abcd
   ```

2. **Install Dependencies**:
   Ensure you have Python 3.8+ installed. Install required dependencies:
   ```bash
   pip install -r requirements.txt
   ```

3. **Run Validation Scripts**:
   Validate your deployment environment:
   ```bash
   python src/post_deployment_validation.py
   python src/compliance_validation.py
   ```

4. **Deploy Using Kubernetes**:
   Use the provided Kubernetes deployment example:
   ```bash
   kubectl apply -f docs/kubernetes-deployment-example.yaml
   ```

## Features

- **Decision Tree for Blockchain Technologies**:
  Recommends the best blockchain technology based on your use case.
- **Post-Deployment Validation**:
  Ensures monitoring, issue management, data management, and upgrades are properly configured.
- **Compliance Validation**:
  Validates encryption, access control, and GDPR compliance.
- **Kubernetes Deployment**:
  Provides a ready-to-use Kubernetes deployment example for Besu nodes.
- **Monitoring and Analytics**:
  Includes Prometheus and Grafana configurations for tracking metrics.

## Standards and Compliance

This project adheres to various global standards and compliance frameworks. For more details, see the [Standards Documentation](standards/README.md).

## Branching Strategy

We follow the Git Flow branching strategy:

1. **Main Branch**: Contains production-ready code.
2. **Develop Branch**: Used for integrating features and testing.
3. **Feature Branches**: Created for individual features and merged into `develop`.
4. **Release Branches**: Used for final testing before merging into `main`.
5. **Hotfix Branches**: Created for urgent fixes to the `main` branch.

For more details, refer to the [Git Flow documentation](https://nvie.com/posts/a-successful-git-branching-model/).

### Submodule Initialization

To ensure all submodules are initialized and updated, run the following command:

```bash
git submodule update --init --recursive
```

Alternatively, this is automated when you open the project in VS Code, thanks to the `.vscode/tasks.json` configuration.

## Submodule Management

This project uses Git submodules for managing white-label repositories. Below are the steps to manage submodules:

### Adding a Submodule
To add a new submodule:
```bash
git submodule add <repository-url> submodules/<submodule-name>
```

### Initializing and Updating Submodules
To initialize and update all submodules:
```bash
git submodule update --init --recursive
```

### Removing a Submodule
To remove a submodule:
```bash
git submodule deinit -f submodules/<submodule-name>
git rm -f submodules/<submodule-name>
rm -rf .git/modules/submodules/<submodule-name>
```

### Viewing Submodule Status
To check the status of all submodules:
```bash
git submodule status
```

## Usage Instructions for Scripts

### `create_repositories.sh`
This script creates repositories, initializes them, and links them as submodules.

#### Usage:
```bash
bash scripts/create_repositories.sh [--dry-run]
```
- `--dry-run`: Simulates the script's actions without making actual changes.

#### Features:
- Creates repositories in the specified GitHub organization.
- Adds descriptions and topics to repositories.
- Initializes repositories with default files.
- Links repositories as submodules.

### `delete_repositories.sh`
This script deletes repositories and removes corresponding submodules.

#### Usage:
```bash
bash scripts/delete_repositories.sh [--dry-run] [--filter <keyword>]
```
- `--dry-run`: Simulates the script's actions without making actual changes.
- `--filter <keyword>`: Deletes only repositories matching the specified keyword.

#### Features:
- Deletes repositories from the specified GitHub organization.
- Removes corresponding submodules from the project.
- Supports dry-run mode for testing.

## Usage Instructions for Automation Scripts

### `azure_setup.sh`
This script sets up Azure resources, including resource groups, storage accounts, and Key Vault integration.

#### Usage:
```bash
bash scripts/azure_setup.sh
```

#### Features:
- Creates Azure resource groups and storage accounts.
- Sets up Azure Monitor and Key Vault.
- Adds secrets to Key Vault.

---

### `deployment_automation.sh`
This script automates the deployment of resources and services using Terraform and Kubernetes.

#### Usage:
```bash
bash scripts/deployment_automation.sh
```

#### Features:
- Deploys infrastructure using Terraform.
- Deploys Kubernetes resources.

---

### `validation_automation.sh`
This script validates the status of deployed Azure resources and Kubernetes deployments.

#### Usage:
```bash
bash scripts/validation_automation.sh
```

#### Features:
- Validates Azure Storage Account provisioning status.
- Checks the status of Kubernetes pods.

---

### `monitoring_setup.sh`
This script sets up monitoring and alerting for Azure resources.

#### Usage:
```bash
bash scripts/monitoring_setup.sh
```

#### Features:
- Creates alert rules for high CPU usage.
- Sets up log analytics queries for monitoring.

---

### CI/CD Pipeline
The CI/CD pipeline automates the execution of these scripts using GitHub Actions.

#### Workflow File:
The pipeline is defined in `.github/workflows/ci_cd_pipeline.yml`.

#### Features:
- Automates setup, deployment, validation, and monitoring.
- Uses `pnpm` for dependency management.

---

### Dependency Management
Ensure all dependencies are installed using `pnpm`:

```bash
pnpm install
```

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

### Summary of the MIT License
- Permission is granted to use, copy, modify, merge, publish, distribute, sublicense, and sell copies of the software.
- The software is provided "as is," without warranty of any kind, express or implied.
- The authors are not liable for any claims, damages, or other liabilities arising from the use of the software.

## User Chain Configurations

The `user-chain-configs` directory is used to store configuration files for multiple blockchains and environments. This includes development, testing, and mainnet configurations. Each blockchain has its own folder, and each folder contains environment-specific JSON files.

### Structure
```
user-chain-configs
├── blockchainA
│   ├── dev.json       // Development settings for Blockchain A
│   ├── test.json      // Testing settings for Blockchain A
│   └── mainnet.json   // Production settings for Blockchain A
├── blockchainB
│   ├── dev.json       // Development settings for Blockchain B
│   ├── test.json      // Testing settings for Blockchain B
│   └── mainnet.json   // Production settings for Blockchain B
└── common.json        // Global settings shared across blockchains and environments
```

### Adding New Configurations
1. Create a new folder for the blockchain under `user-chain-configs`.
2. Add `dev.json`, `test.json`, and `mainnet.json` files for the respective environments.
3. Update `common.json` if there are global settings to be shared.

### Example Usage
Ensure your scripts dynamically load the appropriate configuration based on the blockchain and environment.