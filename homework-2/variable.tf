variable "configpath" {
  type    = string
  default = "/home/ruben/epam-terraform-homework/homework-2/roles/wordpress/templates/wp-config.php.j2.template"

}
variable "configpath2" {
  type    = string
  default = "/home/ruben/epam-terraform-homework/homework-2/roles/wordpress/templates/wp-config.php.j2"

}
variable "user" {
  type    = string
  default = "user"
}
variable "password" {
  type    = string
  default = "password"
}
variable "health_check_path" {
  type    = string
  default = "/wp-admin/install.php"
}