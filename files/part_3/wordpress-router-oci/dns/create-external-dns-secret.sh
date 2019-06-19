#!/bin/bash

kubectl create secret generic external-dns-config --from-file=oci.yaml
