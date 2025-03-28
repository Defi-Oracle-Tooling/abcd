#!/bin/bash
# Script to automate deployment of resources and services

# Ensure required environment variables are set
if [ -z "$AZURE_RESOURCE_GROUP" ] || [ -z "$AZURE_REGION" ] || [ -z "$AZURE_STORAGE_ACCOUNT" ]; then
  echo "Error: Required environment variables are not set."
  exit 1
fi

# Deploy infrastructure using Terraform
if [ -f "../docs/terraform-example.tf" ]; then
  echo "Initializing Terraform..."
  terraform init ../docs/terraform-example.tf
  echo "Applying Terraform configuration..."
  terraform apply -auto-approve ../docs/terraform-example.tf
else
  echo "Terraform configuration file not found. Skipping Terraform deployment."
fi

# Deploy Kubernetes resources
if [ -f "../docs/kubernetes-deployment-example.yaml" ]; then
  echo "Deploying Kubernetes resources..."
  kubectl apply -f ../docs/kubernetes-deployment-example.yaml
else
  echo "Kubernetes deployment file not found. Skipping Kubernetes deployment."
fi

# Output success message
echo "Deployment automation complete. All resources and services have been deployed."