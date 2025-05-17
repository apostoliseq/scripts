#!/bin/bash

# Find out the default gateway
ip route show > system-info/ip_route.txt

# Reset cluster
# sudo kubeadm reset
# rm $HOME/.kube/config

# Single node cluster
sudo kubeadm init --pod-network-cidr 192.168.0.0/16

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Verify installation
kubectl version
