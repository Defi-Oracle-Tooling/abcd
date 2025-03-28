#!/bin/bash
# filepath: /workspaces/abcd/scripts/azure_setup.sh

# Ensure pnpm is set as the default package manager
if ! command -v pnpm &> /dev/null
then
    echo "pnpm could not be found. Installing pnpm..."
    npm install -g pnpm
fi

# Log in to Azure using device code authentication (works well in VS Code terminal)
az login --use-device-code

# Get the current subscription ID and set it as active (if you have multiple subscriptions)
subscriptionId=$(az account show --query id -o tsv)
echo "Using subscription: $subscriptionId"
az account set --subscription "$subscriptionId"

# Create a Service Principal with Contributor access to the entire subscription.
# Contributor gives full read/write access.
# NOTE: For security, only create service principals with the permissions you need.
spOutput=$(az ad sp create-for-rbac \
  --name "myServicePrincipal" \
  --role "Contributor" \
  --scopes "/subscriptions/$subscriptionId" \
  --query "{AZURE_CLIENT_ID: appId, AZURE_TENANT_ID: tenant, AZURE_CLIENT_SECRET: password}" -o json)

echo "Service Principal credentials:"
echo "$spOutput"

# Optionally, export the credentials as environment variables.
# You can add these export statements to your .env file manually.
clientId=$(echo "$spOutput" | jq -r '.AZURE_CLIENT_ID')
tenant=$(echo "$spOutput" | jq -r '.AZURE_TENANT_ID')
clientSecret=$(echo "$spOutput" | jq -r '.AZURE_CLIENT_SECRET')

echo "Run the following commands or add them to your .env file:"
echo "export AZURE_CLIENT_ID=\"$clientId\""
echo "export AZURE_TENANT_ID=\"$tenant\""
echo "export AZURE_CLIENT_SECRET=\"$clientSecret\""

echo "Azure CLI setup complete."

# Additional Azure Automation

# Create a resource group
az group create --name "$AZURE_RESOURCE_GROUP" --location "$AZURE_REGION"

# Create a storage account
az storage account create \
  --name "$AZURE_STORAGE_ACCOUNT" \
  --resource-group "$AZURE_RESOURCE_GROUP" \
  --location "$AZURE_REGION" \
  --sku Standard_LRS

# Create a storage container
az storage container create \
  --name "$AZURE_STORAGE_CONTAINER" \
  --account-name "$AZURE_STORAGE_ACCOUNT"

# Set up Azure Monitor workspace
az monitor log-analytics workspace create \
  --resource-group "$AZURE_RESOURCE_GROUP" \
  --workspace-name "$AZURE_MONITOR_WORKSPACE_ID"

# Integrate with Azure Key Vault
az keyvault create \
  --name "$AZURE_KEY_VAULT_NAME" \
  --resource-group "$AZURE_RESOURCE_GROUP" \
  --location "$AZURE_REGION"

# Add secrets to Azure Key Vault
az keyvault secret set \
  --vault-name "$AZURE_KEY_VAULT_NAME" \
  --name "AZURE_CLIENT_SECRET" \
  --value "$AZURE_CLIENT_SECRET"

az keyvault secret set \
  --vault-name "$AZURE_KEY_VAULT_NAME" \
  --name "AZURE_STORAGE_ACCESS_KEY" \
  --value "$AZURE_STORAGE_ACCESS_KEY"

# Output success message
echo "Azure setup and automation complete. All resources have been created and configured."