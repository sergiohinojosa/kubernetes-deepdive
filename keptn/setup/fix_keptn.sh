#!/bin/bash
echo "About to configure Keptn for Microk8s"
export PUBLIC_IP=$(curl -s ifconfig.me) 

PUBLIC_IP_AS_DOM=$(echo $PUBLIC_IP | sed 's~\.~-~g')
export DOMAIN="${PUBLIC_IP_AS_DOM}.nip.io"

printf  "Entering this domain $DOMAIN for the Keptn ConfigMap \n"

# Fix ConfigMap - Configure the App Domain
cat cm-keptn.yaml | \
  sed 's~domain.placeholder~'"$DOMAIN"'~' > ./gen/cm-keptn.yaml

kubectl apply -f gen/cm-keptn.yaml

# Fix VirtualService KEPTN API
cat vs-keptn-api.yaml | \
  sed 's~domain.placeholder~'"$DOMAIN"'~' > ./gen/vs-keptn-api.yaml
kubectl apply -f gen/vs-keptn-api.yaml

echo "\nSetting up the Bridge for Keptn \n"

# Deploy Bridge EAP
kubectl -n keptn set image deployment/bridge bridge=keptn/bridge2:20200308.0859 --record
kubectl -n keptn set image deployment/configuration-service configuration-service=keptn/configuration-service:20200308.0859 --record
kubectl -n keptn-datastore set image deployment/mongodb-datastore mongodb-datastore=keptn/mongodb-datastore:20200308.0859 --record

# To be sure restart datastore
kubectl delete po -n keptn-datastore --all

rm -f ../expose-bridge/manifests/gen/bridge.yaml
cat ../expose-bridge/manifests/bridge.yaml | \
  sed 's~domain.placeholder~'"$DOMAIN"'~' > ../expose-bridge/manifests/gen/bridge.yaml
kubectl apply -f ../expose-bridge/manifests/gen/bridge.yaml
echo "Bridge URL: https://bridge.keptn.$DOMAIN \n"

# Fix VirtualService
cat ingress.yaml | \
  sed 's~domain.placeholder~'"$DOMAIN"'~' > ./gen/ingress.yaml
kubectl apply -f gen/ingress.yaml

# Authenticate and change cli settings
keptn auth --endpoint=https://api.keptn.$(kubectl get cm -n keptn keptn-domain -ojsonpath={.data.app_domain}) --api-token=$(kubectl get secret keptn-api-token -n keptn -ojsonpath={.data.keptn-api-token} | base64 --decode)

# Print the status of the keptn CLI
keptn status