locals {
  image       = var.creation ? "gcr.io/cloudrun/placeholder" : var.image
  volume_name = "env"
}

resource "google_cloud_run_service" "main" {
  name     = var.name
  location = var.location

  autogenerate_revision_name = true
  template {
    spec {
      service_account_name = var.service_account_name
      containers {
        image = local.image
        volume_mounts {
          name       = local.volume_name
          mount_path = "/secrets"
        }
      }
      volumes {
        name = local.volume_name
        secret {
          secret_name = var.secret_name
          items {
            key  = "latest"
            path = "env"
          }
        }
      }
    }
  }
}

data "google_iam_policy" "main" {
  binding {
    role    = "roles/run.invoker"
    members = ["allUsers"]
  }
}

resource "google_cloud_run_service_iam_policy" "main" {
  location = google_cloud_run_service.main.location
  project  = google_cloud_run_service.main.project
  service  = google_cloud_run_service.main.name

  policy_data = data.google_iam_policy.main.policy_data
}

resource "google_cloud_run_domain_mapping" "main" {
  count    = var.domain_name == null ? 0 : 1
  location = google_cloud_run_service.main.location
  name     = var.domain_name
  metadata {
    namespace = google_cloud_run_service.main.project
  }
  spec {
    route_name = google_cloud_run_service.main.name
  }
}

resource "google_cloud_run_v2_job" "main" {
  for_each = {
    migrate = ["migrate", "--force"]
    seed    = ["db:seed", "--force"]
  }

  name         = each.key
  location     = var.location
  launch_stage = "BETA"

  template {
    template {
      service_account = var.service_account_name
      containers {
        image   = local.image
        command = concat(["php", "artisan"], each.value)
        volume_mounts {
          name       = local.volume_name
          mount_path = "/secrets"
        }
      }
      volumes {
        name = local.volume_name
        secret {
          secret = var.secret_name
          items {
            version = "latest"
            path    = "env"
            mode    = 256
          }
        }
      }
    }
  }
}
