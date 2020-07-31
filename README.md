# OpenShift Toolbox Container Image

OpenShift Toolbox is a container image that includes popular tools for building and troubleshooting containerized applications. It can also be used for troubleshooting issues with OpenShift/Kubernetes clusters.

Before the image can be used, it must be built. Refer to [Building OpenShift Toolbox](#building-openshift-toolbox) section for instructions on how to build the image.

For more information on how to use the image, refer to sections:

 * [Using OpenShift Toolbox for development on Windows](#using-openshift-toolbox-for-development-on-windows)
 * [Using OpenShift Toolbox for development on Linux](#using-openshift-toolbox-for-development-on-linux)
 * [Deploying OpenShift Toolbox to OpenShift cluster](#deploying-openshift-toolbox-to-openshift-cluster)

## Building OpenShift Toolbox Container Image

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
## Using OpenShift Toolbox for development on Windows

You may encounter situations where you were handed over a corporate machine that runs Windows. Also, you were given rather restricted permissions for what you can run on this machine. If the Windows machine allows you to run Docker, you can use OpenShift Toolbox to spin up a development environment.

In the following code examples, replace the username `anosek` with your own username.

First, create a persistent volume that will be used to back your home directory:

```
$ docker volume create toolbox-home-anosek
```

Pull and start the toolbox container:

```
$ docker run --detach --network host --name toolbox --mount source=toolbox-home-anosek,target=/home/anosek <registry_path>/openshift-toolbox:full 
```

Start a terminal session within the container:

```
$ docker exec -ti --detach-keys ctrl-@,@ toolbox /bin/bash
```

The above command remaps the detach keys to ctrl-@. The default ctrl-p key combination conflicts with the terminal controls.

Within the container, you can create your user and switch to it:

```
$ adduser anosek -G wheel
$ su - anosek
```

Now you are all set. You can run `tmux` within the container to obtain additional shell windows. Alternatively, you can run the `docker exec -ti ...` command as you did before to start an additional shell session.

If you restart the Windows machine, the container will stop. You can start it by issuing:

```
$ docker start toolbox
```

Note that if you delete and recreate the container, you will need to issue the `adduser ...` command again. The user information is stored in the `/etc` directory which is not backed by a volume.

## Using OpenShift Toolbox for development on Linux

Previous section showed how to create a development container on Windows. This section shows the same use case but this time using Linux. Note that no root privileges are required to run the commands in this section.

In the following code examples, replace the username `anosek` with your own username.

```
$ podman volume create toolbox-home-anosek
```

```
$ podman run --detach --name toolbox --mount type=volume,src=toolbox-home-anosek,target=/home/anosek <registry_path>/openshift-toolbox:full 
```

```
$ podman exec -ti --detach-keys ctrl-@,@ toolbox /bin/bash
```

```
$ adduser anosek -G wheel
$ shopt -s dotglob
$ cp -a /etc/skel/* /home/anosek
$ shopt -u dotglob
$ chown -R anosek.anosek ~anosek
$ su - anosek
```

If you restart the Linux machine, the container will stop. You can start it by issuing:

```
$ podman start toolbox
```

## Deploying OpenShift Toolbox to OpenShift cluster

### Deploying openshift-toolbox

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

### Configuring openshift-toolbox

#### Running as privileged container

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
#### Attaching a persistent volume

```
$ oc set volume \
    deployment/openshift-toolbox \
    --add \
    --type persistentVolumeClaim \
    --claim-name openshift-toolbox \
    --claim-size 50G \
    --mount-path /home/toolbox
```

#### Allowing cluster-admin access to OpenShift from within the toolbox

```
$ oc adm policy add-cluster-role-to-user cluster-admin --serviceaccount openshift-toolbox
```

#### Scheduling the toolbox to run on a specific node

```
$ oc patch deployment openshift-toolbox \
    --type json \
    --patch '[{"op": "add", "path": "/spec/template/spec/nodeName", "value": "ip-10-0-143-77.us-west-2.compute.internal"}]'
```
#### Enabling access to the underlying node by sharing namespaces

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

#### Mounting the root of the underlying node on /rootfs

```
$ oc set volume \
    deployment/openshift-toolbox \
    --add \
    --name rootfs \
    --type hostPath \
    --path / \
    --mount-path /rootfs
```

## Example workloads

### Run Apache server

```
$ apachectl -D FOREGROUND
```

### Run Python SimpleHTTPServer

```
$ python3 -m http.server
```

### Run httpbin

Serve plain HTTP:

```
$ gunicorn-3 --bind 0.0.0.0:80 --access-logfile - httpbin:app
```

Serve HTTPS:

```
$ openssl req -newkey rsa:2048 -nodes -keyout httpbin.key -x509 -out httpbin.crt
```

```
$ gunicorn-3 --bind 0.0.0.0:443 --access-logfile - --keyfile httpbin.key --certfile httpbin.crt  httpbin:app
```

### Run NFS server

```
$ dnf install nfs-utils -y
```

```
$ /usr/sbin/rpcbind -w
```

```
$ mount -t nfsd nfds /proc/fs/nfsd
```
Disable NFSv2 and enable NFSv3:

```
$ /usr/sbin/rpc.mountd -N 2 -V 3
```

```
$ /usr/sbin/rpc.nfsd -G 10 -N 2 -V 3
```

```
$ /usr/sbin/rpc.statd --no-notify
```
Configure local directories to export through NFS:

```
$ echo '/home/toolbox *(rw,async,no_root_squash)' > /etc/exports.d/toolbox.exports
```
```
$ exportfs -a
```

Check that the exports are available:

```
$ showmount -e
Export list for openshift-toolbox-7c7dc58758-pwkfw:
/home/toolbox *
```
