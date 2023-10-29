# Creating a Pipeline

Please note: This pipeline assumes that both tasks "build-docker-image-from-git-repo" and "deploy-docker-image" have been defined and are available in your Tekton environment.

In this pipeline, the build-docker-image-from-git-repo task will run first. The output of this task, which is a Docker image, will be used as an input for the deploy-docker-image task.

## Leverage Tekton Hub

For this pipeline, we would like to use someone else's Task to perform part of our work. As a result, we need to deploy that Task in our own `namespace`.

Assuming we already searched the catalog at [Tekton Hub](https://hub.tekton.dev/) and found [`kubernetes-actions`](https://hub.tekton.dev/tekton/task/kubernetes-actions). We need to deploy it.

```bash
kubectl create -n tektontutorial \
  -f https://raw.githubusercontent.com/tektoncd/catalog/master/task/openshift-client/0.2/openshift-client.yaml
```

## Creating a Tekton Pipeline

This example creates a Pipeline that includes the two tasks we defined earlier: "build-docker-image-from-git-repo" and "deploy-docker-image".

### Step 1: Create the Pipeline definition

Here's the Pipeline definition:

```yaml
apiVersion: tekton.dev/v1beta1
kind: Pipeline
metadata:
  name: build-and-deploy-pipeline
spec:
  workspaces:
    - name: workspace
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
      default: example.com/workshop-website
    - name: deployment-name
      type: string
      description: The name of the Kubernetes Deployment
    - name: namespace
      type: string
      description: The name of the namespace you want to deploy to
    - name: storageDriver
      type: string
      description: Use storage driver type vfs.
      default: vfs
  tasks:
    - name: clone-repo
      taskRef:
        name: clone-from-git-repo
      workspaces:
        - name: workshop
          workspace: workspace
      params:
        - name: repo-url
          value: $(params.repo-url)
    - name: build-image
      taskRef:
        name: build-image-from-git-repo
      workspaces:
        - name: workshop
          workspace: workspace
      params:
      - name: context-dir
        value: $(params.context-dir)
      - name: destination-image
        value: $(params.destination-image)
      runAfter:
        - clone-repo
    - name: deploy-image
      taskRef:
        name: kubernetes-actions
      runAfter:
        - build-image
      params:
        - name: script
          value: |
            kubectl create deployment $(params.deployment-name) -n $(params.namespace) --image=$(params.destination-image)
            kubectl expose deployment/$(params.deployment-name) -n $(params.namespace) --port=8080 --target-port=80 --type=NodePort
```

In this Pipeline definition:

* **apiVersion**: tekton.dev/v1beta1 specifies the Tekton Pipelines API version.
* **kind**: Pipeline indicates that this is a Tekton Pipeline.
* **metadata**: name: build-and-deploy-pipeline sets the name of the Pipeline.
* **spec**:
  * **params**: contains a list of parameters that can be supplied to the pipeline. We have four parameters: repo-url, image-name, deployment-name, and namespace.
  * **tasks**: contains a list of tasks that are included in the pipeline. We have three tasks: `clone-repo`, `build-image-from-git-repo`, and `deploy-image`.
    * **taskRef**: the name of the actual Task
    * **runAfter**: is used to specify the order of tasks. In this case, deploy-image should run after build-image.

### Step 2: Apply the Pipeline to your cluster

To apply the Pipeline to your cluster, save the YAML to a file named build-and-deploy-pipeline.yaml, then run:

```bash
kubectl apply -f build-and-deploy-pipeline.yaml
```

This command applies (creates or updates) the Pipeline on your Kubernetes cluster.

### Step 3: Check if the Pipeline is created

To check if the Pipeline is created:

```bash
kubectl get pipelines
```

If the Pipeline was created successfully, you should see build-and-deploy-pipeline in the list of pipelines.

### Step 4: Run the Pipeline

Let's use `tkn pipeline start` to run the pipeline.

```bash
tkn pipeline start build-and-deploy-pipeline --showlog
```

### Step 5: Fix the Error

Let's do some debugging!

Examining the error we don't have permission to be able to run the `kubectl` commands in our pipeline.
As a result, we need to make a `ServiceAccount` with the appropriate privileges.
For brevity, we won't include the yaml for that here.
However, we do need to:

```bash
kubectl apply -f ./scripts/pipeline-sa-role.yaml
```

### Step 6: Run the Pipeline

Now we have a service account, let's try it again but, we have to tell `tkn` about the `ServiceAccount`.

```bash
tkn pipeline start build-and-deploy-pipeline --serviceaccount='pipeline' --showlog
```

We will be prompted with a bunch of questions. You can take the defaults for most but, for the blank ones, you need to give an answer:

* `deployment-name`: detroit-website
* `namespace`: the namespace you are using (likely `workshop-ns`)
* `workspace`: this has changed names to be "workspace" but we still use no subdirectory, pvc type, and `workshop-pvc` for the rest of the answers.
