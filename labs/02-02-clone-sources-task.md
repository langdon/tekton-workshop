# Creating a Build Tekton Task

A Tekton Task is a collection of steps that are executed in a specific order. This example creates a Task that clones a GitHub repository and builds an image from a Containerfile in that repository.

## Step 1: Create the Task definition

### Step 1.1: Create the basic Task definition

```yaml
apiVersion: tekton.dev/v1beta1
kind: Task
metadata:
  name: clone-from-git-repo
```

Let's start by adding that yaml to a file called `clone-from-git-repo.yaml`.

First the easy stuff:
* **apiVersion**: `tekton.dev/v1beta1` specifies the Tekton Pipelines API version. We should consider moving to `v1` soon but it is still very new.
* **kind**: `Task` indicates that this is a Tekton Task.
* **metadata**:
  * **name**: sets the name of the Task -- `clone-from-git-repo`.

### Step 1.2: Add a workspace

For this Task, we will need to share data on disk between steps of the task. In order to accomplish this we need to leverage a Tekton `Workspace`. We could also do this with `Volumes` but that's another workshop. Please insert the following yaml at the end of the same file.

```yaml
spec:
  workspaces:
    - name: workshop
      description: The git repo will be cloned onto the volume backing this workspace
```

Now all we have done so far is define the `workspace` and where it will show up in the various containers. We can also address this path as `$(workspaces.workshop.path)`.

* **name**: this is the name of our `workspace` (we can have multiple)
* **mountPath**: this is where the files will appear in each container

### Step 1.3: Add params

Now we add the params we will supply when we run the `task`.

```yaml
  params:
    - name: repo-url
      type: string
      description: The URL of the Git repository
      default: https://github.com/langdon/tekton-workshop.git
    - name: storageDriver
      type: string
      description: Use storage driver type vfs.
      default: vfs
```

* **name**: name of our `param`
* **type**: type of param (string, int, float, bool, array, object, secret)
* **description**: describe the param
* **default**: set the default value

As the authors said before, storage in kubernetes is very confusing. While developing this workshop, we ran into a large number of issues where `overlayfs` was the default and many errors ensued. When we switched to forcing `vfs` things got much better.

### Step 1.4: Add the portobello

Finally, the meat of the `task`.

```yaml
  steps:
    - image: 'gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/git-init:v0.21.0'
      name: clone
      resources: {}
      script: |
        CHECKOUT_DIR="$(workspaces.workshop.path)/"
        cleandir() {
          # Delete any existing contents of the repo directory if it exists.
          #
          # We don't just "rm -rf $CHECKOUT_DIR" because $CHECKOUT_DIR might be "/"
          # or the root of a mounted volume.
          if [[ -d "$CHECKOUT_DIR" ]] ; then
            # Delete non-hidden files and directories
            rm -rf "$CHECKOUT_DIR"/*
            # Delete files and directories starting with . but excluding ..
            rm -rf "$CHECKOUT_DIR"/.[!.]*
            # Delete files and directories starting with .. plus any other character
            rm -rf "$CHECKOUT_DIR"/..?*
          fi
        }
        /ko-app/git-init \
          -url "$(params.repo-url)" \
          -path "$CHECKOUT_DIR"
        cd "$CHECKOUT_DIR"
        RESULT_SHA="$(git rev-parse HEAD)"
```

* **image**: Image to use for the step, you may need to provide a full "path" (like `gcr.io`)
* **name**: Name of the step (arbitrary)
* **script**: Allows you to do arbitrary commands after a `|`. Super useful for debugging.
* **command**: The cleaner, generally more reliable, way of executing a command. Not used in this example but worth noting.

