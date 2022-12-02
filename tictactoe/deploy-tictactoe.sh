#!/bin/bash

kubectl create ns tictactoe

# Create deployment of tictactoe
kubectl -n tictactoe create deploy tictactoe --image=localhost:32000/davisttt:0.1

# Expose deployment of tictactoe with a Service
kubectl -n tictactoe expose deployment tictactoe --type=NodePort --port=80 --name tictactoe

# Expose the Service with an Ingress and a magic domain
## Get Public IP as NIP Domain
export PUBLIC_IP=$(curl -s ifconfig.me) 
PUBLIC_IP_AS_DOM=$(echo $PUBLIC_IP | sed 's~\.~-~g')
export DOMAIN="${PUBLIC_IP_AS_DOM}.nip.io"

## Create Ingress Rules
sed 's~domain.placeholder~'"$DOMAIN"'~' manifests/ingress.template > manifests/ingress.yaml

kubectl -n tictactoe apply -f manifests/ingress.yaml

echo "Tic Tac Toe is available at.."
kubectl get ing -n tictactoe