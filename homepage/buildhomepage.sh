#!/bin/bash

# Build tick tack toe and push it to the repository of microk8s
docker build . -t shinojosa/k8deepdive

# we push the image into the cluster repository
docker push shinojosa/k8deepdive

