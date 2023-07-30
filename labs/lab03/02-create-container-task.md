# Creating a Tekton Task

A Tekton Task is a collection of steps that are executed in a specific order. This example creates a Task that clones a GitHub repository and builds a Docker image from a Dockerfile in that repository.

## Step 1: Create the Task definition

Here's an example Task definition:

```yaml
apiVersion: tekton.dev/v1beta1
kind: Task
metadata:
  name: build-docker-image-from-git-repo
spec:
  params:
    - name: repo-url
      type: string
      description: The URL of the Git repository
    - name: image-name
      type: string
      description: The name of the image to build
  steps:
    - name: clone
      image: alpine/git
      script: |
        git clone $(params.repo-url) .
    - name: build-and-push
      image: docker
      script: |
        docker build -t $(params.image-name) .
```

In this Task definition:

* apiVersion: tekton.dev/v1beta1 specifies the Tekton Pipelines API version.
* kind: Task indicates that this is a Tekton Task.
* metadata: name: build-docker-image-from-git-repo sets the name of the Task.
* spec: params: contains a list of parameters that can be supplied to the task. We have two * parameters: repo-url and image-name.
* spec: steps: contains a list of steps that will be executed in order.
* The first step, clone, uses the alpine/git image to clone the Git repository.
* The second step, build-and-push, uses the docker image to build a Docker image from the * Dockerfile in the repository.

## Step 2: Apply the Task to your cluster

To apply the Task to your cluster, save the YAML to a file named build-docker-image-from-git-repo.yaml, then run:

```bash
kubectl apply -f build-docker-image-from-git-repo.yaml
```

This command applies (creates or updates) the Task on your Kubernetes cluster.

## Step 3: Check if the Task is created

To check if the Task is created:

```bash
kubectl get tasks
```

If the Task was created successfully, you should see build-docker-image-from-git-repo in the list of tasks.

## Step 4: Run the Task

To run the Task, you'll need to create and apply a TaskRun. You'll need to specify the parameters for the TaskRun:

```yaml
apiVersion: tekton.dev/v1beta1
kind: TaskRun
metadata:
  name: build-docker-image-from-git-repo-run
spec:
  taskRef:
    name: build-docker-image-from-git-repo
  params:
    - name: repo-url
      value: 'https://github.com/<your-repo>'
    - name: image-name
      value: '<your-image-name>'
```

Save this to a file named build-docker-image-from-git-repo-run.yaml, then apply it with kubectl:

```bash
kubectl apply -f build-docker-image-from-git-repo-run.yaml
```

## Step 5: Check the TaskRun's log

To check the logs of the TaskRun:

```bash
tkn taskrun logs build-docker-image-from-git-repo-run -f
```

You should see the output from the Git clone and the Docker build in the logs.

For more information about Tasks and TaskRuns, refer to the official Tekton documentation.

Remember, this guide assumes that you've already installed `kubectl` and Tekton on your Kubernetes cluster.

Also, note that this Task does not handle pushing the Docker image to a registry. You'll likely want to add another step to the Task that pushes the image. You would also need to handle Docker authentication in that case. This example is simplified to focus on the core concepts.
