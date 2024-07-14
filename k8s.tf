resource "kubernetes_namespace" "example-namespace" {
  metadata {
    name = "terraform-namespace"
  }
}

# Deployment

resource "kubernetes_deployment" "example-deployment" {
  metadata {
    name = "terraform-deployment"
    labels = {
      App = "ExampleApp"
    }
    namespace = kubernetes_namespace.example-namespace.id
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        App = "ExampleApp"
      }
    }
    template {
      metadata {
        labels = {
          App = "ExampleApp"
        }
      }
      spec {
        container {
          image = "nginx:1.21.6"
          name  = "nginx-container"
          port {
            container_port = 80
          }
          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

# Service

resource "kubernetes_service" "example-service" {
  metadata {
    name = "terraform-service"
    namespace = kubernetes_namespace.example-namespace.id
  }
  spec {
    selector = {
      App = kubernetes_deployment.example-deployment.spec.0.template.0.metadata[0].labels.App
    }
    port {
      node_port   = 30201
      port        = 80
      target_port = 80
    }
    type = "NodePort"
  }
}