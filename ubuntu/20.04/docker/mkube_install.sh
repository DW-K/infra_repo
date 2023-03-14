#!/bin/sh
curl -LO https://storage.googleapis.com/minikube/releases/v1.22.0/minikube-linux-amd64

sudo install minikube-linux-amd64 /usr/local/bin/minikube

minikube --help

curl -LO https://dl.k8s.io/release/v1.22.1/bin/linux/amd64/kubectl

sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

minikube start --driver=docker

minikube status

kubectl get pod -n kube-system
