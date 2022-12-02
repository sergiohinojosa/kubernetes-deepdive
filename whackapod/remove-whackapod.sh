#!/bin/bash
# Usage: bash remove-etherpad.sh
kubectl -n whackapod delete -f manifests/
kubectl delete ns whackapod