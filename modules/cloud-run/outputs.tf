output "url" {
  value = google_cloud_run_service.main.status[0].url
}

output "image" {
  value = google_cloud_run_service.main.template[0].spec[0].containers[0].image
}

output "name" {
  value = google_cloud_run_service.main.name
}

output "location" {
  value = google_cloud_run_service.main.location
}
