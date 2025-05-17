#!/bin/bash

# Container runtime is CRI-O
VERSION=v1.33

# Check network adapters (ensure only 1 exists)
mkdir system-info
uname -r > system-info/kernel_version.txt
ip link > system-info/mac_address.txt
sudo cat /sys/class/dmi/id/product_uuid > system-info/uuid.txt

# Disable swap
sudo sed -i '/swap/s/^/# /' /etc/fstab
sudo swapoff -a
free -h

# Install CRI-O
sudo apt-get update -y && sudo apt-get install -y software-properties-common curl gpg apt-transport-https ca-certificates

curl -fsSL https://pkgs.k8s.io/core:/stable:/$VERSION/deb/Release.key |
    sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/$VERSION/deb/ /" |
    sudo tee /etc/apt/sources.list.d/kubernetes.list

curl -fsSL https://download.opensuse.org/repositories/isv:/cri-o:/stable:/$VERSION/deb/Release.key |
    sudo gpg --dearmor -o /etc/apt/keyrings/cri-o-apt-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/cri-o-apt-keyring.gpg] https://download.opensuse.org/repositories/isv:/cri-o:/stable:/$VERSION/deb/ /" |
    sudo tee /etc/apt/sources.list.d/cri-o.list

# Install kubeadm, kubelet and kubectl
sudo apt-get update -y && sudo apt-get install -y cri-o kubelet kubeadm kubectl
# Pin their version
sudo apt-mark hold kubelet kubeadm kubectl

sudo systemctl start crio.service
sudo systemctl enable crio.service

sudo modprobe br_netfilter
sudo sysctl -w net.ipv4.ip_forward=1

echo "net.ipv4.ip_forward=1" | sudo tee -a /etc/sysctl.conf

sudo systemctl enable --now kubelet
