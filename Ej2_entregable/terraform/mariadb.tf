resource "kubernetes_deployment" "mariadb" {
  metadata {
    name = "mariadb"
    labels = { app = "mariadb" }
  }
  spec {
    replicas = 1
    selector { match_labels = { app = "mariadb" } }
    template {
      metadata { labels = { app = "mariadb" } }
      spec {
        container {
          name  = "mariadb"
          image = "mariadb:latest"
          port { container_port = 3306 }
          env {
            name  = "MARIADB_ROOT_PASSWORD"
            value = var.db_root_password
          }
          env {
            name  = "MARIADB_DATABASE"
            value = var.db_name
          }
          env {
            name  = "MARIADB_USER"
            value = var.db_user
          }
          env {
            name  = "MARIADB_PASSWORD"
            value = var.db_password
          }
          volume_mount {
            name       = "mariadb-data"
            mount_path = "/var/lib/mysql"
          }
        }
        volume {
          name = "mariadb-data"
          persistent_volume_claim {
            claim_name = "mariadb-pvc"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "mariadb" {
  metadata {
    name = "service-mariadb"
    labels = { app = "mariadb" }
  }
  spec {
    selector = { app = "mariadb" }
    type = "ClusterIP"
    port {
      name = "mysql"
      port = 3306
      target_port = 3306
    }
  }
}
