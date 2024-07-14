# Helm deploy with Terraform

## Requirements

For this demo we will use:

- WSL Ubuntu on a Windows 11 Pro host machine
	- install WSL and Ubuntu (Ubuntu is installed by default with WSL)

(from now on almost everything will performed on the Ubuntu WSL machine)

- Minikube for provisioning K8s clusters locally
	- install Docker
	- install Minikube

- kubectl and Terraform for managing the K8s Workloads
	- install kubectl
	- install Terraform

- other development tools
	- install VisualStudioCode, git, Google Chrome

## Prepare for the demo

With all the above prerequisites met, start a Minikube cluster with

```bash
minikube start
```

which will create a "minikube" cluster, a "default" namespace and others K8s resources.

Wait for the pods to be in a ready state

```bash
watch -n 0.5 kubectl get po -A
```

## Run the demo

Initialize the Terraform working directory with

```bash
terraform init
```

Preview the changes that Terraform plans to make to your infrastructure with

```bash
terraform plan
```

Execute the actions proposed in the plan

```bash
terraform apply
```

and reply "yes" when prompted.

You can now perform some actions to check the created K8s workloads

```bash
kubectl get ns
kubectl get deployment -n terraform-namespace
kubectl get pods -n terraform-namespace
kubectl get svc -n terraform-namespace
```

Now check the Minikube IP with

```bash
minikube ip
```

(in my case is `192.168.49.2`)

Nginx service will be accessible via browser on `[minikube_ib]:30201`

where you will see the "Welcome to nginx!" page

## Shutdown

Clear down the Terraform created demo resources

```bash
terraform destroy
```

and reply "yes" when prompted.

Stop the local Minikube cluster

```bash
minikube stop
```

## Resources

- [Run Linux GUI apps on the Windows Subsystem for Linux](https://learn.microsoft.com/en-us/windows/wsl/tutorials/gui-apps)
- [Install Terraform](https://developer.hashicorp.com/terraform/install)
- [Kubernetes Workloads](https://kubernetes.io/docs/concepts/workloads)
- [Deploy Kubernetes Resources in Minikube cluster using Terraform](https://dev.to/chefgs/deploy-kubernetes-resources-in-minikube-cluster-using-terraform-1p8o)
- [Terraform Kubernetes provider on Minikube. Creating namespaces and running Nginx deployment](https://nodevops.nl/terraform-with-minukube-kubernetes-provider)

## Notes

At the moment there is also the interesting possibility to use a [Minikube Terraform provider](https://registry.terraform.io/providers/scott-the-programmer/minikube/latest/docs) in order to automate the Minikube clusters provisioning, but for this demo we will not use it in order of giving a little more context around the process of cluster creation and for remaining a little more agnostic from the K8S resource provider.
