Omeka-S in docker

There is also example of docker-compose.yml file which can be used for development.
It creates 3 containers:

- mysql db
- phpmyadmin
- omeka-s behind apache (modules or themes can be inserted via docker volumes)

`docker-compose up`

Commands to create docker image

sudo docker build -t sunny3p/omeka-s .
sudo docker push sunny3p/omeka-s 

`kubernetes deployment`

Commands to deploy it on kubernetes 

cd to Kubernestes deployment folder

kubectl create namespace omeka
kubectl apply -k ./  -n omeka

To Delete the deployment
kubectl delete -k ./  -n omeka

kubectl -n omeka exec -it omeka-64b886f686-2tb7h  -- /bin/bash
kubectl port-forward svc/omeka 8081:80 -n omeka

https://stackoverflow.com/questions/52369247/namespace-stuck-as-terminating-how-do-i-remove-it

kubectl describe pvc mysql-pv-claim | grep Finalizers
kubectl patch pvc omekaclassic-pv-claim -p '{"metadata":{"finalizers": []}}' --type=merge -n omeka-classic

Resources and Reference
1. Docker documentation: https://docs.docker.com/engine/reference/builder/ 
2. Docker Cheat Sheet: https://github.com/wsargent/docker-cheat-sheet 
3. Docker Tutorial: https://www.flux7.com/tutorial/docker-tutorial-series-part-1-an-introduction-docker-components/
4. Omeka-S Previous Old Docker Image: https://github.com/klokantech/omeka-s-docker  