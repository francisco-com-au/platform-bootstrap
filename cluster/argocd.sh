#!/bin/bash

set -e

PASSWORD=adminadmin
PORT=9999

# Install kustomize
brew install kustomize

# Install Argo CD on the cluster
kubectl create namespace argocd
kustomize build ./argocd | kubectl -n argocd apply -f -

# Install Argo CD CLI
brew install argocd

# Wait for the Server to be up
kubectl -n argocd rollout status deployment argocd-server
kubectl port-forward svc/argocd-server -n argocd $PORT:443 &
PORT_FORWARD_PID=$!
echo "ARGOCD FORWARD PORT PID: $PORT_FORWARD_PID"

# Update admin password
export PASS=$(kubectl -n argocd get secret argocd-initial-admin-secret --output=jsonpath="{.data.password}" | base64 --decode)
argocd login --insecure --username admin --password $PASS --grpc-web localhost:$PORT
argocd account update-password --current-password $PASS --new-password $PASSWORD

# Initialise projects and apps
kubectl apply -f argocd-apps

# Stop port forwarding
kill $PORT_FORWARD_PID
