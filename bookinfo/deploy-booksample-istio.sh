#!/bin/bash +x
# Set up of the Book application of istio for Microk8s
# https://istio.io/docs/examples/bookinfo/


echo "We create a book namespace for the application"
kubectl create ns book
echo "enable the isito injection in the book namespace"
kubectl label namespace book istio-injection=enabled
echo "deploy the book app"
kubectl -n book apply -f manifests/ 

# We print out the http NodePort of the Istio IngressGateway with the URL of the app.
export PUBLIC_IP=$(curl -s ifconfig.me)
nodePort=$(kubectl get svc -n istio-system istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].nodePort}')
printf "\n\n*****\nThe Book application is now available at http://$PUBLIC_IP:$nodePort/productpage\n*******\n\n"
