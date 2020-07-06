#!/bin/bash
# Usage: sh remove-etherpad.sh
# will remove the Etherpad application
kubectl delete -f .
rm 03-etherpad-ingress.yaml