### Ingress

In addition to an SDC Deployment, one can include Service and Ingress resources within a Control Hub-based deployment manifest, assuming an Ingress Controller has already been deployed. This allows end users to reach the SDC UI over HTTP or HTTPS.  An SDC reachable over HTTPS can serve as an [Authoring Data Collector](https://streamsets.com/documentation/controlhub/latest/help/controlhub/UserGuide/DataCollectors/PDesigner_AuthoringSDC.html?hl=authoring%2Cdata%2Ccollectors).

If the SDC's <code>sdc.properties</code> file is packaged within the SDC image, or is mounted with read/write permissions on an appropriate Volume. one can set these two environment variables within the SDC deployment manifest's container <code>env</code> section:

    - name: SDC_CONF_SDC_BASE_HTTP_URL
      value: https://<your ingress host>[:<your ingress port>]
    
    - name: SDC_CONF_HTTP_ENABLE_FORWARDED_REQUESTS
      value: true

If <code>sdc.properties</code> is mounted with read-only permissions, then these two properties may be set in a configMap as shown in [Example 5](https://github.com/onefoursix/sdc-k8s-deployment-with-custom-config/tree/master/examples/example-5) or [Example 6](https://github.com/onefoursix/sdc-k8s-deployment-with-custom-config/tree/master/examples/example-6)

See [sdc.yaml]() for the full deployment manifest.

