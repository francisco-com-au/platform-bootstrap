#!/bin/bash

GCP_KEY_PATH="/Users/franciscogalarza/credentials/gcp-test-fran-root/terraform.json"
PROJECT_ID=$(cat $GCP_KEY_PATH | jq -r '.project_id')

# Crossplane GCP key
kubectl create namespace crossplane-system
kubectl -n crossplane-system create secret generic gcp-provider \
    --from-literal=credentials.json=$(cat $GCP_KEY_PATH) \
    --from-literal=project_id=$PROJECT_ID
