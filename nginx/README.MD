#Dockerize the Homepage of the KubernetesBox


docker build -t nginxacm .

docker run -d -p 80:80 --name nginxacm nginxacm
