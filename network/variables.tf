variable "region" {
  type    = string
  default = "eu-central-1"
}
variable "vpc_cidr" {
  default = "10.10.0.0/16"
}

variable "env" {
  default = "dev"
}

variable "public_subnets_cidr" {
  default = [
    "10.10.11.0/25",
    "10.10.11.128/25",
  ]
}
