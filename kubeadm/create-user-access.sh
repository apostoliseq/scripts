#!/bin/bash

sudo -v 

echo "Enter username:"
read NAME

echo "Enter groups (comma-delimited, e.g., 'development,operations,admin'):"
read GROUPZ

echo "Set expiration days:"
read EXP_DAYS

SUBJECT="/CN=$NAME"

# If $GROUPZ non-empty
if [ -n "$GROUPZ" ]; then
    # Set the Internal Field Separator to a comma
    # -a: store the input as an array
    # <<<: feed the string on the right as STDIN to the command on the left
    IFS=',' read -a GROUP_ARRAY <<< "$GROUPZ"
    
    # Add each group with proper /O= format
    for group in "${GROUP_ARRAY[@]}"; do
        SUBJECT="$SUBJECT/O=$group"
    done
    
    # Set default namespace to the first group if not empty
    if [ ${#GROUP_ARRAY[@]} -gt 0 ]; then
        DEFAULT_NAMESPACE="${GROUP_ARRAY[0]}"
        echo "Setting default namespace to: $DEFAULT_NAMESPACE"
    fi
else
    echo "No groups specified."
fi

openssl genrsa -out $NAME.key 2048
openssl req -new -key $NAME.key -out $NAME.csr -subj "$SUBJECT"

# Inspect
openssl req -in $NAME.csr -noout -text

# Sign
sudo openssl x509 -req -in $NAME.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out $NAME.crt -days $EXP_DAYS

# Cleanup
rm $NAME.csr

# Create kubeconfig
kubectl --kubeconfig=$NAME.config config set-cluster ${NAME}cluster --embed-certs --server=$(kubectl config view -o jsonpath='{.clusters[0].cluster.server}') --certificate-authority=/etc/kubernetes/pki/ca.crt

kubectl --kubeconfig=$NAME.config config set-credentials $NAME --embed-certs --client-certificate=$NAME.crt --client-key=$NAME.key

kubectl --kubeconfig=$NAME.config config set-context ${NAME}ctx --cluster=${NAME}cluster --user=$NAME --namespace=$DEFAULT_NAMESPACE

kubectl --kubeconfig=$NAME.config config use-context ${NAME}ctx --cluster=${NAME}cluster --user=$NAME
