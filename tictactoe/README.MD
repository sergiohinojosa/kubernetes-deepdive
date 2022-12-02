# Tick Tack Toe

For this app you'll need to have the image registry activated of microk8s.

You'll learn how to create a docker container, pack it into a pod and expose it via Kubectl.


## 1. Build the image 

`bash buildtictactoe.sh`

````
# Build tick tack toe and push it to the repository of microk8s
docker build . -t localhost:32000/davisttt:0.1

# we push the image into the cluster repository
docker push localhost:32000/davisttt:0.1
````

Pushing to this insecure registry may fail in some versions of Docker unless the daemon is explicitly configured to trust this registry. To address this we need to edit (or add) `/etc/docker/daemon.json` and add:
```
{
  "insecure-registries" : ["localhost:32000"]
}
```
The new configuration should be loaded with a Docker daemon restart:

`sudo systemctl restart docker`

push again and it should succeeed!


## 2. Create a deployment, add the image in the POD and expose it via Ingress.
 
`bash deploy-tictactoe.sh`

Inspect the shell file to understand the declarative approach of deploying via kubectl.