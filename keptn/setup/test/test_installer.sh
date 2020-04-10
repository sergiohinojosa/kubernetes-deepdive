#!/bin/bash
echo "About to configure Keptn for Microk8s"

GATEWAY_TYPE="LoadBalancer"
#export PUBLIC_IP=$(curl -s ifconfig.me) 

if [[ "$GATEWAY_TYPE" == "LoadBalancer" ]]; then
  
  echo "Check if there is a custom domain to override"
  CUSTOM_DOMAIN=$(kubectl get configmap keptn-domain -o=jsonpath='{.data.domain}')
  if [ $CUSTOM_DOMAIN ]; then
      echo "Custom domain found $CUSTOM_DOMAIN\n Warning, there will be no validation of the domain nor istio-ingressgateway\n"
      export DOMAIN=$CUSTOM_DOMAIN
      export INGRESS_HOST=$DOMAIN
  else
      echo "wait_for_istio_ingressgateway hostname"
      export DOMAIN=$(kubectl get svc istio-ingressgateway -o json -n istio-system | jq -r .status.loadBalancer.ingress[0].hostname)
      if [[ $? != 0 ]]; then
          print_error "Failed to get ingress gateway information." && exit 1
      fi
      export INGRESS_HOST=$DOMAIN

      if [[ "$DOMAIN" == "null" ]]; then
          echo "Could not get ingress gateway domain name. Trying to retrieve IP address instead."
          echo "wait_for_istio_ingressgateway ip"
          export DOMAIN=$(kubectl get svc istio-ingressgateway -o json -n istio-system | jq -r .status.loadBalancer.ingress[0].ip)
          if [[ "$DOMAIN" == "null" ]]; then
              print_error "IP of Istio ingress gateway could not be derived."
              exit 1
          fi
          export DOMAIN="$DOMAIN.xip.io"
          export INGRESS_HOST=$DOMAIN
      fi
  fi 
elif [[ "$GATEWAY_TYPE" == "NodePort" ]]; then
    NODE_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].nodePort}')
    NODE_IP=$(kubectl get nodes -l node-role.kubernetes.io/worker=true -o jsonpath='{ $.items[0].status.addresses[?(@.type=="InternalIP")].address }')
    export DOMAIN="$NODE_IP.xip.io:$NODE_PORT"
    export INGRESS_HOST="$NODE_IP.xip.io"
fi

echo $DOMAIN
echo $INGRESS_HOST

if [[ "$PLATFORM" == "eks" ]]; then 
    echo "For EKS: No SSL certificate created. Please use keptn configure domain at the end of the installation."
else
    # Set up SSL
    openssl req -nodes -newkey rsa:2048 -keyout key.pem -out certificate.pem  -x509 -days 365 -subj "/CN=$INGRESS_HOST"

    kubectl create --namespace istio-system secret tls istio-ingressgateway-certs --key key.pem --cert certificate.pem
    #verify_kubectl $? "Creating secret for istio-ingressgateway-certs failed."

    rm key.pem
    rm certificate.pem
fi