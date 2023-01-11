resource "google_artifact_registry_repository" "main" {
  location      = var.location
  repository_id = var.repository_id
  format        = "DOCKER"
}

resource "google_artifact_registry_repository_iam_binding" "main" {
  location   = google_artifact_registry_repository.main.location
  repository = google_artifact_registry_repository.main.name
  role       = "roles/artifactregistry.writer"
  members    = var.members
}
