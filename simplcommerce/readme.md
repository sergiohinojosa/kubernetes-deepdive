# The SimplCommerce NET Core App:

https://github.com/simplcommerce/SimplCommerce


Kubectl commands for copy paste
## Create

kubectl create ns simplcommerce

kubectl -n simplcommerce apply -f 


## Delete only shop
kubectl delete --all deploy -n simplcommerce

kubectl delete --all svc -n simplcommerce

## Delete all
kubectl delete ns simplcommerce