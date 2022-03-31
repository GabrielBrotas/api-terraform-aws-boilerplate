variable "aws_region" {
    description = "Region in which AWS resources will be deployed"
    type = string
    default = "us-east-1"
}

variable "environment" {
    description = "Environment used as prefix"
    type = string
    default = "dev"
}

