# Deploying toolbox-container on OpenShift using Kustomize

Modify [kustomization.yaml](kustomization.yaml) to your liking. You can uncomment many of the optional settings there to activate them.

Deploy the toolbox-container container using:

```
$ oc oc apply --kustomize .
```
