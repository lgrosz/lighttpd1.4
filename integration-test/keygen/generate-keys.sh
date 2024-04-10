#!/bin/sh

# Generate root CA
openssl req -x509 -nodes -newkey rsa:4096 -keyout rootCA.key -out rootCA.crt -days 365 -subj "/CN=Root CA" > /dev/null 2>&1

# Generate intermediate CSR
openssl req -new -nodes -newkey rsa:4096 -keyout intermediate.key -out intermediate.csr -config intermediate.cnf > /dev/null 2>&1

# Sign intermediate CA
openssl x509 -req -in intermediate.csr -CA rootCA.crt -CAkey rootCA.key -CAcreateserial -out intermediate.crt -days 365 -extfile intermediate.cnf -extensions req_ext > /dev/null 2>&1

# Generate child CSR
openssl req -new -nodes -newkey rsa:4096 -keyout child.key -out child.csr -subj "/CN=Client" > /dev/null 2>&1

# Sign child CA
openssl x509 -req -in child.csr -CA intermediate.crt -CAkey intermediate.key -CAcreateserial -out child.crt -days 365 > /dev/null 2>&1

# Create client-certificate chain
cat child.crt intermediate.crt > client-chain.crt

# Server should get the root cert
cp rootCA.crt server

# Client needs its key and cert-chain
cp child.key client-chain.crt client
