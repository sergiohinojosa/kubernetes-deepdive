#!/bin/bash

## Get Public IP as NIP Domain
export PUBLIC_IP=$(curl -s ifconfig.me) 
PUBLIC_IP_AS_DOM=$(echo $PUBLIC_IP | sed 's~\.~-~g')
export DOMAIN="${PUBLIC_IP_AS_DOM}.nip.io"

## Create Ingress Rules
sed 's~domain.placeholder~'"$DOMAIN"'~' ingress.template > manifests/ingress.yaml

kubectl apply -f manifests/ingress.yaml
