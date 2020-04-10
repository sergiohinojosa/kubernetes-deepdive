#!/bin/bash
echo "Routing ISTIO via Ingress"
export PUBLIC_IP=$(curl -s ifconfig.me) 

PUBLIC_IP_AS_DOM=$(echo $PUBLIC_IP | sed 's~\.~-~g')
export DOMAIN="${PUBLIC_IP_AS_DOM}.nip.io"

# Fix VirtualService
cat ingress.yaml | \
  sed 's~domain.placeholder~'"$DOMAIN"'~' > ./gen/ingress.yaml
kubectl apply -f gen/ingress.yaml
