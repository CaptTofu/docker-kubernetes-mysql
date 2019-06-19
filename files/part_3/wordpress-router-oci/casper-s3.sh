#!/bin/bash

kubectl create secret generic s3-credentials --from-literal=accessKey=${AWS_ACCESS_KEY} --from-literal=secretKey=${AWS_SECRET_KEY}
