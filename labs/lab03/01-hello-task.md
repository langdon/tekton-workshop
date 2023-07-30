markdown

# Creating a Tekton Task

A Tekton Task is a collection of steps that run in a specific order. In this example, we're going to create a Task that echoes "Hello Detroit" to the logs.

## Step 1: Create the Task definition

The first thing we need to do is to define the Task. Tasks are defined using YAML. Here's an example Task definition:

```yaml
apiVersion: tekton.dev/v1beta1
kind: Task
metadata:
  name: echo-hello-detroit
spec:
  steps:
    - name: echo
      image: ubuntu
      script: |
        #!/bin/bash
        echo "Hello Detroit"

In this Task definition:

    apiVersion: tekton.dev/v1beta1 specifies the Tekton Pipelines API version.
    kind: Task indicates that this is a Tekton Task.
    metadata: name: echo-hello-detroit sets the name of the Task.
    spec: steps: contains a list of steps that will be executed in order.
    name: echo names the step.
    image: ubuntu specifies the container image to use for the step. In this case, we're using an Ubuntu image because it has the bash shell and echo command.
    script: | indicates the start of the script to be run in the container.

Step 2: Apply the Task to your cluster

To apply the Task to your cluster, save the YAML to a file named echo-hello-detroit.yaml, then run:

bash

kubectl apply -f echo-hello-detroit.yaml

This command applies (creates or updates) the Task on your Kubernetes cluster.
Step 3: Check if the Task is created

To check if the Task is created:

bash

kubectl get tasks

If the Task was created successfully, you should see echo-hello-detroit in the list of tasks.
Step 4: Run the Task

To run the Task, you'll need to create and apply a TaskRun:

yaml

apiVersion: tekton.dev/v1beta1
kind: TaskRun
metadata:
  name: echo-hello-detroit-run
spec:
  taskRef:
    name: echo-hello-detroit

Save this to a file named echo-hello-detroit-run.yaml, then apply it with kubectl:

bash

kubectl apply -f echo-hello-detroit-run.yaml

Step 5: Check the TaskRun's log

To check the logs of the TaskRun:

bash

tkn taskrun logs echo-hello-detroit-run -f

You should see the output "Hello Detroit" in the logs.

For more information about Tasks and TaskRuns, refer to the official Tekton documentation.

kotlin

Remember, this guide assumes that you've already installed `kubectl` and Tekton on your Kubernetes cluster.

