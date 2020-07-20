### Loading stage libs or other resources from a read-only Volume

This example shows how to load stage libs, config files or other resources from a shared and presumably read-only Volume.  This technique can be used to load any resources needed by SDC at deployment time that are not baked into the SDC image, including stage libs, hadoop config files, lookup files, JDBC drivers, etc... 

It is up to the deployer to populate the shared volume; the [get-stage-libs.sh](https://github.com/onefoursix/sdc-k8s-deployment-with-custom-config/blob/master/examples/example-3/get-stage-libs.sh) script provides an example of how to download SDC stage libs.

Once the shared volume is populated, it can be added and mounted in an [SDC deployment manifest](https://github.com/onefoursix/sdc-k8s-deployment-with-custom-config/blob/master/examples/example-3/sdc.yaml) 

