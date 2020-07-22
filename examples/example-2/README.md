### Baked-in Configuration and Stage Libraries
 
This example packages a custom <code>sdc.properties</code> file within a custom SDC image, along with a set of SDC stage libs (including Enterprise stage libs), at the time the image is built.  

This approach is suitable for [execution SDCs](https://streamsets.com/documentation/controlhub/latest/help/controlhub/UserGuide/DataCollectors/DataCollectors.html#concept_mwp_fcf_gw) whose configuration and stage libs do not need to be dynamically set.  The <code>sdc.properties</code> file "baked in" to the custom SDC image may include custom settings for properties like <code>production.maxBatchSize</code> and email configuration if these properties are consistent across deployments. 

Set <code>http.realm.file.permission.check=false</code> in your <code>sdc.properties</code> file to avoid permission issues.

See the <code>Dockerfile</code> and <code>build.sh</code> in the [sdc-docker-custom-config](https://github.com/onefoursix/sdc-k8s-deployment-with-custom-config/tree/master/examples/example-2/sdc-docker-custom-config) directory.

 
