### Ingress

In addition to an SDC Deployment, one can include Service and Ingress resources within a Control Hub-based deployment manifest, assuming an Ingress Controller has already been deployed. This allows end users to reach the SDC UI over HTTP or HTTPS.  An SDC reachable over HTTPS can serve as an [Authoring Data Collector](https://streamsets.com/documentation/controlhub/latest/help/controlhub/UserGuide/DataCollectors/PDesigner_AuthoringSDC.html?hl=authoring%2Cdata%2Ccollectors).

If the SDC's <code>sdc.properties</code> file is packaged within the SDC image, or is mounted with read/write permissions on an appropriate Volume. one can set these two environment variables within the SDC deployment manifest's container <code>env</code> section:

    - name: SDC_CONF_SDC_BASE_HTTP_URL
      value: https://<your ingress host>[:<your ingress port>]
    
    - name: SDC_CONF_HTTP_ENABLE_FORWARDED_REQUESTS
      value: true

If <code>sdc.properties</code> is mounted with read-only permissions, these two properties may be set in a configMap as shown in [Example 5](https://github.com/onefoursix/sdc-k8s-deployment-with-custom-config/tree/master/examples/example-5) or [Example 6](https://github.com/onefoursix/sdc-k8s-deployment-with-custom-config/tree/master/examples/example-6)

See [sdc.yaml](https://github.com/onefoursix/sdc-k8s-deployment-with-custom-config/blob/master/examples/example-9/sdc.yaml) for an example manifest that includes an SDC Deployment, Service and Ingress.

One can use a single Ingress Controller to route traffic to multiple SDCs, using Ingress routing rules. Routing rules can be <code>Host-based</code> or <code>Path-based</code>. 

#### Host-based Routing Example

In this example, three SDC deployments each use a different hostname as their base URL. 

For example, sdc1 has this value: 

    - name: SDC_CONF_SDC_BASE_HTTP_URL
      value: https://sdc1.onefoursix.com

sdc2 has this value: 

    - name: SDC_CONF_SDC_BASE_HTTP_URL
      value: https://sdc2.onefoursix.com

sdc3 has this value:

    - name: SDC_CONF_SDC_BASE_HTTP_URL
      value: https://sdc3.onefoursix.com
      
All three of those host names are added as DNS Aliases that all point to the same address: the external IP of the Load Balancer.

Each SDC has its own Service that specifies a unique NodePort and an Ingress with a host rule. Here is the Ingress for <code>sdc1</code> with a rule that ensures that requests with the hostname <code>sdc1.onefoursix.com</code> are routed to the <code>sdc1</code> Service:


    apiVersion: extensions/v1beta1
      kind: Ingress
      metadata:
        name: sdc1
        annotations:
          kubernetes.io/ingress.class: nginx
      spec:
        tls:
        - hosts:
          - sdc1.onefoursix.com
          secretName: streamsets-tls
        rules:
        - host: sdc1.onefoursix.com
          http:
            paths:
            - path: /
              backend:
                serviceName: sdc1
                servicePort: 18635
                
                
Example manifests for three SDCs that use <code>Host-based</code> routing are in the directory [here](https://github.com/onefoursix/sdc-k8s-deployment-with-custom-config/tree/master/examples/example-9/host-based-routing).


#### Path-based Routing Example

In this example, the three SDCs share a common base URL, but have unique paths, like this:


sdc1 has this value: 
    
    - name: SDC_CONF_SDC_BASE_HTTP_URL
      value: https://saturn.onefoursix.com/sdc1/
    
sdc2 has this value: 
    
    - name: SDC_CONF_SDC_BASE_HTTP_URL
      value: https://saturn.onefoursix.com/sdc2/
    
sdc3 has this value:
    
    - name: SDC_CONF_SDC_BASE_HTTP_URL
      value: https://saturn.onefoursix.com/sdc3/


Ingress is defined using a regular expression to match the request path along with a [<code>rewrite-target</code> annotation](https://kubernetes.github.io/ingress-nginx/examples/rewrite/#rewrite).

Here is an example of Ingress for <code>sdc1</code>:

    - apiVersion: extensions/v1beta1
      kind: Ingress
      metadata:
        name: sdc1
        namespace: ns1
        annotations:
          kubernetes.io/ingress.class: nginx
          nginx.ingress.kubernetes.io/ssl-redirect: \"false\"
          nginx.ingress.kubernetes.io/rewrite-target: /$2
      spec:
        tls:
        - hosts:
          - saturn.onefoursix.com
          secretName: streamsets-tls
        rules:
        - host: saturn.onefoursix.com
          http:
            paths:
            - path: /sdc1(/|$)(.*)
              backend:
                serviceName: sdc1
                servicePort: 18635


Here is an example of an SDC UI reached using path-based routing:

<img src="images/path-based-routing.png" alt="path-based-routing" width="600"/>

Example manifests for three SDCs that use <code>path-based</code> routing are in the directory [here](https://github.com/onefoursix/sdc-k8s-deployment-with-custom-config/tree/master/examples/example-9/path-based-routing).
