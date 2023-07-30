# Validating the Installation of `kubectl`

As you probably know, `kubectl` is a command line interface for running commands against Kubernetes clusters. Here are some commands to validate your `kubectl` installation:

## Check kubectl version

To verify that `kubectl` is installed correctly, you can check the version of `kubectl`.

```bash
kubectl version --client
```

This will show you the version of your `kubectl` client. If `kubectl` is correctly installed, you will see something like this:

```bash

Client Version: version.Info{Major:"1", Minor:"22", GitVersion:"v1.22.0", GitCommit:"xyz", GitTreeState:"clean", BuildDate:"2022-07-28T10:40:01Z", GoVersion:"go1.16.6", Compiler:"gc", Platform:"linux/amd64"}
```

If you see a message like `Command 'kubectl' not found`, it means that `kubectl` is not installed or not correctly added to the path.

Remember, we need the command to report at least version 1.15 for the rest of the workshop.

For more details about this command, see [the official documentation](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/).

## Validate the Kubernetes cluster information

You can validate your `kubectl` connection to the cluster by checking the cluster information:

`kubectl cluster-info`

If `kubectl` is configured correctly, you will see the Kubernetes master address and services details.

## Check available nodes

You can also check if your nodes are properly configured and ready by running:
Please remember to adjust these instructions as needed based on your specific Kubernetes configuration and hosting environment.
`kubectl get nodes`

This command lists all nodes that `kubectl` can communicate with.

For more details about nodes you can find more [information here](https://kubernetes.io/docs/concepts/architecture/nodes/).

Remember, in order for `kubectl` to find and access a Kubernetes cluster, it needs a [kubeconfig file](https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/), which is created automatically when you create a cluster. By default, kubectl configuration is located at ~/.kube/config.

# Installing Tekton

Tekton is a Kubernetes-native CI/CD system that provides ways to build, test, and deploy applications.

## Installation Steps

### Step 1: Apply the Tekton Pipelines CRD

Tekton Pipelines run on the top of Kubernetes. They introduce several Custom Resource Definitions (CRDs) on your cluster. To install Tekton Pipelines, use the following `kubectl` command:

```bash
kubectl apply --filename https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml
```

This command downloads the latest Tekton Pipelines `release.yaml` file and applies it to your Kubernetes cluster.

For more details about this command, see the [Tekton Pipeline installation guide](https://tekton.dev/docs/pipelines/install/).

### Step 2: Monitor the Tekton Pipelines components until all components show a `STATUS` of `Running`:

To make sure that the Tekton Pipelines have been installed correctly, monitor the Tekton components:

```bash
kubectl get pods --namespace tekton-pipelines
```

This command lists all the pods in the `tekton-pipelines` namespace. You should see the Tekton components running as pods.

For more details about `kubectl get pods` command, see the [official Kubernetes documentation](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#get).

### Step 3: Verify the installation

To verify your installation, check if the Tekton Pipelines CRDs are installed:

```bash
kubectl get crds | grep 'tekton.dev'
```

This command lists all the installed Custom Resource Definitions (CRDs) that match 'tekton.dev'. If Tekton Pipelines has been installed correctly, you should see several Tekton CRDs listed.

For more details about the `kubectl get crds` command, see the [official Kubernetes documentation](https://kubernetes.io/docs/tasks/extend-kubernetes/custom-resources/custom-resource-definitions/).

You've now installed Tekton on your Kubernetes cluster!