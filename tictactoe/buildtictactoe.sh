#!/bin/bash

# Build tick tack toe and push it to the repository of microk8s
docker build . -t localhost:32000/davisttt:0.1

# we push the image into the cluster repository
docker push localhost:32000/davisttt:0.1