#!/bin/bash

read -p "Which version to install (version number only)? " kind_version

# https://github.com/kubernetes-sigs/kind/releases

[ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v${kind_version}/kind-$(uname)-amd64

chmod u+x ./kind
sudo mv ./kind /usr/local/bin/kind

# kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

chmod u+x kubectl
sudo mv kubectl /usr/local/bin/kubectl
