variable "proj_name" {
  type        = string
  description = "name of the project"
}
variable "proj_env" {
  type        = string
  description = "environment of the project"
}
variable "instance_type" {
  type        = string
  description = "type of the instance"
}
variable "hosted_zone_name" {
  type        = string
  description = "domain name hosted in route 53"
}
variable "hostname" {
  type        = string
  description = "hostname"
}
variable "hosted_zone_id" {
  type        = string
  description = "id of hosted zone in route 53"
}
