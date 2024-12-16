###########
#### ECR
###########
resource "aws_ecr_repository" "investpro_api" {
  name = "${local.name}-api"

  image_scanning_configuration {
    scan_on_push = false
  }

  tags = merge(local.tags, {})
}

###########
#### EC2
###########
resource "aws_security_group" "docker_backend_sg" {
  name        = "${local.name}-security-group"
  description = "Security group for Docker backend container"

  vpc_id = module.vpc.vpc_id

  # Inbound HTTP traffic
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Inbound HTTPS traffic
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH access
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = [
      "185.153.176.28/32" # My IP
    ]
  }

  # Custom application port (adjust as needed)
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.tags, {
    Name = "${local.name}-sg"
  })
}

# IAM Role for ECR Access
resource "aws_iam_role" "ecr_access_role" {
  name = "${local.name}-ecr-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecr_access_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.ecr_access_role.name
}

# IAM Instance Profile
resource "aws_iam_instance_profile" "ecr_instance_profile" {
  name = "${local.name}-ecr-instance-profile"
  role = aws_iam_role.ecr_access_role.name
}

# Find the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# EC2 Instance
resource "aws_instance" "docker_backend" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t2.micro"
  key_name      = "gbrotas-keypair"

  subnet_id = module.vpc.public_subnets[0]

  vpc_security_group_ids = [module.vpc.default_security_group_id, aws_security_group.docker_backend_sg.id]

  iam_instance_profile = aws_iam_instance_profile.ecr_instance_profile.name

  # Use the VPC's DNS hostnames feature
  associate_public_ip_address = true

  # User data script to install Docker and Docker Compose
  user_data = <<-EOF
    #!/bin/bash
    set -e

    # Update system packages
    yum update -y

    # Install Docker
    yum install -y docker
    systemctl start docker
    systemctl enable docker

    # Add ec2-user to docker group
    usermod -aG docker ec2-user

    # Configure AWS ECR login
    aws ecr get-login-password --region ${local.region} | docker login --username AWS --password-stdin $(aws sts get-caller-identity --query Account --output text).dkr.ecr.${local.region}.amazonaws.com
    
    # Optional: Install additional tools
    yum install amazon-linux-extras install epel -y
    yum install -y git aws-cli certbot-apache nginx certbot python-certbot-nginx

    # Reboot to ensure all changes take effect
    reboot
    EOF

  tags = merge(local.tags, {
    Name = "${local.name}-instance"
  })

  root_block_device {
    volume_type = "gp3"
    volume_size = 30 # 30GB should be sufficient for most backend deployments
    encrypted   = true
  }
}

###########
#### Route53
###########
resource "aws_route53_record" "docker_backend_dns" {
  zone_id = "Z01896533GTRALFMTN5Q2"
  name    = "myportfolio-api.brottas.com"
  type    = "A"
  ttl     = 300
  records = [aws_instance.docker_backend.public_ip]
}

###########
#### RDS
###########
resource "aws_security_group" "rds_sg" {
  name        = "${local.name}-rds-sg"
  description = "Security group for RDS instance"

  vpc_id = module.vpc.vpc_id

  # Inbound PostgreSQL traffic from EC2 instance security group
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.docker_backend_sg.id]
  }

  # Outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.tags, {
    Name = "${local.name}-rds-sg"
  })
}

resource "aws_db_subnet_group" "default" {
  name       = "${local.name}-db-subnet-group"
  subnet_ids = module.vpc.database_subnets

  tags = merge(local.tags, {
    Name = "${local.name}-db-subnet-group"
  })
}

resource "aws_db_parameter_group" "custom_pg" {
  name        = "${local.name}-pg"
  family      = "postgres16"
  description = "Custom parameter group for PostgreSQL 16"

  parameter {
    name  = "rds.force_ssl"
    value = "1"
  }

  tags = merge(local.tags, {
    Name = "${local.name}-pg"
  })
}

resource "aws_db_instance" "default" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "postgres"
  engine_version         = "16.3"
  instance_class         = "db.t4g.micro"
  username               = "postgres"
  db_subnet_group_name   = aws_db_subnet_group.default.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  parameter_group_name   = aws_db_parameter_group.custom_pg.name
  skip_final_snapshot    = true

  db_name  = "myportfolio"
  password = var.db_password

  tags = merge(local.tags, {
    Name = "${local.name}-rds"
  })
}
