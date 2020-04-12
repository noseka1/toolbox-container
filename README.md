# OpenShift Toolbox Container Image

Build this container image on a RHEL 8 machine that is subscribed to required YUM repositories:

```
$ podman build --tag openshift-toolbox .
```

Upload the built image to a container registry:

```
$ podman push openshift-toolbox <registry_path>/openshift-toolbox
```

Deploy the *openshift-toolbox* on the cluster:

```
$ oc create deployment openshift-toolbox --image <registry_path>/openshift-toolbox
```

Find out the pod name from the output of:

```
$ oc get pod
```

Connect to the *openshift-toolbox* container:

```
$ oc rsh openshift-toolbox-<hash>
```

## Run as privileged container

```
$ oc create serviceaccount openshift-toolbox
```
```
$ oc adm policy add-scc-to-user privileged --serviceaccount openshift-toolbox
```
```
$ oc patch deployment openshift-toolbox \
    --type json \
    --patch '[{"op": "add", "path": "/spec/template/spec/serviceAccountName", "value": "openshift-toolbox"}]'
```

```
$ oc patch deployment openshift-toolbox \
    --type json \
    --patch '[{"op": "add", "path": "/spec/template/spec/containers/0/securityContext", "value": { "privileged": true }}]'
```

## Provide cluster-admin access

```
$ oc adm policy add-cluster-role-to-user cluster-admin --serviceaccount openshift-toolbox
```

## Attach a persistent volume

```
$ oc set volume \
    deployment/openshift-toolbox \
    --add \
    --claim-name openshift-toolbox \
    --claim-size 50G \
    --mount-path /home/toolbox
```

## Run on a specific node

```
$ oc patch deployment openshift-toolbox \
    --type json \
    --patch '[{"op": "add", "path": "/spec/template/spec/nodeName", "value": "ip-10-0-143-77.us-west-2.compute.internal"}]'
```

## Example workloads

Run Apache server:

```
$ apachectl -D FOREGROUND
```

Run Python SimpleHTTPServer:

```
$ python3 -m http.server
```

Run httpbin:

```
$ gunicorn-3 --bind 0.0.0.0:80 --access-logfile - httpbin:app
```

```
$ openssl req -newkey rsa:2048 -nodes -keyout httpbin.key -x509 -out httpbin.crt
```

```
$ gunicorn-3 --bind 0.0.0.0:443 --access-logfile - --keyfile httpbin.key --certfile httpbin.crt  httpbin:app
```
