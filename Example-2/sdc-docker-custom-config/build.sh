#!/usr/bin/env bash

IMAGE_NAME=<your-repo>/<your image>:<your tag>

docker build -t $IMAGE_NAME \
--build-arg SDC_LIBS=\
streamsets-datacollector-jdbc-lib,\
streamsets-datacollector-jython_2_7-lib \
.

docker push $IMAGE_NAME
