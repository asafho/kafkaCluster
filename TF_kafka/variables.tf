variable "region" {}
variable "cluster_name" {}
variable "project_id" {}
variable "vpc_network" {}
variable "vpc_subnetwork" {}
variable "cluster_subnet_cidr" {}


variable "kafka_machine_type" { default="n1-highmem-2" }
variable "disk_size_gb" { default="30" }
variable "disk_type" { default="pd-standard"}
variable "node_count" { default="3"}

variable "gcp_zones" {
  type    = list(string)
  default = ["a","b","c"]
}
