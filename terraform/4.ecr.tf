resource "aws_ecr_repository" "api_boilerplate_repository" {
    name = "${var.environment}-api-boilerplate-repository"

    image_scanning_configuration {
        scan_on_push = true
    }

    tags = {
        Environment = "${var.environment}"
        Framework = "Terraform"
    }
}

output "ecr_repository_arn" {
    value = aws_ecr_repository.api_boilerplate_repository.arn
}

output "repository_url" {
    value = aws_ecr_repository.api_boilerplate_repository.repository_url
}
