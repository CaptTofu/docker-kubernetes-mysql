# Exercise #2: Running MySQL on Kubernetes

This repo consistes of two excercises. 

* 2.1 Simple MySQL + Wordpress example: a single container MySQL installation using a deployment along with a wordpress container also using a deployment
* 2.2 Stateful Set MySQL with simple asynchronous Replication: this uses an examle from Google used to demonstrate using stateful sets with MySQL

## Files in this repo

* mysql-wordpress-simple-deployment/ - directory with simple mysql + wordpress files
  * kustomization.yaml - used by kubectl to set up the secrets needed 
  * mysql-deployment.yaml - the mysql deployment 
  * wordpress-deployment.yaml
* mysql-simple-replication-ss/ - directory holding files for MySQL simple replication statefulset 
  * kmysql.sh - convenience script used to run a mysql client in a container to connect to mysql containers
  * mysql-configmap.yml - configmap containing master/slave configurations
  * mysql-services.yml - services for the statefulset (read-only, placeholder server)
  * mysql-ss.yml - the statefulset 


## 2.1 Simple MySQL + Wordpress Example

This first example will create a single MySQL pod deployment for MySQL using a persistent volume/volume claim, secret, and a service

This example can be found in the Kubernetes documentation and is an excellent example of a fast, simple, and easy to configure blog running on Kubernetes

### Namespace setup

Enter the directory `mysql-wordpress-simple-deployment/`

Create a namespace for `part2` and set the current context to `part2`

```console
kubectl create ns part2
kubectl config set-context --current --namespace=part2
```

Create the MySQL deployment 
```console
$ kubectl apply -f mysql-deployment.yaml 
```

Create the wordpress application deployment
```console
$ kubectl delete -f wordpress-deployment.yaml 
```

### Using your application

To connect to your application, there are several ways.

First, list the services to identify the service for Wordpress (the IP addresses here are only shown as an example):

```console
$ kubectl get svc
NAME              TYPE           CLUSTER-IP      EXTERNAL-IP    PORT(S)        AGE
wordpress         LoadBalancer   10.96.76.115    138.1.36.109   80:32571/TCP   24m
wordpress-app     ClusterIP      10.96.159.162   <none>         80/TCP         89m
wordpress-mysql   ClusterIP      None            <none>         3306/TCP       25m
```

From above, the `wordpress` service is running on port 80, so create a `port-forward` to that service. This will make it possible to access the wordpress installation locally

```console
$ kubectl port-forward svc/wordpress 8008:80
Forwarding from 127.0.0.1:8008 -> 80
Forwarding from [::1]:8008 -> 80
```

Next, access http://localhost:8008 to begin install of the Wordpress database tables and setting up an administrative user. Have Fun!

### Cleanup

```console
$ kubectl delete -f mysql-deployment.yaml 
$ kubectl delete -f wordpress-deployment.yaml 
```

## 2.2 Stateful Set MySQL with simple asynchronous replication

Exercise #2 will guide you through creating a simple master-slave replication topology running on Kubernetes

This hands-on will show you how to create a simple master->slave asynchronous MySQL replication topology discussed in part 2 of the lesson.

This example is from the excellent work of Anthony Yeh and more details can be found [Here](https://kubernetes.io/docs/tasks/run-application/run-replicated-stateful-application)

This example will demonstrate several Kubernetes features that facilitate running stateful applications on Kubernetes

1. A stateful set to guarantee ordering of the launching of the master and subsequent number of slaves
2. Secrets for storing passwords used by the slaves to connect to the master as well as performing backups
3. ConfigMap for MySQL configuration for both the slave and master
4. Volumes for persistent data


###  Launch the statefulset to Kubernetes

First, create the configmap 
```console
$ kubectl apply -f mysql-configmap.yml 
```
Create the services:
```console
$ kubectl apply -f mysql-services.yml -n part2
```

Create the statefulset
```console
$ kubectl apply -f mysql-ss.yml -n part2 
```

Test connecting, to a slave:
```
$ ./kmysql.sh mysql-1.mysql
```

Or the master:

```
$ ./kmysql.sh mysql-0.mysql
```
Some commands to observe your statefulset:

```console
$ kubectl get statefulsets
$ kubectl get po
$ kubectl logs -100 mysql-1 
$ kubectl get po,svc,statefulsets,secrets,configmap,pv,pvc
```

### Cleanup

```
$ kubectl delete -f mysql-services.yml 
$ kubectl delete -f mysql-ss.yml 
$ kubectl delete -f mysql-configmap.yml 
```