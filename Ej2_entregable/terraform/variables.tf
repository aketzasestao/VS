variable "matomo_image" {
  type    = string
  default = "aketzacitores/matomo-custom:latest"
}

variable "db_root_password" {
  type      = string
  default   = "rootpass"
}

variable "db_name" {
  type    = string
  default = "matomo"
}

variable "db_user" {
  type    = string
  default = "matouser"
}

variable "db_password" {
  type      = string
  default   = "dbpass"
}
