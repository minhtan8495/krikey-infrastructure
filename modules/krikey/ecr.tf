resource "aws_ecr_repository" "krikey_service" {
  name            = "krikey/service-${var.environment}"

  image_scanning_configuration {
    scan_on_push  = true
  }
}

resource "aws_ecr_lifecycle_policy" "maximum_images_krikey_service" {
  repository      = aws_ecr_repository.krikey_service.name

  policy          = <<EOF
    {
      "rules": [
        {
          "rulePriority": 1,
          "description": "Keep 5 most recent images",
          "selection": {
            "tagStatus": "untagged",
            "countType": "imageCountMoreThan",
            "countNumber": 5
          },
          "action": {
            "type": "expire"
          }
        }
      ]
    }
  EOF
}
