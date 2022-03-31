module "vpc" {
  	source  = "terraform-aws-modules/vpc/aws"
  	version = "3.13.0"

	# we can get the attributes of the module from the module source on https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
	name = "${var.environment}-vpc"
	cidr = "10.10.0.0/16"
	enable_dns_hostnames = true
	enable_dns_support = true

	azs             = ["us-east-1a", "us-east-1b"]
	public_subnets  = ["10.10.0.0/24", "10.10.1.0/24"]

  	# private_subnets = ["10.10.2.0/24", "10.10.3.0/24"]
	# enable_nat_gateway = true
	# single_nat_gateway = true # it should be false in production for high availability

	# Database subnets
	# create_database_subnet_group = true
	# create_database_subnet_route_table = true
	# database_subnets = ["10.10.4.0/24", "10.10.5.0/24"]
	# create_database_nat_gateway_route = false
	# create_database_internet_gateway_route = false

	public_subnet_tags = {
		Type: "${var.environment}-public-subnets"
	}

	# private_subnet_tags = {
	# 	Type: "${var.environment}-private-subnets"
	# }

	# database_subnet_tags = {
	# 	Type: "${var.environment}-database-subnets"
	# }

	tags = {
		Owner: "Gabriel",
		Environment: "${var.environment}"
	}

	vpc_tags = {
		Name: "${var.environment}-vpc"
		Terraform = "true"
	}
}

# VPC ID
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

# VPC CIDR blocks
output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

# VPC Public Subnets
output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

# VPC Private Subnets
# output "private_subnets" {
#   description = "List of IDs of private subnets"
#   value       = module.vpc.private_subnets
# }

# VPC NAT gateway Public IP
# output "nat_public_ips" {
#   description = "List of public Elastic IPs created for AWS NAT Gateway"
#   value       = module.vpc.nat_public_ips
# }

# VPC AZs
output "azs" {
  description = "A list of availability zones spefified as argument to this module"
  value       = module.vpc.azs
}