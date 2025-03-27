# Solana Deployment Template

## Overview
This template provides instructions for deploying a Solana validator node using Kubernetes.

## Prerequisites
- Kubernetes cluster
- kubectl installed
- Solana Docker image

## Deployment Steps
1. Create a Kubernetes namespace:
   ```bash
   kubectl create namespace solana
   ```

2. Apply the deployment manifest:
   ```bash
   kubectl apply -f solana-deployment.yaml -n solana
   ```

3. Verify the deployment:
   ```bash
   kubectl get pods -n solana
   ```