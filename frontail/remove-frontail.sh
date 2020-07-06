#!/bin/bash
# Usage: sh remove-frontail.sh
# will remove the Frontail application
rm -rf /tmp/pv-data/
kubectl delete -f .
rm 05-frontail-ingress.yaml