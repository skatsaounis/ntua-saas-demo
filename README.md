# SaaS: Kubernetes on OpenStack demo

## Instructions

1. Download and install latest Terraform from the official [site](https://www.terraform.io/downloads.html)
1. Create application credentials from within Horizon: Identity -> Application Credentials -> Create Application Credential
1. Save the `clouds.yaml` file to the root of the repository
1. Run `terraform init` to download Terraform libraries and initialize the Terraform state
1. Run `terraform plan` to verify the proposed execution plan
1. Run `terraform apply` to create the Kubernetes on OpenStack deployment
1. Download and install kubectl from the official [site](https://kubernetes.io/docs/tasks/tools/)
1. Access created Kubernetes cluster:

   ```bash
   export KUBECONFIG=$(pwd)/kube_config_cluster.yml
   kubectl get pod --all-namespaces
   ```
1. (optional) Install Kubernetes [dashboard](https://github.com/kubernetes/dashboard)
