> kubectl create namespace kiali-operator

#### Use a YAML file for depoying Kiali without login (Strategy Anonymous) 
> helm install --set cr.create=true --set cr.namespace=istio-system  --namespace kiali-operator --repo https://kiali.org/helm-charts kiali-operator kiali-operator

change the service of kiali-operator for NodePort to see what it does

then expose the UI of kiali with

> istioctl dashboard kiali
(which creates in the istio-system ns a deployment with a service for UI and another for Metrics?)

Opening Access by editing the CM (not the best approach since the POD will bounce again and the CM will be reseted.)
> kubectl edit cm kiali -n istio-system 

auth:
   strategy: anonymous

### Hint to get token from Microk8s
> kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep default-token | cut -d " " -f1)
> 