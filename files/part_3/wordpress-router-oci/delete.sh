#!/bin/bash

kubectl delete -f wordpress-deployment.yaml
kubectl delete -f wordpress-database.yaml
kubectl delete -f service-account.yaml
for pvc in 0 1 2 3 4; do kubectl delete pvc data-mysql-wordpress-$pvc; done
for pv in $(kubectl get pv|grep oci|awk '{ print $1 }'); do  kubectl delete pv $pv; done
cd dns 
kubectl delete -f externaldns-rbac.yaml
cd ..
helm delete mysql-operator --purge
kubectl delete secret wordpress-mysql-root-password -n default
kubectl delete secret s3-credentials -n default 
kubectl delete secret external-dns-config -n default
kubectl delete ns wordpress
kubectl delete ns mysql-operator 
