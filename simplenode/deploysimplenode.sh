#!/bin/bash

# Create deployment of simplenode
kubectl create deploy simplenode --image=grabnerandi/simplenodeservice:1.0.0

# Expose deployment of simplenode
kubectl expose deployment simplenode --type=NodePort --port=8080 --name simplenode
