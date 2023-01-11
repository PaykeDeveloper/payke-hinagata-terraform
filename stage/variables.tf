variable "project" {
  type    = string
}

variable "location" {
  type    = string
  default = "us-central1"
}

variable "repository_id" {
  type    = string
}

variable "github_repository" {
  type    = string
  default = "PaykeDeveloper/payke-hinagata-backend"
}

variable "cloud_run_account_id" {
  type    = string
  default = "cloud-run"
}

variable "github_actions_account_id" {
  type    = string
  default = "github-actions"
}

variable "cloud_run_name" {
  type    = string
  default = "hinagata"
}

variable "cloud_run_image" {
  type    = string
  default = null
}

variable "domain_name" {
  type    = string
  default = null
}

variable "creation" {
  type    = bool
  default = false
}
