#!/bin/bash
# This script will install the certmanager with Cluster Issuer
# for Lets'encrypt with HTTP with an Nginx Ing

printf "\n\n***** Install CertManager ****\n"
kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v0.14.0/cert-manager.yaml

# Getting the public DOMAIN
export PUBLIC_IP=$(curl -s ifconfig.me) ;\
PUBLIC_IP_AS_DOM=$(echo $PUBLIC_IP | sed 's~\.~-~g') ;\
export DOMAIN="${PUBLIC_IP_AS_DOM}.nip.io" ;\
printf "Public DNS: $DOMAIN"

printf "\nCreate Cluster-Issuer\n"
kubectl apply -f clusterissuer.yaml


printf "\nDeploy NGINX for the Certificate validation of the domain in the istio-system namespace\n"
printf "The Ingress is declared in one route of the ingress-ssl-istio\n"
kubectl -n istio-system create deploy nginx --image=shinojosa/nginxacm
kubectl -n istio-system expose deploy nginx --port=80 --type=NodePort

cat ingress-ssl-istio.yaml | \
  sed 's~domain.placeholder~'"$DOMAIN"'~' > ./gen/ingress-ssl-istio.yaml

# Deploy ingress with rules to domains and ingress-gateway. Create secret and certificate
kubectl apply -f gen/ingress-ssl-istio.yaml

# LetsEncrypt Process
printf " For observing the creation of the certificates: \n
kubectl describe clusterissuers.cert-manager.io -A
kubectl describe issuers.cert-manager.io -A
kubectl describe certificates.cert-manager.io -A
kubectl describe certificaterequests.cert-manager.io -A
kubectl describe challenges.acme.cert-manager.io -A
kubectl describe orders.acme.cert-manager.io -A
kubectl get events
"