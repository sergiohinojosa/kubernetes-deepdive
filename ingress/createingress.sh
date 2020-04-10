#!/bin/bash
## Create Ingress Rules

export PUBLIC_IP=$(curl -s ifconfig.me) 
sed "s/PUBLIC_IP/$PUBLIC_IP/g" ingress.template > ingress.yaml
kubectl apply -f ingress.yaml