### How to set Java Heap size and other Java Options

Java options, like heap size, can be set at deployment time by setting the <code>SDC_JAVA_OPTS</code> environment variable in the deployment manifest like this:

    env:
    - name: SDC_JAVA_OPTS
      value: "-Xmx4g -Xms4g"
      
See [sdc.yaml](https://github.com/onefoursix/sdc-k8s-deployment-with-custom-config/blob/master/examples/example-1/sdc.yaml)
 
