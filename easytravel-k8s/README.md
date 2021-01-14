# EasyTravel on Kubernetes!

This what we have done so EasyTravel is working:
1. Edit the CLUSTER_IP in [`loadgen-config.yaml`](ConfigMaps/loadgen-config.yaml#10) to your cluster IP.

## Start EasyTravel


 1. `kubectl apply -f ConfigMaps/`
 2. `kubectl apply -f Services/`
 3. `kubectl apply -f Deployments/`


Access EasyTravel (when running on local machine) under  [http://127.0.0.1:30088/](http://127.0.0.1:30088/)