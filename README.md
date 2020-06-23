## sdc-k8s-deployment-with-custom-config

This project provides examples and guidance for deploying custom configurations of [StreamSets Data Collector](https://streamsets.com/products/dataops-platform/data-collector) (SDC) on Kubernetes using [Control Hub](https://streamsets.com/products/dataops-platform/control-hub).

### Example 1: Baked-in Configuration
 
This approach involves creating a customized <code>sdc.properties</code> file and packaging that file in with your own SDC image, similar to the example [here](https://github.com/streamsets/control-agent-quickstart/tree/master/custom-datacollector-docker-image).  See the provided <code>Dockerfile</code> and <code>build.sh</code> artifacts in the [example_1](https://github.com/onefoursix/sdc-k8s-deployment-with-custom-config/tree/master/example_1) directory.  This approach is most suitable for [execution](https://streamsets.com/documentation/controlhub/latest/help/controlhub/UserGuide/DataCollectors/DataCollectors_title.html) SDCs whose config, other than Java Heap size, does not need to be dynamically set.  The <code>sdc.properties</code> file "baked in" to the custom SDC image may include custom settings for properties like <code>production.maxBatchSize</code> and email configuration, but typically would not set a value for <code>sdc.base.http.url</code> as excution SDCs typically run in a "headless" fashion.  
 
### Example 2: Baked-in Configuration plus Ingress

Assuming an Ingress Controller is deployed, one can extend Example 1 (reusing the same custom SDC image with its baked-in <code>sdc.properties</code>) by adding a Service and Ingress to the SDC deployment manifest along with these two entries added to the deployment's <code>env:</code> section:

    - name: SDC_CONF_SDC_BASE_HTTP_URL
      value: https://<your ingress host>[:<your ingress port>]
    - name: SDC_CONF_HTTP_ENABLE_FORWARDED_REQUESTS
      value: true
      
Environment variables, like <code>SDC_CONF_SDC_BASE_HTTP_URL</code> and <code>SDC_CONF_HTTP_ENABLE_FORWARDED_REQUESTS</code>, allow one to dynamically set properties in the deployed SDC's <code>sdc.properties</code> file, based on trimming the <code>SDC_CONF_</code> prefix, lowercasing the name and replacing <code>_</code> with <code>.</code>.  So, for example, the value set in the environment variable <code>SDC_CONF_SDC_BASE_HTTP_URL</code> winds up being set in <code>sdc.properties</code> as the property <code>sdc.base.http.url</code>.  

However (!) this mechanism is not able to set mixed-case properties in <code>sdc.properties</code> like <code>production.maxBatchSize</code>.  If you want to set mixed-case properties then you either have to bake-in the settings in the <code>sdc.properties</code> file packaged in a custom SDC image (as in Example 1), or set the properties in one or more configMaps which are Volume Mounted over the image's <code>sdc.properties</code> file as described in the examples below.

### Example 3: Loading <code>sdc.properties</code> from a ConfigMap

Assuming an Ingress Controller is deployed, one can extend Example 1 (reusing the same custom SDC image with its baked-in <code>sdc.properties</code>) by adding a Service and I