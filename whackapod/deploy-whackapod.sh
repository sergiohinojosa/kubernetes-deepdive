#!/bin/bash

export PUBLIC_IP=$(curl -s ifconfig.me)
sed "s/PUBLIC_IP/$PUBLIC_IP/g" ingress.template > manifests/07-ingress.yaml

kubectl apply -f manifests/