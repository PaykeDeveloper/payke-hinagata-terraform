variable "secret_id" {
  type    = string
  default = "backend_env"
}

variable "creation" {
  type = bool
}

variable "members" {
  type = list(string)
}
