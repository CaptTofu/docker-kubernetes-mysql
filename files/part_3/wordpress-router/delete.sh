#!/bin/bash

kubectl delete -f wordpress-deployment.yaml
kubectl delete -f wordpress-database.yaml
kubectl delete -f service-account.yaml
helm delete mysql-operator --purge
kubectl delete ns wordpress
