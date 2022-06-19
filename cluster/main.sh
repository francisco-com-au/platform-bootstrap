#!/bin/bash

set -e

# Set the environment depending on the current branch
branch=$(git rev-parse --abbrev-ref HEAD)
if [ "$branch" == "main" ]; then
  export ENVIRONMENT=prod
elif [ "$branch" == "develop" ]; then
  export ENVIRONMENT=dev
else
  echo "Unknown branch: $branch"
  exit 1
fi

# Install dependencies


# Create cluster
#  This will spin up a minikube cluster. Disable it if you want to use a
#  different distribution such as Rancher Desktop.
./cluster.sh $ENVIRONMENT

# Install argocd
./argocd.sh $ENVIRONMENT

# Mount secrets
./mount_secrets.sh