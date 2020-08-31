#!/bin/bash

# Create namespace workshop
kubectl create ns workshop

# Create deployment of simplenode
kubectl -n workshop create deploy simplenode --image=grabnerandi/simplenodeservice:1.0.0 

# Expose deployment of simplenode
kubectl -n workshop expose deployment simplenode --type=NodePort --port=8080 --name simplenode

## Get Public IP as NIP Domain
export PUBLIC_IP=$(curl -s ifconfig.me) 
PUBLIC_IP_AS_DOM=$(echo $PUBLIC_IP | sed 's~\.~-~g')
export DOMAIN="${PUBLIC_IP_AS_DOM}.nip.io"

## Create Ingress Rules
sed 's~domain.placeholder~'"$DOMAIN"'~' ingress.template > manifests/ingress.yaml

kubectl apply -f manifests/ingress.yaml