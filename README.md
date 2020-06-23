## sdc-k8s-deployment-with-custom-config

This project provides examples and guidance for deploying custom configurations of [StreamSets Data Collector](https://streamsets.com/products/dataops-platform/data-collector) (SDC) on Kubernetes using [Control Hub](https://streamsets.com/products/dataops-platform/control-hub).  Each example provides an <code>sdc.yaml</code> that shows the relevant configuration.

### Example 1: Baked-in Configuration
 
This approach involves creating a customized <code>sdc.properties</code> file and packaging that file in with your own SDC image, similar to the example [here](https://github.com/streamsets/control-agent-quickstart/tree/master/custom-datacollector-docker-image).  See the provided <code>Dockerfile</code> and <code>build.sh</code> artifacts in the [Example 1](https://github.com/onefoursix/sdc-k8s-deployment-with-custom-config/tree/master/Example-1) directory.  

This approach is most suitable for [execution](https://streamsets.com/documentation/controlhub/latest/help/controlhub/UserGuide/DataCollectors/DataCollectors_title.html) SDCs whose config, other than Java Heap size, does not need to be dynamically set.  The <code>sdc.properties</code> file "baked in" to the custom SDC image may include custom settings for properties like <code>production.maxBatchSize</code> and email configuration, but typically would not set a value for <code>sdc.base.http.url</code>, as execution SDCs typically run in a "headless" fashion. 

Make sure to set <code>http.realm.file.permission.check=false</code> to avoid permission issues.
 
### Example 2: Baked-in Configuration plus Ingress

Assuming an Ingress Controller is deployed, one can extend Example 1 (reusing the same custom SDC image with its baked-in <code>sdc.properties</code>) by adding a Service and Ingress to the SDC deployment manifest along with these two entries added to the deployment's <code>env:</code> section:

    - name: SDC_CONF_SDC_BASE_HTTP_URL
      value: https://<your ingress host>[:<your ingress port>]
    - name: SDC_CONF_HTTP_ENABLE_FORWARDED_REQUESTS
      value: true
      
One could bake these properties into a custom SDC image, as in Example 1, but that would limit the image's usefulness; typically, an SDC Base URL is set at deployment time.

Environment variables, like <code>SDC_CONF_SDC_BASE_HTTP_URL</code> and <code>SDC_CONF_HTTP_ENABLE_FORWARDED_REQUESTS</code>, allow one to dynamically set properties in the deployed SDC's <code>sdc.properties</code> file, based on trimming the <code>SDC_CONF_</code> prefix, lowercasing the name and replacing <code>_</code> with <code>.</code>.  So, for example, the value set in the environment variable <code>SDC_CONF_SDC_BASE_HTTP_URL</code> winds up being set in <code>sdc.properties</code> as the property <code>sdc.base.http.url</code>.  

However (!) this mechanism is not able to set mixed-case properties in <code>sdc.properties</code> like <code>production.maxBatchSize</code>.  If you want to set mixed-case properties then you either have to bake-in the settings in the <code>sdc.properties</code> file packaged in a custom SDC image (as in Example 1), or set the properties in a configMap Volume Mounted over the image's <code>sdc.properties</code> file as described below.

### Example 3: Loading <code>sdc.properties</code> from a ConfigMap

An approach that offers greater flexibility than the examples above is to dynamically load an <code>sdc.properties</code> file at deployment time. One way to do that is to edit and store an <code>sdc.properties</code> file in a configMap and to Volume Mount the configMap into the SDC container, overwriting the default <code>sdc.properties</code> file included with the image.

When using this technique, the configMap's representation of <code>sdc.properties</code> will be read-only, so one can't use any <code>SDC_CONF_</code> prefixed environment variables in the SDC deployment; all custom properties values for properties defined in <code>sdc.properties</code> need to be set in the  configMap (though one can still set <code>SDC_JAVA_OPTS</code> in the environment as that is a "pure" environment variable used by SDC).  

This example uses one monolithic <code>sdc.properties</code> file stored in a single configMap.  Start by copying a clean <code>sdc.properties</code> file to a local working directory. Set all property values you want for a given deployment.  For this example I will set these properties within the file (along with all the other properties already in the file):

    sdc.base.http.url=https://sequoia.onefoursix.com
    http.enable.forwarded.requests=true
    http.realm.file.permission.check=false  # set this to avoid permission issues
    production.maxBatchSize=20000 
    
Save the edited <code>sdc.properties</code> file in a configMap named <code>sdc-properties</code> by executing a command like this:

    $ kubectl create configmap sdc-properties --from-file=sdc.properties

(Control Hub can't yet include a configMap in an SDC deployment, so this configMap needs to be created outside of Control Hub).

Add the configMap as a Volume in your SDC deployment manifest like this:

    volumes:
    - name: sdc-properties
      configMap:
        name: sdc-properties
        
And add a Volume Mount to the SDC container, to overwrite the <code>sdc.properties</code> file:

    volumeMounts:
    - name: sdc-properties
      mountPath: /etc/sdc/sdc.properties
      subPath: sdc.properties




