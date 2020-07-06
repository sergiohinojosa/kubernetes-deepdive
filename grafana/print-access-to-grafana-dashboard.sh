#!/bin/bash
# We will access the grafana dashboard via the KubeAPI and the HTTP Proxy
NC='\033[0m' # No Color
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'

USER=admin
PASSWORD=$(kubectl config view -o jsonpath='{.users[?(@.name=="admin")].user.password}')
APIENDPOINT=$(kubectl get ing k8-api-ingress -ojsonpath={.spec.rules[0].host})
export PUBLIC_IP=$(curl -s ifconfig.me) 
printf "${GREEN}Grafana ${NC}is running at ${YELLOW} https://$PUBLIC_IP:16443/api/v1/namespaces/kube-system/services/monitoring-grafana/proxy\n ${NC}"
printf "${GREEN}By the way ${NC}it is also accessible ${CYAN}(with a valid certificate) ${NC} at\n ${YELLOW}https://$APIENDPOINT/api/v1/namespaces/kube-system/services/monitoring-grafana/proxy\n  ${NC}"
printf "You can access is with the user:${GREEN}$USER${NC} and password:${GREEN}$PASSWORD${NC}\n"
