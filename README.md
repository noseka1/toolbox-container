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
