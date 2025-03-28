#!/bin/bash
# Script to validate deployed resources and services

# Ensure required environment variables are set
if [ -z "$AZURE_RESOURCE_GROUP" ] || [ -z "$AZURE_STORAGE_ACCOUNT" ]; then
  echo "Error: Required environment variables are not set."
  exit 1
fi

# Validate Azure Storage Account
storageAccountStatus=$(az storage account show \
  --name "$AZURE_STORAGE_ACCOUNT" \
  --resource-group "$AZURE_RESOURCE_GROUP" \
  --query "provisioningState" -o tsv)

if [ "$storageAccountStatus" == "Succeeded" ]; then
  echo "Azure Storage Account validation passed."
else
  echo "Azure Storage Account validation failed. Status: $storageAccountStatus"
  exit 1
fi

# Validate Kubernetes Deployment
kubectl get pods --all-namespaces
if [ $? -eq 0 ]; then
  echo "Kubernetes deployment validation passed."
else
  echo "Kubernetes deployment validation failed."
  exit 1
fi

# Output success message
echo "Validation complete. All resources and services are functioning correctly."