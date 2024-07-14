# Helm deploy with Terraform

## Requirements

For this demo we will use:

- WSL Ubuntu on a Windows 11 Pro host machine
	- install WSL and Ubuntu (Ubuntu is installed by default with WSL)

(from now on almost everything will performed on the Ubuntu WSL machine)

- Minikube for provisioning K8s clusters locally
	- install Docker
	- install Minikube

- kubectl and Terraform for managing the K8s objects and Helm as the package manager
	- install kubectl
	- install Terraform
	- install Helm

- other development tools
	- install VisualStudioCode, git, Google Chrome

## Prepare the environment for the demo

With all the above prerequisites met, start a Minikube cluster with

```bash
minikube start
```

which will create a cluster on the default `minikube` profile, a `default` namespace (which we'll not use for this demo) and others K8s resources.

Wait for the pods to be in a ready state

```bash
watch -n 0.5 kubectl get po -A
```

You can check the created Kubernets configuration with `cat ~/.kube/config`.

Create the namespace for this demo

```bash
kubectl create namespace terraform-namespace
```

## [Optional] Run the demo using Helm and without Terraform

A custom Helm chart for a sample Nginx application has been created with `helm create custom-nginx` and edited, which you can easily install with

```bash
helm install custom-nginx-chart custom-nginx/ --values custom-nginx/values.yaml --namespace terraform-namespace
```

and after the execution will be completed, you will be prompted with a message for checking the address and port of the running application, like

```bash
export NODE_PORT=$(kubectl get --namespace terraform-namespace -o jsonpath="{.spec.ports[0].nodePort}" services custom-nginx-chart)
export NODE_IP=$(kubectl get nodes --namespace terraform-namespace -o jsonpath="{.items[0].status.addresses[0].address}")
echo http://$NODE_IP:$NODE_PORT
```

wich you can curl or check via your browser.

If you need to upgrade the chart for whatever reason, use `helm upgrade custom-nginx-chart custom-nginx/ --values custom-nginx/values.yaml --namespace terraform-namespace`

You can check the deployed Helm release with

```bash
helm list --namespace terraform-namespace
```

and the created K8s objects

```bash
kubectl get deployment -n terraform-namespace
kubectl get pods -n terraform-namespace
kubectl get svc -n terraform-namespace
```

Once finished, you can uninstall the chart with

```bash
helm uninstall custom-nginx-chart --namespace terraform-namespace
```

## Run the demo with the Terraform Helm provider

Package the local Helm chart with

```bash
helm package custom-nginx/
```

thus creating the local `custom-nginx-0.1.0.tgz` file, which will be used by Terraform in a moment.

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

You can now perform some actions to check the created K8s objects

```bash
kubectl get deployment -n terraform-namespace
kubectl get pods -n terraform-namespace
kubectl get svc -n terraform-namespace
```

Now perform a curl to test the Nginx application using the Minikube IP with

```bash
curl http://$(minikube ip):30201
```

or access it via browser, where you will see the "Welcome to nginx!" page.

Once finished you can clear down the Terraform created demo resources with

```bash
terraform destroy
```

and reply "yes" when prompted.

## Clear the environment created for the demo

Delete the created namespace with

```bash
kubectl delete namespace terraform-namespace
```

and stop the local Minikube cluster

```bash
minikube stop
```

## Resources

- [Run Linux GUI apps on the Windows Subsystem for Linux](https://learn.microsoft.com/en-us/windows/wsl/tutorials/gui-apps)
- [Install Terraform](https://developer.hashicorp.com/terraform/install)
- [Kubernetes Workloads](https://kubernetes.io/docs/concepts/workloads)
- [Deploy Kubernetes Resources in Minikube cluster using Terraform](https://dev.to/chefgs/deploy-kubernetes-resources-in-minikube-cluster-using-terraform-1p8o)
- [Terraform Kubernetes provider on Minikube. Creating namespaces and running Nginx deployment](https://nodevops.nl/terraform-with-minukube-kubernetes-provider)
- [How to make a Helm chart in 10 minutes](https://opensource.com/article/20/5/helm-charts)
- [helm Terraform provider and helm_release resource](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release)

## Notes

At the moment there is also the possibility to use a [Minikube Terraform provider](https://registry.terraform.io/providers/scott-the-programmer/minikube/latest/docs) in order to automate the Minikube clusters provisioning, but for this demo we will not use it for giving a little more context around the process of cluster creation and for neutrality from the K8S resource provider.  
Bitnami provides an useful [nginx-ingress-controller Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/nginx-ingress-controller) which can be used but again, in order to give more context and information through this Demo, a custom Helm chart is used with the minimum information required.
