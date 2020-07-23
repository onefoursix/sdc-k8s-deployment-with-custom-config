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


See [sdc.yaml]() for the full deployment manifest.

