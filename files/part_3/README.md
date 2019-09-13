# Part 3 :

This hands-on will guide you through how to set up the Oracle MySQL Operator and use it as a HA database backend for a Wordpress Installation. It has some really intersting components that are covered in the training:

* Stateful Set
* MySQL 8.0 Group Replication with Active/Passive cluster members
* Helm Chart for installation
* Utilizes S3 API for backups
* Uses mysql-router for health-cognizant load-balancing a MySQL Cluster 
* Peristent volumes using the StorageClass that specifies block storage
* Secrets for cluster connectivity, backups, as well as the wordpress database user

## Prerequisites

* Kubernetes cluster with RBAC 
* Helm 
* AWS configuration set up to read/write S3 buckets for backup & restore

## Get it running!

Change to the `files/part_3` directory (the directory of this README)

If you haven't [installed Helm](https://helm.sh/docs/using_helm/), please do so -- you will need it!

confirm that helm works
```
$ helm ls
```

Create the namespace that the operator needs to run in 

```console
$ kubectl create namespace mysql-operator
```

Install the operator

```console
$ helm install --name mysql-operator mysql-operator 

Create a namespace to install the MySQL Cluster and Wordpress installation to and set the current context to that namespace:

```console
$ kubectl create namespace part3
$ kubectl config set-context --current --namespace=part3
```

Enter the `files/part_3/wordpress-router` directory.
Create a RBAC service account required for the MySQL Agent:

```console
$ kubectl apply -f service-account.yaml
```

Create the MySQL Cluster!

```console
$ kubectl apply -f wordpress-database.yaml 
```

Create the Wordpress router

```console
$ kubectl apply -f wordpress-router.yaml
```

List services. Note the `wordpress-router` service on port 80

```console
$ kubectl get svc -n part3
NAME               TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)    AGE
mysql-wordpress    ClusterIP   None           <none>        3306/TCP   49m
wordpress-router   ClusterIP   10.9.8.7       <none>        80/TCP     27m
```

Set up a port forward to that service

```console
kubectl port-forward svc/wordpress-router 8008:80
```

Access your Wordpress blog on http://localhost:8008! 
