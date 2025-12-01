resource "kubernetes_deployment" "matomo" {
  metadata {
    name = "matomo"
    labels = { app = "matomo" }
  }
  spec {
    replicas = 1
    selector { match_labels = { app = "matomo" } }
    template {
      metadata { labels = { app = "matomo" } }
      spec {
        container {
          name  = "matomo"
          image = "aketzacitores/matomo-custom:latest"
          port { container_port = 80 }
          env {
            name  = "MATOMO_DATABASE_HOST"
            value = "service-mariadb"
          }
          env {
            name  = "MATOMO_DATABASE_USERNAME"
            value = var.db_user
          }
          env {
            name  = "MATOMO_DATABASE_PASSWORD"
            value = var.db_password
          }
          env {
            name  = "MATOMO_DATABASE_DBNAME"
            value = var.db_name
          }
          volume_mount {
            name       = "matomo-data"
            mount_path = "/var/www/html"
          }
        }
        volume {
          name = "matomo-data"
          persistent_volume_claim {
            claim_name = "matomo-pvc"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "matomo" {
  metadata {
    name = "service-matomo"
    labels = { app = "matomo" }
  }
  spec {
    selector = { app = "matomo" }
    type = "NodePort"
    port {
      name = "http"
      port = 80
      node_port = 30081
    }
  }
}
