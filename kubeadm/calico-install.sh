#!/bin/bash

VERSION=v3.30.0

kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/${VERSION}/manifests/operator-crds.yaml
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/${VERSION}/manifests/tigera-operator.yaml

curl https://raw.githubusercontent.com/projectcalico/calico/${VERSION}/manifests/custom-resources.yaml -O

kubectl create -f custom-resources.yaml
