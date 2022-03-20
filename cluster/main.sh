#!/bin/bash

set -e

# Install dependencies


# Create cluster
#  This will spin up a minikube cluster. Disable it if you want to use a
#  different distribution such as Rancher Desktop.
# ./cluster.sh

# Install argocd
./argocd.sh