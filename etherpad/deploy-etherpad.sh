#!/bin/bash
# Usage: sh deploy-etherpad.sh
# Bash for deploying etherpad in Kubernetes
# Application https://github.com/ether/etherpad-lite/blob/develop/doc/docker.md

# Set the public ip for the ingress rule.

export PUBLIC_IP=$(curl -s ifconfig.me) 
PUBLIC_IP_AS_DOM=$(echo $PUBLIC_IP | sed 's~\.~-~g')
export DOMAIN="${PUBLIC_IP_AS_DOM}.nip.io"
sed 's~domain.placeholder~'"$DOMAIN"'~' 03-etherpad-ingress.template > 03-etherpad-ingress.yaml

kubectl apply -f .
echo "Etherpad service available at:"
kubectl get ing etherpad-ingress