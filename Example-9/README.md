### Example 9: Ingress

Assuming an Ingress Controller is deployed, one can extend Example 1 (reusing the same custom SDC image with its baked-in <code>sdc.properties</code>) by adding a Service and Ingress to the SDC deployment manifest along with these two additional environment variables added to the deployment:
  
    - name: SDC_CONF_SDC_BASE_HTTP_URL
      value: https://<your ingress host>[:<your ingress port>]
    - name: SDC_CONF_HTTP_ENABLE_FORWARDED_REQUESTS
      value: true

One could bake these properties into a custom SDC image, as in Example 1, but that would limit the image's usefulness; typically, an SDC Base URL is set at deployment time.

See [sdc.yaml]() for the full deployment manifest.

