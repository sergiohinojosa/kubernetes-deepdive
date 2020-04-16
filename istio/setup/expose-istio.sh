#!/bin/bash -x


if [ $# -eq 1 ]; then
    # Read JSON and set it in the CREDS variable 
    DOMAIN=$1
else
    echo "No Domain has been passed, getting it from public ip"
    export PUBLIC_IP=$(curl -s ifconfig.me) 
    PUBLIC_IP_AS_DOM=$(echo $PUBLIC_IP | sed 's~\.~-~g')
    export DOMAIN="${PUBLIC_IP_AS_DOM}.nip.io"
    echo $DOMAIN
fi

printf "\nCreate Cluster-Issuer\n"
kubectl apply -f clusterissuer.yaml


printf "\nDeploy NGINX for the Certificate validation of the domain\n"
printf "The Ingress is declared in one route of the ingress-ssl-istio\n"
kubectl -n istio-system create deploy nginx --image=shinojosa/k8deepdive
kubectl -n istio-system expose deploy nginx --port=80 --type=NodePort

printf "\nRouting Istio via Nginx Ingress, create secret and certificates for the valid endpoints\n"

cat ingress-ssl-istio.yaml | \
  sed 's~domain.placeholder~'"$DOMAIN"'~' > ./gen/ingress-istio.yaml

# Deploy ingress with rules to domains and ingress-gateway. Create secret and certificate
kubectl apply -f gen/ingress-istio.yaml

