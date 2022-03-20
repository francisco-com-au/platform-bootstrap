#!/bin/bash

set -e

brew install minikube
minikube config set memory 8192
minikube config set cpus 6
# minikube config set driver virtualbox
# minikube config set driver parallels
minikube start
minikube addons enable ingress
