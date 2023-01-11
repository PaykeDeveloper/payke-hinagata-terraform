resource "google_secret_manager_secret" "main" {
  secret_id = var.secret_id
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "main" {
  count       = var.creation ? 1 : 0
  depends_on  = [google_secret_manager_secret.main]
  secret      = google_secret_manager_secret.main.id
  secret_data = "EXAMPLE=example"
}

resource "google_secret_manager_secret_iam_binding" "main" {
  secret_id = google_secret_manager_secret.main.secret_id
  role      = "roles/secretmanager.secretAccessor"
  members   = var.members
}
