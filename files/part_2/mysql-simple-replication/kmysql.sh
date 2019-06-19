#!/bin/bash

echo "Running: kubectl run mysql-client --image=mysql:5.7 -it --rm --restart=Never -- mysql -h $@"
kubectl run mysql-client --image=mysql:5.7 -it --rm --restart=Never -- mysql -h $@ 

