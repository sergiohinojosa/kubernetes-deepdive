# The SimplCommerce NET Core App:
https://github.com/simplcommerce/SimplCommerce



# Docker 
## Docker Compose with Simplcommerce, Postgres & PgAdmin 
So you can test docker compose, the images are already created. You only need `docker` and `docker-compose`.

## Docker-compose commands
> build the app with clean DB
docker-compose up 
> In detached mode
docker-compose up -d

> Gracefully shutdown (persisting data)
docker-compose down

> Destroy data (clean DB) 
docker-compose down -v



# Kubernetes
Kubectl commands for copy paste

## Create

kubectl create ns simplcommerce

kubectl -n simplcommerce apply -f 


## Delete only shop
kubectl delete --all deploy -n simplcommerce

kubectl delete --all svc -n simplcommerce

## Delete all
kubectl delete ns simplcommerce