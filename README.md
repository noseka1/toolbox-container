# Toolbox Container Image

Toolbox Container Image is a container image that includes popular tools for troubleshooting containerized applications or issues with OpenShift/Kubernetes clusters. It can also be used for creating a containerized development environment.

Before the image can be used, it must be built. Refer to [Building Toolbox Container](#building-toolbox-container-image) section for instructions on how to build the image.

For more information on how to use the image, refer to sections:

 * [Using Toolbox Container for development](#using-toolbox-container-for-development)
 * [Using Toolbox Container for troubleshooting cluster nodes](#using-toolbox-container-for-troubleshooting-cluster-nodes)
 * [Using Toolbox Container for troubleshooting pods](#using-toolbox-container-for-troubleshooting-pods)
 * [Deploying Toolbox Container to OpenShift cluster](#deploying-toolbox-container-to-openshift-cluster)

## Building Toolbox Container image

OpenShift Toolbox comes in two sizes: basic and full. See the Dockerfile for the list of included tools in each of the sizes.

Export GITHUB_TOKEN variable. Replace the <githubtoken> placeholder with your GitHub authentication token:

```
$ export GITHUB_TOKEN=<githubtoken>
```

Build the basic container image:

```
$ podman build \
  --secret id=GITHUB_TOKEN \
  --build-arg TOOLBOX_CONTAINER_COMMIT=$(git rev-parse HEAD) \
  --target basic \
  --tag toolbox-container:basic \
  .
```

Alternatively, build the full version of the container image:

```
$ podman build \
  --secret id=GITHUB_TOKEN \
  --build-arg TOOLBOX_CONTAINER_COMMIT=$(git rev-parse HEAD) \
  --target full \
  --tag toolbox-container:full \
  .
```

Upload the built image to a container registry (replace the target regitry with your location):

```
$ podman push toolbox-container:basic quay.io/noseka1/toolbox-container:basic
```

## Using Toolbox Container for development

### Starting Toolbox Container on Windows

You may encounter situations where you were handed over a corporate machine that runs Windows. Also, you were given rather restricted permissions for what you can run on this machine. If the Windows machine allows you to run Docker, you can use Toolbox Container to spin up a development environment.

In the following code examples, replace the username `anosek` with your own username.

First, create a persistent volume that will be used to back your home directory:

```
$ docker volume create toolbox-home-anosek
```

Pull and start the toolbox container:

```
$ docker run \
    --detach \
    --network host \
    --name toolbox \
    --mount source=toolbox-home-anosek,target=/home/anosek \
    quay.io/noseka1/toolbox-container:full
```

### Starting Toolbox Container on Linux

Previous section showed how to create a development container on Windows. This section shows the same use case but this time using Linux. Note that no root privileges on the podman host machine are required to run the commands in this section.

In the following code examples, replace the username `anosek` with your own username.

```
$ podman volume create toolbox-home-anosek
```

```
$ podman run \
    --detach
    --name toolbox
    --mount type=volume,src=toolbox-home-anosek,target=/home/anosek
    quay.io/noseka1/toolbox-container:full
```

### Initializing Toolbox Container for development

Start a terminal session within the container:

```
$ podman exec -ti --detach-keys ctrl-@,@ toolbox /bin/bash
```

The above command remaps the detach keys to ctrl-@. The default ctrl-p key combination conflicts with the terminal controls.

Create a user with an empty home directory:

```
$ adduser anosek -G wheel --shell /bin/zsh
```

Copy the initial shell configuration:

```
$ rsync -av --chown anosek:anosek /etc/skel/ /home/anosek
```

Optionally, copy the sample configuration from the toolbox user:

```
$ rsync -av --chown anosek:anosek /home/toolbox/ /home/anosek
```

Continue working as the new user:

```
$ su - anosek
```

You are all set now. You can run `tmux` within the container to obtain additional shell windows. Alternatively, you can run the `podman exec -ti ...` command as you did before to start an additional shell session.

If you restart the podman host machine, the container will stop. You can start it by issuing:

```
$ podman start toolbox
```

### Updating Toolbox Container image

Stop the toolbox container if it is running:

```
$ podman stop toolbox
```

Delete the toolbox container. Note that this command deletes the container only. The volume backing your home directory will NOT be deleted:

```
$ podman rm toolbox
```

Pull the latest version of the image:

```
$ podman pull quay.io/noseka1/toolbox-container:full
```

Execute a command to re-create the toolbox container using the latest container image. For example, on a Linux host issue:

```
$ podman run \
    --detach
    --name toolbox
    --mount type=volume,src=toolbox-home-anosek,target=/home/anosek
    quay.io/noseka1/toolbox-container:full
```

Note that when you delete and recreate the container, you will need to issue the `adduser ...` command again. The user information is stored in the `/etc` directory which is not backed by a volume.

## Using Toolbox Container for troubleshooting cluster nodes

You can use the Toolbox Container image in the `oc debug` command like this:

```
$ oc debug node/<node> --image quay.io/noseka1/toolbox-container:basic
```
## Using Toolbox Container for troubleshooting pods

You can use the Toolbox Container image in conjuction with the [kubectl-debugpod](https://github.com/noseka1/kubectl-debugpod) utility to attach to any pod running on the cluster.

## Deploying Toolbox Container to OpenShift cluster

Note that instead of using the deployment commands in this section one-by-one, you can leverage the Kustomize scripts located in the [deploy directory](deploy).

### Deploying toolbox-container

Deploy the *toolbox-container* on the cluster:

```
$ oc create deployment toolbox-container --image quay.io/noseka1/toolbox-container:basic
```

Find out the pod name from the output of:

```
$ oc get pod
```

Connect to the *toolbox-container* container:

```
$ oc rsh toolbox-container-<hash>
```

### Configuring toolbox-container

#### Running as privileged container

```
$ oc create serviceaccount toolbox-container
```
```
$ oc adm policy add-scc-to-user privileged --serviceaccount toolbox-container
```
```
$ oc patch deployment toolbox-container \
    --type json \
    --patch '[{"op": "add", "path": "/spec/template/spec/serviceAccountName", "value": "toolbox-container"}]'
```

```
$ oc patch deployment toolbox-container \
    --type json \
    --patch '[{"op": "add", "path": "/spec/template/spec/containers/0/securityContext", "value": { "privileged": true }}]'
```
#### Attaching a persistent volume

```
$ oc set volume \
    deployment/toolbox-container \
    --add \
    --type persistentVolumeClaim \
    --name home \
    --claim-name toolbox-container-home \
    --claim-size 50G \
    --mount-path /home/toolbox
```

#### Mounting the root of the underlying node on /host

```
$ oc set volume \
    deployment/toolbox-container \
    --add \
    --name host \
    --type hostPath \
    --path / \
    --mount-path /host
```
#### Executing custom init script on start-up

Create a custom script. The toolbox container will execute this script on container start-up:

```
$ cat >init.sh <<EOF
echo Hello from the custom init script!
EOF
```

Create a configmap that includes the init script:

```
$ oc create configmap toolbox-container-init --from-file=init.sh
```

Attach the configmap to the toolbox container:
```
$ oc set volume \
    deployment/toolbox-container \
    --add \
    --name init \
    --type configmap \
    --configmap-name toolbox-container-init \
    --mount-path /toolbox
```

#### Allowing cluster-admin access to OpenShift from within the toolbox

```
$ oc adm policy add-cluster-role-to-user cluster-admin --serviceaccount toolbox-container
```

#### Scheduling the toolbox to run on a specific node

```
$ oc patch deployment toolbox-container \
    --type json \
    --patch '[{"op": "add", "path": "/spec/template/spec/nodeName", "value": "ip-10-0-143-77.us-west-2.compute.internal"}]'
```

#### Enabling access to the underlying node by sharing namespaces

```
$ oc patch deployment toolbox-container \
    --type json \
    --patch '[{"op": "replace", "path": "/spec/template/spec/hostNetwork", "value": true}]'
```

```
$ oc patch deployment toolbox-container \
    --type json \
    --patch '[{"op": "replace", "path": "/spec/template/spec/hostPID", "value": true}]'
```

```
$ oc patch deployment toolbox-container \
    --type json \
    --patch '[{"op": "replace", "path": "/spec/template/spec/hostIPC", "value": true}]'
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
$ gunicorn-3 --bind 0.0.0.0:8080 --access-logfile - httpbin:app
```

Serve HTTPS:

```
$ openssl req -newkey rsa:2048 -nodes -keyout httpbin.key -x509 -out httpbin.crt -subj '/CN=example.com'
```

```
$ gunicorn-3 --bind 0.0.0.0:8443 --access-logfile - --keyfile httpbin.key --certfile httpbin.crt  httpbin:app
```

### Run a requestbin server

```
$ (cat <<EOF
"""Send a reply from the proxy without sending any data to the remote server."""
from mitmproxy import http
from mitmproxy import ctx
import datetime

def request(flow: http.HTTPFlow) -> None:
  ctx.log.info("")
  ctx.log.info(datetime.datetime.now())
  ctx.log.info("")
  flow.response = http.Response.make(200)
EOF
) > http-reply-from-proxy.py
```

```
$ mitmdump -s http-reply-from-proxy.py --set flow_detail=4
```

### Run NFS server

NFS server must run in a privileged container (i.e. `pod.spec.template.spec.containers.securityContext.privileged: true`).

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
$ echo '/home/toolbox *(rw,fsid=0,async,no_root_squash)' > /etc/exports.d/toolbox.exports
```

**Note that the fsid=0 option is critical.** Without this option the mount command would hang when trying to mount an NFS share. Note that there can only be one export with fsid=0 on the given NFS server.

```
$ exportfs -a
```

Check that the exports are available:

```
$ showmount -e
Export list for toolbox-container-7c7dc58758-pwkfw:
/home/toolbox *
```

### Run hey

Load test a service:

```
$ hey -c 50 -z 10s <service_url>
```

### MinIO S3 client

Configure target S3 server:

```
$ mcli config host add s3.example.com https://s3.example.com <ACCESS_KEY> <SECRET_KEY>
```

List objects in `mybucket`:

```
$ mcli ls s3.example.com/mybucket
```

### Telnet

Check port connectivity using Telnet:

```
$ curl -v telnet://api.mycluster.example.com:22
```
