#!/bin/bash

# Create namespace workshop
kubectl create ns simplenode

# Create deployment of simplenode
kubectl -n simplenode create deploy simplenode --image=grabnerandi/simplenodeservice:1.0.0 

# Expose deployment of simplenode
kubectl -n simplenode expose deployment simplenode --type=NodePort --port=8080 --name simplenode

## Get Public IP as NIP Domain
export PUBLIC_IP=$(curl -s ifconfig.me) 
PUBLIC_IP_AS_DOM=$(echo $PUBLIC_IP | sed 's~\.~-~g')
export DOMAIN="${PUBLIC_IP_AS_DOM}.nip.io"

## Create Ingress Rules
sed 's~domain.placeholder~'"$DOMAIN"'~' manifests/ingress.template > manifests/ingress.yaml

kubectl -n simplenode apply -f manifests/ingress.yaml

echo "Simplnode is available here:"
kubectl get ing -n simplenode