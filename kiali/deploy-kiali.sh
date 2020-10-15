#!/bin/bash

if [ $# -eq 1 ]; then
    # Read JSON and set it in the CREDS variable 
    DOMAIN=$1
    echo "Domain passed $DOMAIN"
else
   export PUBLIC_IP=$(curl -s ifconfig.me) 
   PUBLIC_IP_AS_DOM=$(echo $PUBLIC_IP | sed 's~\.~-~g')
   export DOMAIN="${PUBLIC_IP_AS_DOM}.nip.io"
fi

#TODO Add dependencies and deploy
echo "Add or check dependencies"
echo "Deploy Kiali"

sed 's~domain.placeholder~'"$DOMAIN"'~'  ingress.template > manifests/ingress.yaml

echo "Expose Kiali UI via Ingress"
kubectl apply -f manifests/

# Delete deployment
#TODO Delete deployment