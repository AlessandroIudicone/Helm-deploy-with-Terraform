resource "helm_release" "nginx_release" {
  name       = "nginx-release"
  namespace   = "terraform-namespace"
  chart      = "custom-nginx-0.1.0.tgz"
  values = [
    "${file("./custom-nginx/values.yaml")}"
  ]
}