### Loading <code>sdc.properties</code> from a ConfigMap

An approach that offers greater flexibility than "baking-in" the <code>sdc.properties</code> file is to dynamically mount an <code>sdc.properties</code> file at deployment time. One way to do that is to store an <code>sdc.properties</code> file in a configMap and to Volume Mount the configMap into the SDC container, overwriting the default <code>sdc.properties</code> file included with the image.

The configMap's representation of <code>sdc.properties</code> will be read-only, so one can't use any <code>SDC_CONF_</code> prefixed environment variables in the SDC deployment; all custom property values for properties defined in <code>sdc.properties</code> need to be set in the  configMap (though one can still set <code>SDC_JAVA_OPTS</code> in the environment as that is a "pure" environment variable used by SDC).  

This example uses one monolithic <code>sdc.properties</code> file stored in a single configMap (see [Example 5]() for a more modular approach).

Start by copying a clean <code>sdc.properties</code> file to a local working directory. Set all property values you want for a given deployment.  For this example I will set custom values for these properties within the file (alongside all the other properties already in the file):

    sdc.base.http.url=https://sequoia.onefoursix.com
    http.enable.forwarded.requests=true
    http.realm.file.permission.check=false  # set this to avoid permission issues
    production.maxBatchSize=20000 
    
Save the edited <code>sdc.properties</code> file in a configMap named <code>sdc-properties</code> by executing a command like this:

    $ kubectl create configmap sdc-properties --from-file=sdc.properties

This configMap needs to be created in advance, outside of Control Hub, prior to starting the SDC deployment.

Add the configMap as a Volume in your SDC deployment manifest like this:

    volumes:
    - name: sdc-properties
      configMap:
        name: sdc-properties
        
Add a Volume Mount to the SDC container, to overwrite the <code>sdc.properties</code> file:

    volumeMounts:
    - name: sdc-properties
      mountPath: /etc/sdc/sdc.properties
      subPath: sdc.properties

See [sdc.yaml](https://github.com/onefoursix/sdc-k8s-deployment-with-custom-config/blob/master/examples/example-5/sdc.yaml) for the full manifest.


