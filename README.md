# Crossplane Pilot

Experiment with exposing [CSB Brokerpaks](https://github.com/cloud-gov/csb/tree/main/brokerpaks/aws-ses) via Crossplane.

## Background

In Cloud Foundry, users can provision cloud resources using the Services APIs. CF exposes concepts like Service Offerings, Service Plans, Service Instances, and Service Bindings to represent the marketplace of options available to users and the concrete instances of those options that they create. Offering access to provision cloud services exclusively via the services APIs means that operators can expose only hardened, compliant services, with no risk of deviation.

Kubernetes does not have a built-in set of concepts similar to the Services APIs, but the Kubernetes API can be extended with Custom Resource Definitions (CRDs). [Crossplane](https://www.crossplane.io/) is a project that supports creating CRDs that represent resources outside the cluster, allowing the provisioning of cloud resources through the Kubernetes control plane.

In CF, we broker new services by writing a brokerpak, which is a bundle of Terraform code. Writing the Terraform that configures a service to be compliant with federal laws, regulations, and rules is time-consuming and requires expertise. We would like to be able to reuse the work we've done to define compliant services in CF, in a k8s environment.

This pilot will reuse those Terraform modules using the [OpenTofu Crossplane provider](https://marketplace.upbound.io/providers/upbound/provider-opentofu/v0.2.5/docs). We will create a CompositeResourceDefinition and Composition that allow end users to provision an AWS SES identity, reusing the terraform from the [SES brokerpak](https://github.com/cloud-gov/csb/tree/main/brokerpaks/aws-ses).

## Usage

Prerequisites: A Kubernetes cluster with Crossplane installed, and internet access (for downloading images, OpenTofu providers, and our remote Terraform modules.)

- Create a namespace to work on. `kubectl create ns your-ns`
- Apply the `definition.yaml` and `composition.yaml` into the cluster with `kubectl apply -f <file>`.
