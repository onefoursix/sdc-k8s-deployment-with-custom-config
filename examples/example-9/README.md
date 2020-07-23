### Ingress

In addition to an SDC Deployment, one can include Service and Ingress resources within a Control Hub-based deployment manifest, assuming an Ingress Controller has already been deployed. This allows end users to reach the SDC UI over HTTP or HTTPS.  An SDC reachable over HTTPS can serve as an [Authoring Data Collector](https://streamsets.com/documentation/controlhub/latest/help/controlhub/UserGuide/DataCollectors/PDesigner_AuthoringSDC.html?hl=authoring%2Cdata%2Ccollectors).

If the SDC's <code>sdc.properties</code> file is packaged within the SDC image, or is mounted with read/write permissions on an appropriate Volume. one can set these two environment variables within the SDC deployment manifest's container <code>env</code> section:

    - name: SDC_CONF_SDC_BASE_HTTP_URL
      value: https://<your ingress host>[:<your ingress port>]
    
    - name: SDC_CONF_HTTP_ENABLE_FORWARDED_REQUESTS
      value: true

If <code>sdc.properties</code> is mounted with read-only permissions, then these two properties may be set in a configMap as shown in [Example 5](https://github.com/onefoursix/sdc-k8s-deployment-with-custom-config/tree/master/examples/example-5) or [Example 6](https://github.com/onefoursix/sdc-k8s-deployment-with-custom-config/tree/master/examples/example-6)

There are [many choices of Ingress Controllers](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/#additional-controllers); for this example I'll deploy [Traefik v1.7](https://github.com/helm/charts/tree/master/stable/traefik) as AKS as a <code>LoadBalancer</code> which is an option when deploying an Ingress Controller in public cloud-based Kubernetes Services (see the post [here](https://medium.com/google-cloud/kubernetes-nodeport-vs-loadbalancer-vs-ingress-when-should-i-use-what-922f010849e0) for background).

Assuming your Ingress Controller is deployed as a LoadBalancer, the Ingress Controller Service will be assigned an external IP.  Here is what I see in my environment after deploying Traefik:

    $ kubectl get svc
    NAME                      TYPE           CLUSTER-IP    EXTERNAL-IP    PORT(S) 
    traefik-ingress-service   LoadBalancer   10.0.254.51   20.42.150.93   80:32201/TCP,443:32339/TCP,8080:31270/TCP

My Ingress Controller was assigned the external IP <code>20.42.150.93</code>.

I'll map that IP address to the hostname <code>aks.onefoursix.com</code> by adding an A record to my DNS (I control the <code>onefoursix.com</code> domain).

I saved a wildcard cert and key for that domain in a Secret that Traefik uses:

    $ kubectl create secret generic traefik-cert \
      --from-file=tls.crt \
      --from-file=tls.key

Define a Service and Ingress for the SDC Deployment. See [sdc.yaml](https://github.com/onefoursix/sdc-k8s-deployment-with-custom-config/blob/master/examples/example-9/sdc.yaml) for an example.

#### Routing to Multiple SDCs using a single Ingress Controller

One can use a single Ingress Controller to route traffic to multiple SDCs.  The Deployment for each SDC must be defined with only a single replica, and each Deployment must be exposed by a Service on a unique NodePort.  An Ingress resource can use routing rules to direct traffic to the appropriate SDC Service.

Two common strategies for Routing Rules are <code>Host-based</code> or <code>Path-based</code>.

##### Host-based Routing Example

Example manifests for three Authoring SDCs that use <code>Host-based</code> routing are in the directory [here](https://github.com/onefoursix/sdc-k8s-deployment-with-custom-config/tree/master/examples/example-9/host-based-routing).

Each of the three SDCs deployments uses a different hostname for its base URL. For example, sdc1 has this value: 

    - name: SDC_CONF_SDC_BASE_HTTP_URL
      value: https://sdc1.onefoursix.com

sdc2 has this value: 

    - name: SDC_CONF_SDC_BASE_HTTP_URL
      value: https://sdc2.onefoursix.com

sdc3 has this value:

    - name: SDC_CONF_SDC_BASE_HTTP_URL
      value: https://sdc3.onefoursix.com
      

Each SDC has its own Service that specifies a unique NodePort and an Ingress with a host rule.

All three of those DNS names are mapped to the same IP which is the external IP of the Load Balancer (which is also the same IP <code>aks.onefoursix.com</code> is mapped to).

So all traffic for all three SDCs enters the cluster on the same IP.


Inspect the Service and Ingress resources in [sdc1.yaml](https://github.com/onefoursix/sdc-k8s-deployment-with-custom-config/blob/master/examples/example-9/host-based-routing/sdc1.yaml) and note the NodePort in the Service and the Host rule in the Ingress; compare those with [sdc2.yaml](https://github.com/onefoursix/sdc-k8s-deployment-with-custom-config/blob/master/examples/example-9/host-based-routing/sdc2.yaml) and [sdc3.yaml](https://github.com/onefoursix/sdc-k8s-deployment-with-custom-config/blob/master/examples/example-9/host-based-routing/sdc3.yaml) 


##### Path-based Routing Example

Under Construction







