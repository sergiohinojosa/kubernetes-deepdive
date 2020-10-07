# The Hipstershop from Google can be found here:

https://github.com/GoogleCloudPlatform/microservices-demo

The latest release can be found here:

https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/master/release/kubernetes-manifests.yaml


Kubectl commands for copy paste
## Create

kubectl create ns hipstershop

kubectl -n hipstershop apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/master/release/kubernetes-manifests.yaml


## Delete only shop

kubectl delete ns hipstershop

kubectl delete --all deploy -n hipstershop

kubectl delete --all svc -n hipstershop


## Delete all

kubectl delete ns hipstershop

