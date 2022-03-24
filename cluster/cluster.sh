#!/bin/bash

set -e

ENVIRONMENT=$1

function type_minikube() {
    brew install minikube
    minikube config set memory 8192
    minikube config set cpus 6
    # minikube config set driver virtualbox
    # minikube config set driver parallels
    minikube start
    minikube addons enable ingress
}

function type_k3d() {
    brew install k3d
    # k3d cluster create bootstrap --k3s-arg "--no-deploy=treafik@server:0"
    k3d cluster create bootstrap-$ENVIRONMENT --k3s-arg '--no-deploy=traefik@server:*' -p "80:80@loadbalancer" -p "443:443@loadbalancer"
    # k3d cluster create bootstrap --k3s-server-arg "--no-deploy=treafik"
}

type_k3d