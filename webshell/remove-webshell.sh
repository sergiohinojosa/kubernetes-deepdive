#!/bin/bash
# Usage: sh remove-etherpad.sh
# will remove the Etherpad application
kubectl -n webshell delete -f .
kubectl delete ns webshell
rm 03-webshell-ingress.yaml