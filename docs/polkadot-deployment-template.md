# Polkadot Deployment Template

## Overview
This template provides instructions for deploying a Polkadot node using Kubernetes.

## Prerequisites
- Kubernetes cluster
- kubectl installed
- Polkadot Docker image

## Deployment Steps
1. Create a Kubernetes namespace:
   ```bash
   kubectl create namespace polkadot
   ```

2. Apply the deployment manifest:
   ```bash
   kubectl apply -f polkadot-deployment.yaml -n polkadot
   ```

3. Verify the deployment:
   ```bash
   kubectl get pods -n polkadot
   ```