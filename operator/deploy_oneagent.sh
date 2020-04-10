#!/bin/bash

readinput () {
# Ask the user for their name
echo "Please enter the API_TOKEN:"
read API_TOKEN
echo "Please enter the PAAS_TOKEN:"
read PAAS_TOKEN
echo "Please enter the Tenant URl without leading / nor protocol"
echo "Managed example: abc1234.dynatrace-managed.com/e/thetenantid"
echo "SaaS example: abc1234.live.dynatrace.com"
read TENANT_API

echo "API_TOKEN="$API_TOKEN
echo "PAAS_TOKEN="$PAAS_TOKEN
echo "TENANT_URL="$TENANT_API
echo "Is this correct? [y/n]"
read REPLY
}


deploy_operator () {
export API_TOKEN=$API_TOKEN
export PAAS_TOKEN=$PAAS_TOKEN
export TENANT_API=https://$TENANT_API/api

# Install the operator
echo "Creating dynatrace K8s namespace"
kubectl create namespace dynatrace
LATEST_RELEASE=$(curl -s https://api.github.com/repos/dynatrace/dynatrace-oneagent-operator/releases/latest | grep tag_name | cut -d '"' -f 4)
echo "Creating K8s deployment for the latest oneagent operator release"
curl -o kubernetes.yaml https://raw.githubusercontent.com/Dynatrace/dynatrace-oneagent-operator/$LATEST_RELEASE/deploy/kubernetes.yaml
kubectl create -f kubernetes.yaml
#kubectl -n dynatrace logs -f deployment/dynatrace-oneagent-operator
kubectl -n dynatrace create secret generic oneagent --from-literal="apiToken=$API_TOKEN" --from-literal="paasToken=PAAS_TOKEN"

curl -o cr.yaml https://raw.githubusercontent.com/Dynatrace/dynatrace-oneagent-operator/$LATEST_RELEASE/deploy/cr.yaml
sed -i "s+apiUrl: https://ENVIRONMENTID.live.dynatrace.com/api+apiUrl: $TENANT_API+g" cr.yaml
kubectl create -f cr.yaml
echo "Done deploying the oneagent via operator"
}

#Reading input
readinput
case "$REPLY" in
    [yY]) 
        deploy_operator
        ;;
    *)
        echo "Ups... ok bye.."
        exit
        ;;
esac
exit

