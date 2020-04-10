#!/bin/bash

echo "About to create a VirtualService to the Keptn Bridge service"

DOMAIN=$(kubectl get cm -n keptn keptn-domain -ojsonpath={.data.app_domain})

rm -f ./manifests/gen/bridge.yaml
cat ./manifests/bridge.yaml | \
  sed 's~domain.placeholder~'"$DOMAIN"'~' > ./manifests/gen/bridge.yaml

kubectl apply -f ./manifests/gen/bridge.yaml

echo "Bridge URL: https://bridge.keptn.$DOMAIN"
