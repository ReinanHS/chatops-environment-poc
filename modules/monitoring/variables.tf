variable "username" {
  description = "The username to be used in the subdomain"
  type        = string
}

variable "domain" {
  description = "The domain name"
  type        = string
}

variable "mariadb_host" {
  description = "Hostname of the MariaDB service"
  type        = string
}

variable "mariadb_port" {
  description = "Port of the MariaDB service"
  type        = number
}

variable "mariadb_database" {
  description = "Name of the MariaDB database"
  type        = string
}

variable "mariadb_user" {
  description = "Username for MariaDB"
  type        = string
}

variable "mariadb_user_password" {
  description = "Password for MariaDB user"
  type        = string
}
