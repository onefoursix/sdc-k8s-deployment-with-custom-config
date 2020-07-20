## sdc-k8s-deployment-with-custom-config

This project provides examples and guidance for deploying custom configurations of [StreamSets Data Collector](https://streamsets.com/products/dataops-platform/data-collector) (SDC) on Kubernetes using [Control Hub](https://streamsets.com/products/dataops-platform/control-hub).  

* [Example #1: How to set Java Heap Size and other Java Options]()

* [Example #2: Baked-in Configuration]()

* [Example #3: Loading Stage Libs from a Persistent Volume]()

* [Example #4: Loading <code>sdc.properties</code> from a ConfigMap]()

* [Example #5: Loading static and dynamic <code>sdc.properties</code> from separate ConfigMaps]()

* [Example #6: Loading <code>credential-stores.properties</code> from a Secret]()

* [Example #7: Loading resources from a Volume]()

* [Example #8: Loading keystores and truststores from a Secret]()

* [Example #9: Ingress]()

* [Example #10: A complete example]()


***
##### A note about Environment Variables in SDC deployment manifests
Environment variables with the prefix "SDC_CONF_", like <code>SDC_CONF_SDC_BASE_HTTP_URL</code>, allow one to dynamically set properties in the deployed SDC's <code>sdc.properties</code> file. These environment variables are mapped to SDC properties by trimming the "SDC_CONF_" prefix, lowercasing the name and replacing "_" with ".". So, for example, the value set in the environment variable <code>SDC_CONF_SDC_BASE_HTTP_URL</code> will be set in <code>sdc.properties</code> as the property <code>sdc.base.http.url</code>.

However, this mechanism is not able to set mixed-case properties in <code>sdc.properties</code> like <code>production.maxBatchSize</code>. If you want to set mixed-case properties then you either have to bake-in the settings in the sdc.properties file packaged in a custom SDC image (as in Example 1), or set the properties in a Volume mounted over the image's sdc.properties file as shown in Examples 4 and 5.

It's also worth noting that values for environment variables with the prefix "SDC_CONF_" are written to the sdc.properties file by the SDC container's <code>docker-entrypoint.sh</code> script which forces the SDC container to have read/write access to the sdc.properties file, which may not be the case if sdc.properties is mounted with read-only access.

*Best practice is to mount* <code>sdc.properties</code> *from a Volume and to avoid using* <code>SDC_CONF\_</code> *environment variables.*


