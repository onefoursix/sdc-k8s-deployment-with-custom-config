## sdc-k8s-deployment-with-custom-config

This project provides examples and guidance for deploying custom configurations of [StreamSets Data Collector](https://streamsets.com/products/dataops-platform/data-collector) (SDC) on Kubernetes using [Control Hub](https://streamsets.com/products/dataops-platform/control-hub).

 ### Option #1: Baked-in Configuration
 
 This option involves creating a customized <code>sdc.properties</code> file and bundling that file in with your own SDC image, similar to the example [here](https://github.com/streamsets/control-agent-quickstart/tree/master/custom-datacollector-docker-image).  See the provided Dockerfile and build.sh in the [example_1](https://github.com/onefoursix/sdc-k8s-deployment-with-custom-config/example_1) directory.