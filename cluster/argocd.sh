#!/bin/bash

set -e

ENVIRONMENT=$1

PASSWORD=adminadmin
PORT=9999

# Install kustomize
brew install kustomize

# Install Argo CD on the cluster
kubectl create namespace argocd
kubectl -n argocd apply -k ./apps/argocd/overlays/$ENVIRONMENT

# Install Argo CD CLI
brew install argocd

# Wait for the Server to be up
kubectl -n argocd rollout status deployment argocd-server

# Initialise projects and apps
kubectl apply -k ./apps/bootstrap/overlays/$ENVIRONMENT

# Wait for nginx to be up
until kubectl -n ingress-nginx rollout status deployment ingress-nginx-controller; do
    sleep 5
done

# Update admin password (need to configure argocd.this in your host file to point to 127.0.0.1)
export PASS=$(kubectl -n argocd get secret argocd-initial-admin-secret --output=jsonpath="{.data.password}" | base64 --decode)
argocd login argocd.this --insecure --username admin --password $PASS --grpc-web
argocd account update-password --current-password $PASS --new-password $PASSWORD

# Update password using port-forward (does not work)
# kubectl port-forward svc/argocd-server -n argocd $PORT:443 &
# PORT_FORWARD_PID=$!
# echo "ARGOCD FORWARD PORT PID: $PORT_FORWARD_PID"
# Stop port forwarding
# kill $PORT_FORWARD_PID
# argocd login --insecure --plaintext --username admin --password $PASS --grpc-web localhost:$PORT

# Sync Crossplane
argocd app sync crossplane

# Install Crossplane providers
# kubectl crossplane install provider crossplane/provider-jet-gcp:v0.2.0
