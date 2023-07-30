#!/bin/bash

# Step 1: Create a Kubernetes cluster using KinD
echo "Creating a Kubernetes cluster with kind..."
kind create cluster

# Step 2: Verify the cluster is running
echo "Checking if the cluster is running..."
kubectl cluster-info

# Step 3: Install Tekton Pipelines
echo "Installing Tekton Pipelines..."
kubectl apply --filename https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml

# Step 4: Monitor the Tekton Pipelines components until all components show a STATUS of Running
echo "Waiting for Tekton Pipelines to become ready..."
kubectl wait --for=condition=ready pods --all -n tekton-pipelines --timeout=300s

# Step 5: Verify Tekton Pipelines installation
echo "Checking the installation of Tekton Pipelines..."
kubectl get pods --namespace tekton-pipelines
