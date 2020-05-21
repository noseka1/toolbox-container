# OpenShift Toolbox Container Image

OpenShift Toolbox is a container image that includes popular tools for building and troubleshooting containerized applications. It can also be used for troubleshooting issues with OpenShift/Kubernetes clusters.

[Building OpenShift Toolbox](#building-openshift-toolbox)

## Building OpenShift Toolbox

OpenShift Toolbox comes in two sizes: basic and full. See the Dockerfile for the list of included tools in each of the sizes.

Build the basic container image:

```
$ podman build \
  --build-arg OPENSHIFT_TOOLBOX_COMMIT=$(git rev-parse HEAD) \
  --target basic \
  --tag openshift-toolbox:basic \
  .
```

Alternatively, build the full version of the container image:

```
$ podman build \
  --build-arg OPENSHIFT_TOOLBOX_COMMIT=$(git rev-parse HEAD) \
  --target full \
  --tag openshift-toolbox:full \
  .
```

Upload the built image to a container registry:

```
$ podman push openshift-toolbox:basic <registry_path>/openshift-toolbox:basic
```

## Deploying openshift-toolbox

Deploy the *openshift-toolbox* on the cluster:

```
$ oc create deployment openshift-toolbox --image <registry_path>/openshift-toolbox:basic
```

Find out the pod name from the output of:

```
$ oc get pod
```

Connect to the *openshift-toolbox* container:

```
$ oc rsh openshift-toolbox-<hash>
```

## Configuring openshift-toolbox

### Run as privileged container

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

### Share namespaces with the underlying node

```
$ oc patch deployment openshift-toolbox \
    --type json \
    --patch '[{"op": "replace", "path": "/spec/template/spec/hostNetwork", "value": true}]'
```

```
$ oc patch deployment openshift-toolbox \
    --type json \
    --patch '[{"op": "replace", "path": "/spec/template/spec/hostPID", "value": true}]'
```

```
$ oc patch deployment openshift-toolbox \
    --type json \
    --patch '[{"op": "replace", "path": "/spec/template/spec/hostIPC", "value": true}]'
```

### Run on a specific node

```
$ oc patch deployment openshift-toolbox \
    --type json \
    --patch '[{"op": "add", "path": "/spec/template/spec/nodeName", "value": "ip-10-0-143-77.us-west-2.compute.internal"}]'
```

### Mount the root of the underlying node on /rootfs

```
$ oc set volume \
    deployment/openshift-toolbox \
    --add \
    --name rootfs \
    --type hostPath \
    --path / \
    --mount-path /rootfs
```

### Allow cluster-admin access to OpenShift

```
$ oc adm policy add-cluster-role-to-user cluster-admin --serviceaccount openshift-toolbox
```

### Attach a persistent volume

```
$ oc set volume \
    deployment/openshift-toolbox \
    --add \
    --type persistentVolumeClaim \
    --claim-name openshift-toolbox \
    --claim-size 50G \
    --mount-path /home/toolbox
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
