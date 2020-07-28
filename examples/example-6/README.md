### Loading static and dynamic <code>sdc.properties</code> from separate ConfigMaps

This example splits the monolithic <code>sdc.properties</code> file used in Example 5 into two configMaps: one for properties loaded from a file that rarely if ever change (and that can be reused across multiple deployments), and one for dynamic properties targeted for a specific deployment that can be edited inline within the manifest.

Similar to Example 5, start by copying a clean <code>sdc.properties</code> file to a local working directory.

Set values for properties that will rarely change, and comment out or delete the small number of properties that need to be set specifically for a deployment, leaving in place the properties to be reused across deployments.  For example, I'll set and include these two properties in the file:

    http.realm.file.permission.check=false
    http.enable.forwarded.requests=true
    
But I will comment out these two properties which I want to set specifically for a given deployment:

    # sdc.base.http.url=http://<hostname>:<port>
    # production.maxBatchSize=1000
    
One final setting:  append the filename <code>sdc-dynamic.properties</code> to the <code>config.includes</code> property in the <code>sdc.properties</code> file like this:

    config.includes=dpm.properties,vault.properties,credential-stores.properties,sdc-dynamic.properties

That setting will load the dynamic properties described below.

Save the <code>sdc.properties</code> file in a configMap named <code>sdc-static-properties</code> by executing the command:

<code>$ kubectl create configmap sdc-static-properties --from-file=sdc.properties</code>

Once again, the configMap <code>sdc-static-properties</code> can be reused across multiple deployments.

Next, create a manifest named <code>sdc-dynamic-properties.yaml</code> that will contain only properties specific to a given deployment,  For example, my <code>sdc-dynamic-properties.yaml</code> contains  these two properties:

    apiVersion: v1
    kind: ConfigMap
    metadata:
      name: sdc-dynamic-properties
    data:
      sdc-dynamic.properties: |
        sdc.base.http.url=https://portland.onefoursix.com
        production.maxBatchSize=20000
    
Create the configMap by executing the command:

<code>$ kubectl apply -f sdc-dynamic-properties.yaml</code>

Add two Volumes to your SDC deployment manifest like this:

    volumes:
    - name: sdc-static-properties
      configMap:
        name: sdc-static-properties
        items:
        - key: sdc.properties
          path: sdc.properties
    - name: sdc-dynamic-properties
      configMap:
        name: sdc-dynamic-properties
        items:
        - key: sdc-dynamic.properties
          path: sdc-dynamic.properties
        
And add two Volume Mounts to the SDC container, the first to overwrite the <code>sdc.properties</code> file and the second to add the referenced <code>sdc-dynamic.properties</code> file

    volumeMounts:
    - name: sdc-static-properties
      mountPath: /etc/sdc/sdc.properties
      subPath: sdc.properties
    - name: sdc-dynamic-properties
      mountPath: /etc/sdc/sdc-dynamic.properties
      subPath: sdc-dynamic.properties

 
