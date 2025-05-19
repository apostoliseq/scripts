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
