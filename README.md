# Tekton Workshop (August 2023)

## Table of Contents

* **[LAB 00](labs/00-01-tekton-intro.md)**: Review of Kubernetes, Containers, and CI/CD Terminology
* **LAB 02**:
    * **[LAB 02.01](labs/02-01-install-tekton.md)**: Validating the Installation of `kubectl`
    * **[LAB 02.02](labs/02-02-quiz.md)**: A little quiz
* **LAB 03**:
    * **[LAB 03.01](labs/03-01-hello-task.md)**: Creating a Very Simple Tekton Task
    * **[LAB 03.02](labs/03-02-clone-sources-task.md)**: Creating a Build Tekton Task
    * **[LAB 03.03](labs/03-03-create-deploy-container-task.md)**: A Task that Creates a Container
    * **[LAB 03.04](labs/03-04-create-pipeline.md)**: Please note: This pipeline assumes that both tasks build-docker-image-from-git-repo and deploy-docker-image have been defined and are available in your Tekton environment.
    * **[LAB 03.05](labs/03-05-guards-remotes.md)**: Certainly, you can use the Tekton task to send a notification using the Pushbullet API when the build-image-task fails. To do this, we can make use of finally tasks which will always execute after all PipelineTasks have completed.
* **LAB 04**:
    * **[LAB 04.01](labs/04-01-event-listener.md)**: ```yaml
    * **[LAB 04.02](labs/04-02-filtering-triggers.md)**: ```yaml
* **LAB 05**:
    * **[LAB 05.01](labs/05-01-debugging-tasks.md)**: Debugging Tasks
    * **[LAB 05.02](labs/05-02-debugging-pipelines.md)**: Sure, here is a pipeline with a bug that is similar to the pipeline you gave me before:
    * **[LAB 06.01](labs/06-01-enabling-logging.md)**: Sure, here are the step-by-step instructions on how to enable logging for a Tekton environment:
    * **[LAB 06.02](labs/06-02-common-issues.md)**: Typical errors or warnings in Tekton logs


## Approximate Agenda

* Review of kubernetes, container, and CI/CD terminology
* Why Tekton
* Ensure setup of cluster
* Install Tekton -- Please be sure to have up to an hour extra buffer for any problems
* Create 2 basic Tasks
* Create a basic Pipeline
* Add the 2 Tasks to the Pipeline
* Add a Remote Task
* Add a Guarded task
* ~~Add a SideCar~~
* Short lecture on value of CI/CD, GitOps, etc.
* Create EventListener & Trigger (w/ prior pipeline)
* Create Authentication or Payload Filtering (TBD) Interceptor  (w/ prior pipeline)
* Debug a provided, broken, Task
* Debug a provided, broken, Pipeline
* Troubleshoot a provided Tekton environment by
  * Enabling logging
  * Gathering logs
  * Investigating logs
* Q&A
* Where to learn more
