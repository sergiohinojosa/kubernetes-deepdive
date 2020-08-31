#!/bin/bash
# Create namespace workshop
kubectl create ns workshop

# Create deployment of simplenode
kubectl -n workshop create deploy simplenode --image=grabnerandi/simplenodeservice:1.0.0 

# Expose deployment of simplenode
kubectl -n workshop expose deployment simplenode --type=NodePort --port=8080 --name simplenode
