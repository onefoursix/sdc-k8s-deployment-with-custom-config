### Loading keystores and truststores from Secrets

This example showing how to load a keystore and a truststore from a single Secret.

Start by creating a Secret that contains two files loaded from disk:

    $ kubectl create secret generic my-secrets \
       --from-file=my-truststore.jks \
       --from-file=my-keystore.jks 
    
In your SDC deployment manifest, create a Volume for the Secret with keys for both files:

    volumes:
    - name: my-secrets
      secret:
        secretName: my-secrets
        items:
        - key: my-keystore.jks
          path: my-keystore.jks
        - key: my-truststore.jks
          path: my-truststore.jks


In the SDC container spec, add two VolumeMounts that load both files from the Secret:

    volumeMounts:
    - name: my-secrets
      mountPath: /etc/sdc/my-keystore.jks
      subPath: my-keystore.jks
    - name: my-secrets
      mountPath: /etc/sdc/my-truststore.jks
      subPath: my-truststore.jks

Once the SDC container starts, <code>exec</code> into the container to see the two files loaded from the Secret:

    $ kubectl exec -it auth-sdc-84bdc7d58d-w8gt6 -- sh
    / $ ls -l /etc/sdc | grep "my-"
    -rw-r--r--    1 root     root            19 Jul 13 23:41 my-keystore.jks
    -rw-r--r--    1 root     root            21 Jul 13 23:41 my-truststore.jks

