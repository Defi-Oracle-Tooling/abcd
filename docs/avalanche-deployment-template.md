# Avalanche Deployment Template

## Overview
This template provides instructions for deploying an Avalanche node using Kubernetes.

## Prerequisites
- Kubernetes cluster
- kubectl installed
- Avalanche Docker image

## Deployment Steps
1. Create a Kubernetes namespace:
   ```bash
   kubectl create namespace avalanche
   ```

2. Apply the deployment manifest:
   ```bash
   kubectl apply -f avalanche-deployment.yaml -n avalanche
   ```

3. Verify the deployment:
   ```bash
   kubectl get pods -n avalanche
   ```