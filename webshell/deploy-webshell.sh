#!/bin/bash
# Usage: sh deploy-webshell.sh
# Bash for deploying webshell in Kubernetes

#docker run -d --privileged --security-opt seccomp=unconfined --name webshell -p 8018:80 -e ALLOWED_NETWORKS=0.0.0.0/0 bwsw/webshell
kubectl create ns webshell

# Set the public ip for the ingress rule.
export PUBLIC_IP=$(curl -s ifconfig.me) 
PUBLIC_IP_AS_DOM=$(echo $PUBLIC_IP | sed 's~\.~-~g')
export DOMAIN="${PUBLIC_IP_AS_DOM}.nip.io"
sed 's~domain.placeholder~'"$DOMAIN"'~' 03-webshell-ingress.template > 03-webshell-ingress.yaml

kubectl -n webshell apply -f .
echo "webshell service available at:"
kubectl -n webshell get ing webshell-ingress

