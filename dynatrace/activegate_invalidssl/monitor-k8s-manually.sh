#!/bin/bash +x
# This script is for adding the k8 monitoring manualy

wget https://www.dynatrace.com/support/help/codefiles/kubernetes/kubernetes-monitoring-service-account.yaml
kubectl apply -f kubernetes-monitoring-service-account.yaml
printf "\nThis is API URI of the K8s cluster:"
kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}'
printf "\n\nThis is the Bearer Token for the K8s API:\n"
kubectl get secret $(kubectl get sa dynatrace-monitoring -o jsonpath='{.secrets[0].name}' -n dynatrace) -o jsonpath='{.data.token}' -n dynatrace | base64 --decode
printf "\n"

