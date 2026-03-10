variable "aws_region" {
    default = "eu-central-1"
}
variable "access_key" {
    description = "access key for the AWS account"
}
variable "secret_key" {
    description = "secret key for AWS account"
}
variable "azs" {
    default = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
}

variable "private_subnet_cidrs" {
    default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnet_cidrs" {
    default = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
}

variable "cluster_name" {
    default = "hive_cluster01"
}

