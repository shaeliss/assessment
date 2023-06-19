#!/bin/bash
GROUPNAME="$1"
openssl genrsa -out "${GROUPNAME}-user1.key" 2048
openssl req -new -key ${GROUPNAME}-user1.key -out ${GROUPNAME}-user1.csr -subj "/CN=${GROUPNAME}-user1/O=${GROUPNAME}"
openssl x509 -req -in ${GROUPNAME}-user1.csr -CA ~/.minikube/ca.crt -CAkey ~/.minikube/ca.key -CAcreateserial -out ${GROUPNAME}-user1.crt -days 400
