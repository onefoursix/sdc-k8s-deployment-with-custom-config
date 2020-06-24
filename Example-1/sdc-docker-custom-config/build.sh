#!/usr/bin/env bash

IMAGE_NAME=onefoursix/sdc-custom-config:latest

docker build -t $IMAGE_NAME \
--build-arg SDC_LIBS=\
streamsets-datacollector-jdbc-lib,\
streamsets-datacollector-jython_2_7-lib,\
streamsets-datacollector-azure-keyvault-credentialstore-lib \
.

docker push $IMAGE_NAME
