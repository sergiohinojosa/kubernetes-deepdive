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


kubectl create ns simplcommerce

# Create deployment of simplcommerce with sqlite db inside container.
#kubectl -n simplcommerce create deploy simplcommerce --image=shinojosa/simplcommerce-coza

# Expose deployment of simplcommerce
#kubectl -n simplcommerce expose deployment simplcommerce --type=NodePort --port=80 --name simplcommerce

kubectl -n simplcommerce apply -f manifests/

sed 's~domain.placeholder~'"$DOMAIN"'~'  manifests/ingress/pgadmin-ingress.template > manifests/ingress/pgadmin-ingress.yaml
sed 's~domain.placeholder~'"$DOMAIN"'~'  manifests/ingress/simplcommerce-ingress.template > manifests/ingress/simplcommerce-ingress.yaml

kubectl -n simplcommerce apply -f manifests/ingress/

echo "The application is available in the following endpoints"
kubectl get ing -n simplcommerce


