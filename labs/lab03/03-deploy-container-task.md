# Creating a Tekton Task

This example creates a Task that deploys a Docker image to a Kubernetes cluster.

## Step 1: Create the Task definition

Here's an example Task definition:

```yaml
apiVersion: tekton.dev/v1beta1
kind: Task
metadata:
  name: deploy-docker-image
spec:
  params:
    - name: image-name
      type: string
      description: The name of the image to deploy
    - name: deployment-name
      type: string
      description: The name of the Kubernetes Deployment
    - name: namespace
      type: string
      description: The namespace of the Kubernetes Deployment
  steps:
    - name: deploy
      image: bitnami/kubectl:latest
      script: |
        kubectl set image deployment/$(params.deployment-name) *=$(params.image-name) -n $(params.namespace)
```

In this Task definition:

* apiVersion: tekton.dev/v1beta1 specifies the Tekton Pipelines API version.
* kind: Task indicates that this is a Tekton Task.
* metadata: name: deploy-docker-image sets the name of the Task.
* spec: params: contains a list of parameters that can be supplied to the task. We have three parameters: image-name, deployment-name, and namespace.
* spec: steps: contains a list of steps that will be executed in order. Here, there's only one step, deploy, which uses the bitnami/kubectl image to set the image of the Kubernetes Deployment.

## Step 2: Apply the Task to your cluster

To apply the Task to your cluster, save the YAML to a file named deploy-docker-image.yaml, then run:

```bash
kubectl apply -f deploy-docker-image.yaml
```

This command applies (creates or updates) the Task on your Kubernetes cluster.

## Step 3: Check if the Task is created

To check if the Task is created:

```bash
kubectl get tasks
```

If the Task was created successfully, you should see deploy-docker-image in the list of tasks.

## Step 4: Run the Task

To run the Task, you'll need to create and apply a TaskRun. You'll need to specify the parameters for the TaskRun:

```yaml
apiVersion: tekton.dev/v1beta1
kind: TaskRun
metadata:
  name: deploy-docker-image-run
spec:
  taskRef:
    name: deploy-docker-image
  params:
    - name: image-name
      value: '<your-image-name>'
    - name: deployment-name
      value: '<your-deployment-name>'
    - name: namespace
      value: '<your-namespace>'
```

Save this to a file named deploy-docker-image-run.yaml, then apply it with kubectl:

```bash
kubectl apply -f deploy-docker-image-run.yaml
```

## Step 5: Check the TaskRun's log

To check the logs of the TaskRun:

```bash
tkn taskrun logs deploy-docker-image-run -f
```

You should see the output from the kubectl set image command in the logs.

For more information about Tasks and TaskRuns, refer to the official Tekton documentation.

Remember, this guide assumes that you've already installed `kubectl` and Tekton on your Kubernetes cluster.

Also, note that this Task assumes that you have appropriate permissions to perform the `kubectl set image` operation in your Kubernetes cluster. The task also assumes that the Deployment already exists and that the Docker image is available in a registry that your Kubernetes cluster can pull from.

