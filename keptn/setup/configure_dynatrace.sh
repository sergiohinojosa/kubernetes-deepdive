#!/bin/bash

readinput () {
# Ask the user for their name
echo "Please enter the DT_API_TOKEN:"
read DT_API_TOKEN
echo "Please enter the DT_PAAS_TOKEN:"
read DT_PAAS_TOKEN
echo "Please enter the Tenant URl without leading / nor protocol"
echo "Managed example: abc1234.dynatrace-managed.com/e/thetenantid"
echo "SaaS example: abc1234.live.dynatrace.com"
read DT_TENANT

echo "DT_API_TOKEN="$DT_API_TOKEN
echo "DT_PAAS_TOKEN="$DT_PAAS_TOKEN
echo "DT_TENANT="$DT_TENANT
echo "Is this correct? [y/n]"
read REPLY
}


deploy_operator () {
export API_TOKEN=$API_TOKEN
export PAAS_TOKEN=$PAAS_TOKEN
export DT_TENANT=$DT_TENANT

# Create secret
kubectl -n keptn create secret generic dynatrace --from-literal="DT_TENANT=$DT_TENANT" --from-literal="DT_API_TOKEN=$DT_API_TOKEN"  --from-literal="DT_PAAS_TOKEN=$DT_PAAS_TOKEN"

# Deploy Dynatrace service
kubectl apply -f https://raw.githubusercontent.com/keptn-contrib/dynatrace-service/0.6.1/deploy/manifests/dynatrace-service/dynatrace-service.yaml


# Deploy SLI Service 
kubectl apply -f https://raw.githubusercontent.com/keptn-contrib/dynatrace-sli-service/0.3.0/deploy/service.yaml


#Tell Keptn to configure Dynatrace
keptn configure monitoring dynatrace

#show the svc
kubectl get svc dynatrace-service -n keptn

kubectl get pods -n dynatrace

echo "Done deploying the oneagent via keptn"
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