The authors cribbed some of this material from an [existing tutorial](https://redhat-scholars.github.io/tekton-tutorial) and they had a number of "features" that were worth including but are probably not necessary for this workshop. As a result, you can largely ignore the complex cleaning portion of the `clone` step.

However, the steps do demonstrate how complex you can make a `script` in a Tekton Task. Arguably, you could move this to a script and build it in to an image overlayed on `git-init` (for example) but, then you would want a task/set of tasks to keep that fresh as well.

### Step 1.5: The whole kit

Here is the complete yaml if you weren't building it as we went or if you have an inexplicable error.

```yaml
---
apiVersion: tekton.dev/v1beta1
kind: Task
metadata:
  name: build-docker-image-from-git-repo
spec:
  workspaces:
    - name: workshop
      description: The git repo will be cloned onto the volume backing this workspace
  params:
    - name: repo-url
      type: string
      description: The URL of the Git repository
      default: https://github.com/langdon/tekton-workshop.git
    - name: context-dir
      description: the context directory within the repo, in other words, where the Containerfile is
      default: website
    - name: destination-image
      type: string
      description: The name of the image to build
      default: workshop-website
    - name: storageDriver
      type: string
      description: Use storage driver type vfs if you are running on OpenShift.
      default: vfs
  steps:
    - image: 'gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/git-init:v0.21.0'
      name: clone
      resources: {}
      script: |
        CHECKOUT_DIR="$(workspaces.workshop.path)/"
        cleandir() {
          # Delete any existing contents of the repo directory if it exists.
          #
          # We don't just "rm -rf $CHECKOUT_DIR" because $CHECKOUT_DIR might be "/"
          # or the root of a mounted volume.
          if [[ -d "$CHECKOUT_DIR" ]] ; then
            # Delete non-hidden files and directories
            rm -rf "$CHECKOUT_DIR"/*
            # Delete files and directories starting with . but excluding ..
            rm -rf "$CHECKOUT_DIR"/.[!.]*
            # Delete files and directories starting with .. plus any other character
            rm -rf "$CHECKOUT_DIR"/..?*
          fi
        }
        /ko-app/git-init \
          -url "$(params.repo-url)" \
          -path "$CHECKOUT_DIR"
        cd "$CHECKOUT_DIR"
        RESULT_SHA="$(git rev-parse HEAD)"
    - name: build-image
      image: quay.io/buildah/stable
      script: |
        #!/usr/bin/env bash
        buildah --storage-driver=$STORAGE_DRIVER --tls-verify=false bud --layers -t $DESTINATION_IMAGE $CONTEXT_DIR
        buildah --storage-driver=$STORAGE_DRIVER --tls-verify=false push $DESTINATION_IMAGE docker://$DESTINATION_IMAGE
      env:
        - name: DESTINATION_IMAGE
          value: "$(params.destination-image)"
        - name: CONTEXT_DIR
          value: "$(workspaces.workshop.path)/$(params.context-dir)"
        - name: STORAGE_DRIVER
          value: "$(params.storageDriver)"
      workingDir: "$(workspaces.workshop.path)/$(params.context-dir)"
      volumeMounts:
        - name: varlibc
          mountPath: /var/lib/containers
  volumes:
    - name: varlibc
      emptyDir: {}
```

## Step 2: Apply the Task to your cluster

To apply the Task to your cluster, save the YAML to a file named `build-image-from-git-repo.yaml`, then run:

```bash
kubectl apply -f build-image-from-git-repo.yaml
```

This command applies (creates or updates) the Task on your Kubernetes cluster.

## Step 3: Check if the Task is created

To check if the Task is created:

```bash
kubectl get tasks
```

If the Task was created successfully, you should see `build-image-from-git-repo` in the list of tasks.

## Step 4a: Run the Task

The Tekton command line tool (`tkn`) comes with a handy option for running a task which is especially good for testing. Namely:

```bash
tkn task start build-image-from-git-repo
```

You can also pass the `--showlog` flag which will immediately drop you in to a `follow` scenario while it launches. Give the above a try and make sure out task runs. You should be able to take the defaults for all answers except `workspace`. The `start` does give you the "right answer" in the form of:

```
Please give specifications for the workspace: workshop
```

However, you have to type in `workshop`, then nothing for `Sub Path`, choose `EmptyDir`, and then nothing for `Type of EmptyDir`. Obviously, this may not be the right answer for other Tasks.

## Step 4b: Run the Task

To run the Task, you can also create and apply a TaskRun. You'll need to specify the parameters for the TaskRun:

```yaml
apiVersion: tekton.dev/v1beta1
kind: TaskRun
metadata:
  name: build-image-from-git-repo-run
spec:
  taskRef:
    name: build-image-from-git-repo
  params:
  params:
    - name: repo-url
      value: 'https://github.com/<your-repo>'
    - name: context-dir
      value: <any-sub-directory-in-the-repo>
    - name: destination-image
      value: <image-name
    - name: storageDriver
      value: vfs
```

Here is the yaml we should use for the workshop.

```yaml
apiVersion: tekton.dev/v1beta1
kind: TaskRun
metadata:
  name: build-image-from-git-repo-run
spec:
  taskRef:
    name: build-image-from-git-repo
  workspaces:
    - name: workshop
      persistentVolumeClaim:
        claimName: workshop-pvc
  params:
    - name: repo-url
      value: https://github.com/langdon/tekton-workshop.git
    - name: context-dir
      value: website
    - name: destination-image
      value: example.com/workshop-website
    - name: storageDriver
      value: vfs
```

Save this to a file named `build-docker-image-from-git-repo-run.yaml`, then apply it with kubectl:

```bash
kubectl apply -f build-docker-image-from-git-repo-run.yaml
```

In testing on `minikube` the TaskRun was hanging in a pending state so if you don't see this making progress, stick with the command line `tkn task start`.

## Step 5: Check the TaskRun's log

To check the logs of the TaskRun:

```bash
tkn taskrun ls
NAME                                         STARTED         DURATION   STATUS
build-image-from-git-repo-run-<gen-chars>          3 minutes ago   1m39s      Running
tkn taskrun logs build-docker-image-from-git-repo-run-<gen-chars> -f

--------- OR ---------

tkn taskrun logs build-docker-image-from-git-repo-run -f
```

You should see the output from the Git clone and the Docker build in the logs.

For more information about Tasks and TaskRuns, refer to the official Tekton documentation.

Also, note that this Task does not handle pushing the Docker image to a public registry. You'll likely want to add another step to the Task that pushes the image. You would also need to handle Docker authentication in that case. This example is simplified to focus on the core concepts.
