# Debugging Pipelines

### Step 1: Create the Pipeline definition

Create this Pipeline in a file called `deploy-image-error.yaml`.

Here's the Pipeline definition:

```yaml
apiVersion: tekton.dev/v1beta1
kind: Pipeline
metadata:
  name: deploy-pipeline-error
spec:
  tasks:
  - name: build
    taskRef:
      name: build-docker-image-from-git-repo
      params:
        - name: repo-url
          value: https://github.com/langdon/tekton-workshop.git
        - name: image-name
          value: tekton-workshop
  - name: deploy
    taskRef:
      name: deploy-docker-image
      params:
        - name: image-name
          value: $(params.image-name)
        - name: deployment-name
          value: my-deployment
        - name: namespace
          value: default
```

### Step 2: Apply the Pipeline to your cluster

Now run:

```bash
kubectl apply -f deploy-image-error.yaml
```

This command applies (creates or updates) the Pipeline on your Kubernetes cluster.

### Step 3: Check if the Pipeline is created

To check if the Pipeline is created:

```bash
kubectl get pipelines
```

If the Pipeline was created successfully, you should see deploy-pipeline-error in the list of pipelines.

### Step 4: Run the Pipeline

Let's use `tkn pipeline start` to run the pipeline.

```bash
tkn pipeline start deploy-pipeline-error --showlog
```

We will be prompted with a bunch of questions. You can take the defaults for most but, for the blank ones, you need to give an answer:

* `deployment-name`: detroit-website
* `namespace`: the namespace you are using (likely `workshop-ns`)
* `workspace`: this has changed names to be "workspace" but we still use no subdirectory, pvc type, and `workshop-pvc` for the rest of the answers.


## Step 5: An Error!

This pipeline is supposed to build and deploy a Docker image from a GitHub repository. However, if you run the pipeline, you will get the following error:

```
Error: failed to run task deploy: exit status 1
```

The reason for the error is that the deploy task is trying to deploy the image `tekton-workshop`, but the build task has not yet built the image.

To fix the bug, we need to change the order of the tasks in the pipeline. The following is the fixed pipeline spec:


```yaml
apiVersion: tekton.dev/v1beta1
kind: Pipeline
metadata:
  name: deploy-pipeline
spec:
  tasks:
  - name: build
    taskRef:
      name: build-docker-image-from-git-repo
      params:
        - name: repo-url
          value: https://github.com/langdon/tekton-workshop.git
        - name: image-name
          value: tekton-workshop
  - name: deploy
    taskRef:
      name: deploy-docker-image
      params:
        - name: image-name
          value: $(params.image-name)
        - name: deployment-name
          value: my-deployment
        - name: namespace
          value: default
```

## Common pipeline errors, explanations, and resolutions

**Error: failed to run task <task_name>: exit status 1**

This error means that the `task_name` task failed to run. The most common cause of this error is a syntax error in the task spec.

**Error: failed to pull image <image_name>: error pulling image**

This error means that the Tekton Pipelines controller was unable to pull the `image_name` image from a registry. The most common cause of this error is that the image is not available in the registry or, more commonly, for networking or security reasons, your code "thinks" its not in the registry.

**Error: failed to run step <step_name>: step <step_name> not found**

This error means that the Tekton Pipelines controller was unable to find the `step_name` step in the task spec. The most common cause of this error is that the step was misspelled. You will be much happier if you pick a naming convention and always stick to it e.g. snake_case, CamelCase.

## Tips for debugging pipeline errors

* Use the `kubectl logs` command to get the logs from the pipeline.
* Use the `kubectl describe` command to get more information about the pipeline.
* Use the `kubectl get pods` command to get the status of the pod that is running the pipeline.
* Use the `tkn pipelinerun logs <pipeline instance>` to see any issues. Don't forget about the `--all` flag.

