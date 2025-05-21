#!/bin/bash

kubectl run --image=nginx --port=80 nginx1
kubectl run --image=nginx --port=80 nginx2

kubectl label pod/nginx1 name=myapp
kubectl label pod/nginx2 name=myapp

# Port 35321 - "service port" - used for cluster-internal communication
kubectl create service nodeport mynginxapp --tcp=35321:80
kubectl set selector service/mynginxapp name=myapp

# Kubernetes automatically assigned a NodePort to service
kubectl describe service/mynginxapp

# Endpoints are reachable from
## From Inside a Pod in the Cluster
### Direct Pod-to-Pod Access: 192.168.182.109:80 and 192.168.182.110:80
### Service Access via Cluster IP: 10.107.17.63:35321
### Access via service's DNS Name: mynginxapp:35321, mynginxapp.default:35321, mynginxapp.default.svc.cluster.local:35321
## From Inside a Node (But Outside Pods)
### Service Access via Cluster IP: 10.107.17.63:35321
### Service Access via NodePort to Localhost: localhost:31585 or 127.0.0.1:31585
### Service Access via NodePort to Any Node: <any-node-ip>:31585
#### The NodePort service opens port 31585 on every node in the cluster
## From Outside the Cluster (Another VM)
### Service Access via NodePort: <any-node-ip>:31585
