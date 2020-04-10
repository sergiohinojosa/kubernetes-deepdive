#!/bin/bash
# Usage: sh deploy-etherpad.sh
# Bash for deploying etherpad in Kubernetes
# Application https://github.com/ether/etherpad-lite/blob/develop/doc/docker.md

# Set the public ip for the ingress rule.
export PUBLIC_IP=$(curl -s ifconfig.me) 
sed "s/PUBLIC_IP/$PUBLIC_IP/g" 03-etherpad-ingress.template > 03-etherpad-ingress.yaml
kubectl apply -f .
echo "Etherpad service available at:"
kubectl get ing etherpad-ingress