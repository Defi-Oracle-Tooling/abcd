#!/bin/bash
# Script to perform post-deployment checklist tasks

# Ensure required environment variables are set
if [ -z "$AZURE_RESOURCE_GROUP" ] || [ -z "$AZURE_STORAGE_ACCOUNT" ]; then
  echo "Error: Required environment variables are not set."
  exit 1
fi

# Task 1: Verify monitoring setup
monitoringStatus=$(az monitor log-analytics workspace show \
  --resource-group "$AZURE_RESOURCE_GROUP" \
  --workspace-name "$AZURE_MONITOR_WORKSPACE_ID" \
  --query "provisioningState" -o tsv)

if [ "$monitoringStatus" == "Succeeded" ]; then
  echo "Monitoring setup verification passed."
else
  echo "Monitoring setup verification failed. Status: $monitoringStatus"
  exit 1
fi

# Task 2: Verify Key Vault secrets
keyVaultSecrets=$(az keyvault secret list \
  --vault-name "$AZURE_KEY_VAULT_NAME" \
  --query "[].id" -o tsv)

if [ -n "$keyVaultSecrets" ]; then
  echo "Key Vault secrets verification passed."
else
  echo "Key Vault secrets verification failed. No secrets found."
  exit 1
fi

# Task 3: Verify Kubernetes pods are running
kubectl get pods --all-namespaces | grep -q "Running"
if [ $? -eq 0 ]; then
  echo "Kubernetes pods verification passed."
else
  echo "Kubernetes pods verification failed."
  exit 1
fi

# Task 4: Verify backups are scheduled
if [ -n "$BACKUP_SCHEDULE" ]; then
  echo "Backup schedule verification passed."
else
  echo "Backup schedule verification failed."
  exit 1
fi

# Output success message
echo "Post-deployment checklist completed successfully. All tasks passed."