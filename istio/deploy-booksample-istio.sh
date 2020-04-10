#!/bin/bash
# Set up of the Book application of istio for Microk8s
# https://istio.io/docs/examples/bookinfo/

# We enable istio and when prompted if enable TLS authentication between sidecars injection we say 'N'o
echo 'N;' | microk8s.enable istio

echo "We sleep for a minute to give time to istio to initiate..." 
sleep 1m

# We create a namespace for the application
kubectl create ns book
# We enable the injection in the book namespace
kubectl label namespace book istio-injection=enabled
# we install the book 
kubectl -n book apply -f manifests/ 

# We print out the http NodePort of the Istio IngressGateway with the URL of the app.
export PUBLIC_IP=$(curl -s ifconfig.me)
nodePort=$(kubectl get svc -n istio-system istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].nodePort}')
printf "\n\n*****\nThe Book application is now available at http://$PUBLIC_IP:$nodePort/productpage\n*******\n\n"