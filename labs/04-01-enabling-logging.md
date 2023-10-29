# How to Enable Logging in Tekton

1. Create a new file called logging.yaml.
2. Paste the following YAML into the file:

```yaml
apiVersion: logging.k8s.io/v1alpha1
kind: Logger
metadata:
  name: tekton-pipelines
spec:
  level: debug

```

3. Save the file.
4. Apply the logging configuration to your Kubernetes cluster:

```
kubectl apply -f logging.yaml
```

Once you have enabled logging, you can use the kubectl logs command to get the logs from the Tekton Pipelines controller.

Here is an explanation of the different sections of the logging configuration:

* The **apiVersion** and **kind** fields specify the version of the Logging API that * the logging configuration is using.
* The **metadata** section contains the name of the logger.
* The **spec** section defines the configuration of the logger.
* The **level** field specifies the logging level.

Here are some additional tips for enabling logging for a Tekton environment:

* You can also enable logging for individual tasks and pipelines by setting the logging field in the task or pipeline spec.
* You can use the `kubectl describe` command to get more information about the logger.
* You can use the `kubectl get pods` command to get the status of the pod that is running the logger.