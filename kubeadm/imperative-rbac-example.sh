#!/bin/bash

# Show available resources
# kubectl api-resources

kubectl create role --namespace databases podmanager --verb=get,list,create,delete --resource=pods
kubectl create rolebinding --namespace databases podmanagerbinding --user=joey --role=podmanager

kubectl create role --namespace databases servicemanager --verb=get,list,create,delete --resource=service
kubectl create rolebinding --namespace databases servicemanagerbinding --user=joey --role=servicemanager

# Verify
kubectl --kubeconfig=joey.config get ns
kubectl --kubeconfig=joey.config -n databases get pods
kubectl --kubeconfig=joey.config -n databases get deployments
kubectl --kubeconfig=joey.config -n databases get services
