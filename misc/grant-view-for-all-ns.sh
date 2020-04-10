#!/bin/bash
printf "\nGrant View Rights for all Namespaces\n"
for ns in `kubectl get ns | awk '{ if (NR!=1) print $1}'`; do kubectl -n $ns create rolebinding default-view --clusterrole=view --serviceaccount=$ns:default ; done

