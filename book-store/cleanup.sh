#!/bin/bash
# Set up of the Book application of istio for Microk8s
# https://istio.io/docs/examples/bookinfo/

# we delete the app
kubectl delete ns book
 
# we disable istio
microk8s.disable istio