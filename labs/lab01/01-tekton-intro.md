# Review of Kubernetes, Containers, and CI/CD Terminology

Welcome to this introductory section of our workshop. While many of you are familiar with Kubernetes and container technology, we'll start with a quick refresher before we delve into Continuous Integration (CI) and Continuous Deployment (CD).

## Kubernetes

Kubernetes, also known as K8s, is an open-source platform for managing containerized workloads and services. Its main objective is to provide a platform for automating deployment, scaling, and operations of application containers across clusters of hosts.

### Key Kubernetes Terminology

- **Pods**: The smallest and simplest unit in the Kubernetes object model that you create or deploy.
- **Services**: An abstract way to expose an application running on a set of Pods as a network service.
- **Volumes**: A directory, possibly with some data in it, accessible to the Containers in a Pod.
- **Namespaces**: Intended for use in environments with many users spread across multiple teams, or projects.

## Containers

Containers are a standard unit of software that packages up code and all its dependencies so the application runs quickly and reliably from one computing environment to another. A container image is a lightweight, standalone, executable package that includes everything needed to run a piece of software.

## Custom Resource Definition (CRD)

In Kubernetes, a Custom Resource Definition (CRD) is a custom extension of the Kubernetes API that allows you to create your own Kubernetes-style objects for your specific needs. This can be especially useful when you need to work with resources that Kubernetes doesn't handle natively.

In more technical terms, a CRD is a specification for a particular kind of resource (object) that isn't included in the default Kubernetes installation. By using CRDs, you're effectively extending the Kubernetes API to support your custom objects.

When you create a CRD, you define a new kind of resource that can be managed in the same way as built-in resources like Pods, Services, and Deployments. For example, you might define a CRD for a Database resource if you want Kubernetes to manage a database that's integral to your application.

The CRD itself just defines the new resource type — it's like a schema for your custom resource. Once you've defined a CRD, you can create instances of that resource type with custom resource objects.

For more detailed information on CRDs, refer to the official Kubernetes documentation on Custom Resources.

## Continuous Integration (CI)

Continuous Integration is a development practice where developers integrate code into a shared repository frequently, usually multiple times a day. Each integration can then be verified by an automated build and automated tests.

## Continuous Deployment (CD)

Continuous Deployment is a software release process that uses automated testing to validate if changes to a codebase are correct and stable for immediate autonomous deployment to a production environment.

### Key CI/CD Terminologies

- **Pipeline**: A set of automated processes that allow Developers and DevOps professionals to reliably and efficiently compile, build and deploy their code to their production compute platforms.
- **Build**: The process of converting source code files into standalone software artifact(s) that can be run on a computer.
- **Deploy**: The process of distributing a release to one or more machines and installing the release so it is available for use.

In the next section, we will explore how Tekton can be used to build CI/CD systems and its benefits over other tools in the market.

# Why Tekton?

Tekton is a powerful and flexible open-source framework for creating CI/CD systems. It allows developers to build, test, and deploy across multiple cloud providers or on-premises systems by abstracting away the underlying details. But why should you choose Tekton over other CI/CD solutions?

## Kubernetes-native

Tekton has been designed as a Kubernetes-native solution, meaning it uses a Kubernetes-style API and its underlying concepts. This means, if you are already using Kubernetes, you don't need to install and manage another tool. You just have to use Tekton as a part of your Kubernetes ecosystem, thus simplifying the process.

## Flexibility and Extensibility

Tekton Pipelines are defined in terms of Tasks, which are easily composable and can be used to define complex workflows. This makes it easier to create and manage CI/CD pipelines, especially for microservices-based architecture. The declarative nature of Tekton's APIs makes it easier to integrate with existing tools and services.

## Cloud-Native

Being a Cloud Native Computing Foundation (CNCF) project, Tekton embraces the best practices of cloud-native principles. It means that it is designed to work optimally with cloud environments, with concepts like immutable infrastructure and declarative configuration.

## Portability

Tekton is designed to be platform agnostic. This means that you can use Tekton Pipelines on any Kubernetes-compatible platform. This provides a great deal of flexibility and removes vendor lock-in, allowing teams to choose the best provider for their needs without worrying about compatibility.

## Community and Ecosystem

Tekton has a vibrant and rapidly growing community of contributors. It's part of the CD Foundation, which aims to improve the world's capacity to deliver software with security and speed. Tekton's community is always working on new features, improvements, and actively providing support to its users.

To sum it up, Tekton's Kubernetes-native design, its flexibility, portability, and the support of its community make it a compelling choice for organizations and teams building their CI/CD pipelines.
