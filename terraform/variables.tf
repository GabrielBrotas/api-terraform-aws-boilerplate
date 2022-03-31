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

variable "public_subnets" {
    description = "List of instance types to launch"
    type = list
    default = ["t2.micro", "t2.small", "t2.medium"]
}

variable "vpc_cidr" {
    description = "CIDR block for the VPC"
    type = string
}

variable "vpc_public_subnets_cidr" {
    description = "CIDR block for the Public Subnets"
    type = list
}

variable "vpc_private_subnets_cidr" {
    description = "CIDR block for the Private Subnets"
    type = list
}

variable "vpc_database_subnets_cidr" {
    description = "CIDR block for the Database Subnets"
    type = list
}