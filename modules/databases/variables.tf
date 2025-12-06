variable "mariadb_root_password" {
  description = "Password for the root user"
  type        = string
  default     = "root-password"
}

variable "mariadb_database" {
  description = "Name of the database to create"
  type        = string
  default     = "mydatabase"
}

variable "mariadb_user" {
  description = "Username for the new user"
  type        = string
  default     = "myuser"
}

variable "mariadb_user_password" {
  description = "Password for the new user"
  type        = string
  default     = "mypassword"
}

variable "postgres_database" {
  description = "Name of the database to create"
  type        = string
  default     = "mydatabase"
}

variable "postgres_user" {
  description = "Username for the new user"
  type        = string
  default     = "myuser"
}

variable "postgres_user_password" {
  description = "Password for the new user"
  type        = string
  default     = "mypassword"
}
