#!/bin/bash
# Script to set up monitoring and alerting for Azure resources

# Ensure required environment variables are set
if [ -z "$AZURE_MONITOR_WORKSPACE_ID" ] || [ -z "$AZURE_RESOURCE_GROUP" ]; then
  echo "Error: Required environment variables are not set."
  exit 1
fi

# Create an alert rule for high CPU usage
az monitor metrics alert create \
  --name "HighCPUAlert" \
  --resource-group "$AZURE_RESOURCE_GROUP" \
  --scopes "/subscriptions/$AZURE_SUBSCRIPTION_ID/resourceGroups/$AZURE_RESOURCE_GROUP/providers/Microsoft.Compute/virtualMachines/myVM" \
  --condition "avg Percentage CPU > 80" \
  --description "Alert when CPU usage is over 80%" \
  --action-group "myActionGroup"

# Set up log analytics query for monitoring
az monitor log-analytics query \
  --workspace "$AZURE_MONITOR_WORKSPACE_ID" \
  --analytics-query "AzureActivity | summarize count() by bin(TimeGenerated, 1h)" \
  --timespan "PT1H"

# Output success message
echo "Monitoring and alerting setup complete."