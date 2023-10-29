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

Remember, in order for `kubectl` to find and access a Kubernetes cluster, it needs a [kubeconfig file](https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/), which is created automatically when you create a cluster. By default, kubectl configuration is located at ~/.kube/config. You should always be aware of your config because it can be very easy to be working with the wrong cluster. I definitely recommend, if you haven't already, experimenting with naming your connections using `contexts` and then using those contexts. You can find a good [tutorial/experiment here](https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/).

# Installing Tekton Pipelines

Let's get Tekton installed in your cluster. When we say "install Tekton" we really mean install "Tekton Pipelines" then installing "Tekton Triggers". The "trigger functionality" is generally optional but we will be using it in this workshop.

We should also point out that installing arbitrary files from the internet is usually a bad idea. We will be doing it in this workshop because the authors have validated the installations. However, in general, you should download the files in question, review them, and then use them after you have confirmed that the contents of the file are what you think they are.

## Installation Steps

### Step 1: Apply the Tekton Pipelines CRD

Tekton Pipelines run on the top of Kubernetes. They introduce several Custom Resource Definitions (CRDs) on your cluster. To install Tekton Pipelines, use the following `kubectl` command:

```bash
kubectl apply --filename https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml
```

This command downloads the latest Tekton Pipelines `release.yaml` file and applies it to your Kubernetes cluster.

For more details about this command, see the [Tekton Pipelines installation guide](https://tekton.dev/docs/pipelines/install/).

### Step 2: Monitor the Tekton Pipelines components until all components show a `STATUS` of `Running`:

To make sure that the Tekton Pipelines have been installed correctly, monitor the Tekton components:

```bash
kubectl get pods --namespace tekton-pipelines
```

If you add `-w` to the end, `kubectl` will monitor the "search" and update your result when it changes.

This command lists all the pods in the `tekton-pipelines` namespace. You should see the Tekton components running as pods.

For more details about `kubectl get pods` command, see the [official Kubernetes documentation](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#get).

### Step 3: Verify the installation

To verify your installation, check if the Tekton Pipelines CRDs are installed:

```bash
kubectl get crds | grep 'tekton.dev'
```

This command lists all the installed Custom Resource Definitions (CRDs) that match 'tekton.dev'. If Tekton Pipelines has been installed correctly, you should see several Tekton CRDs listed.

For more details about the `kubectl get crds` command, see the [official Kubernetes documentation](https://kubernetes.io/docs/tasks/extend-kubernetes/custom-resources/custom-resource-definitions/).

You've now installed Tekton Pipelines on your Kubernetes cluster!

# Installing Tekton Triggers

For this workshop, we are going to be working on Tekton Triggers as well as Tasks and Pipelines so, let's install it now.

## Installation Steps

### Step 1: Install the Tekton Triggers Custom Resource Definitions (CRDs) and controller

```bash
kubectl apply -f https://storage.googleapis.com/tekton-releases/triggers/latest/release.yaml
```

This command fetches the latest Tekton Triggers release manifest and applies it to your Kubernetes cluster. It includes the necessary CRDs for Tekton Triggers and the Triggers control plane components. More information may be found on the [Tekton Triggers installation page](https://tekton.dev/docs/installation/triggers/)

### Step 2: Install Tekton Interceptors

```bash
kubectl apply --filename https://storage.googleapis.com/tekton-releases/triggers/latest/interceptors.yaml
```

Another optional feature of Tekton are "Interceptors" which is what we are installing above which includes the core interceptors: CEL, Bitbucket, GitHub, and GitLab interceptors.. We will talk more about these later in the workshop. If you want to read more about them, you can find details at the [official documentation](https://tekton.dev/docs/triggers/interceptors/).

### Step 3: Verify that the installation succeeded

```bash
kubectl get pods --namespace tekton-pipelines
```

This command lists the pods in the tekton-pipelines namespace. You should see the Tekton Triggers pods, such as tekton-triggers-controller-* and tekton-triggers-webhook-*, in a RUNNING state after a successful installation.

# Installing Tekton CLI

Last, but not least, let's install the Tekton CLI tool. You have a number of options to get it installed based on your operating system. The full [installation instructions](https://tekton.dev/docs/cli/) have more details but, hopefully, one of the options below will work for you. All of these methods will dynamically give you the latest version with the exception of the `deb` instructions as there is no dynamic way to get it. If you want to use the `deb` version, you should fix the URL below to match the [latest release](https://github.com/tektoncd/cli/releases/). At the time of this writing, the latest was `0.31.2`.

* Mac
```bash
brew install tektoncd-cli
```
* Windows
```bash
choco install tektoncd-cli --confirm
```
* Linux RPM & dnf/yum
```bash
sudo dnf copr enable -y chmouel/tektoncd-cli
sudo dnf install -y tektoncd-cli
```
* Linux Deb
```bash
curl -LO https://github.com/tektoncd/cli/releases/download/v0.31.2/tektoncd-cli-0.31.2_Linux-64bit.deb
sudo dpkg -i ./tektoncd-cli-0.31.2_Linux-64bit.deb
```

## Verify installation

Now, check that tektoncd-cli has been installed by running `tkn`.

```bash
tkn
```

You should get help output.