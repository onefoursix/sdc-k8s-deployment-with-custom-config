### Example 2: Baked-in Configuration and Stage Libraries
 
This example packages a custom <code>sdc.properties</code> file within a custom SDC image, as well as a set of SDC Stage Libraries, at the time the image is built, similar to the example [here](https://github.com/streamsets/control-agent-quickstart/tree/master/custom-datacollector-docker-image).  

This approach is suitable for [execution](https://streamsets.com/documentation/controlhub/latest/help/controlhub/UserGuide/DataCollectors/DataCollectors_title.html) SDCs whose configuration and SDC Stage Libraries do not need to be dynamically set.  The <code>sdc.properties</code> file "baked in" to the custom SDC image may include custom settings for properties like <code>production.maxBatchSize</code> and email configuration if these properties are consistent across deployments. 

Set <code>http.realm.file.permission.check=false</code> in your <code>sdc.properties</code> file to avoid permission issues.

See the <code>Dockerfile</code> and <code>build.sh</code> in the [Example 2](https://github.com/onefoursix/sdc-k8s-deployment-with-custom-config/tree/master/Example-2/sdc-docker-custom-config) directory. 

 
