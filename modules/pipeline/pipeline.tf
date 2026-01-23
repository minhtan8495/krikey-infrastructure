resource "aws_codebuild_project" "krikey_service_codebuild_project" {
  name                                          = "krikey-service-codebuild-project-${var.environment}"
  badge_enabled                                 = false
  build_timeout                                 = 60
  queued_timeout                                = 480

  service_role                                  = aws_iam_role.krikey_service_codebuild_project_role.arn

  tags = {
    Environment                                 = var.environment
  }

  artifacts {
    encryption_disabled                         = false
    # name                                      = "container-app-code-${var.env}"
    # override_artifact_name                    = false
    packaging                                   = "NONE"
    type                                        = "CODEPIPELINE"
  }

  environment {
    compute_type                                = "BUILD_GENERAL1_SMALL"
    image                                       = "aws/codebuild/standard:6.0"
    image_pull_credentials_type                 = "CODEBUILD"
    privileged_mode                             = true
    type                                        = "LINUX_CONTAINER"
  }

  logs_config {
    cloudwatch_logs {
      status                                    = "ENABLED"
    }

    s3_logs {
      encryption_disabled                       = false
      status                                    = "DISABLED"
    }
  }

  source {
    # buildspec                                 = data.template_file.buildspec.rendered
    git_clone_depth                             = 0
    insecure_ssl                                = false
    report_build_status                         = false
    type                                        = "CODEPIPELINE"
  }
}

resource "aws_codepipeline" "krikey_service_codepipeline" {
  name                                          = "krikey-service-pipeline-${var.environment}"
  role_arn                                      = aws_iam_role.krikey_service_codepipeline_role.arn

  tags = {
    Environment                                 = var.environment
  }

  artifact_store {
    location                                    = aws_s3_bucket.krikey_service_artifact_store.bucket
    type                                        = "S3"
  }

  stage {
    name = "Source"

    action {
      name                                      = "Source"
      category                                  = "Source"
      owner                                     = "AWS"
      provider                                  = "CodeStarSourceConnection"
      version                                   = "1"
      output_artifacts                          = [
        "SourceArtifact"
      ]
      run_order                                 = "1"

      configuration = {
        ConnectionArn                           = var.codestar_connection_arn
        FullRepositoryId                        = var.backend_repository_id
        BranchName                              = var.backend_branch_name
        OutputArtifactFormat                    = "CODE_ZIP"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name                                      = "Build"
      category                                  = "Build"
      configuration                             = {
        "EnvironmentVariables" = jsonencode(
          [
            {
              name                              = "environment"
              type                              = "PLAINTEXT"
              value                             = var.environment
            },
            {
              name                              = "AWS_DEFAULT_REGION"
              type                              = "PLAINTEXT"
              value                             = var.region
            },
            {
              name                              = "AWS_ACCOUNT_ID"
              type                              = "PARAMETER_STORE"
              value                             = "ACCOUNT_ID"
            },
            {
              name                              = "IMAGE_REPO_NAME"
              type                              = "PLAINTEXT"
              value                             = var.repo_name
            },
            {
              name                              = "IMAGE_TAG"
              type                              = "PLAINTEXT"
              value                             = "latest"
            },
            {
              name                              = "CONTAINER_NAME"
              type                              = "PLAINTEXT"
              value                             = var.container_name
            },
            {
              name                              = "DOCKER_USER"
              type                              = "PARAMETER_STORE"
              value                             = "DOCKER_USER"
            },
            {
              name                              = "DOCKER_PASSWORD"
              type                              = "PARAMETER_STORE"
              value                             = "DOCKER_PASSWORD"
            }
          ]
        )
        "ProjectName"                           = aws_codebuild_project.krikey_service_codebuild_project.name
      }
      input_artifacts = [
        "SourceArtifact",
      ]
      output_artifacts = [
        "BuildArtifact",
      ]
      owner                                     = "AWS"
      provider                                  = "CodeBuild"
      run_order                                 = 1
      version                                   = "1"
    }
  }

  stage {
    name = "Deploy"

    action {
      name                                      = "Deploy"
      category                                  = "Deploy"
      configuration = {
        "ClusterName"                           = var.aws_ecs_cluster_name
        "ServiceName"                           = var.aws_ecs_service_name
        "FileName"                              = "imagedefinitions.json"
        #"DeploymentTimeout" = "15"
      }
      input_artifacts = [
        "BuildArtifact",
      ]
      output_artifacts                          = []
      owner                                     = "AWS"
      provider                                  = "ECS"
      run_order                                 = 1
      version                                   = "1"
    }
  }
}

resource "aws_codebuild_project" "krikey_frontend_codebuild_project" {
  name                                          = "krikey-frontend-codebuild-project-${var.environment}"
  badge_enabled                                 = false
  build_timeout                                 = 60
  queued_timeout                                = 480

  service_role                                  = aws_iam_role.krikey_service_codebuild_project_role.arn

  tags = {
    Environment                                 = var.environment
  }

  artifacts {
    encryption_disabled                         = false
    # name                                      = "container-app-code-${var.env}"
    # override_artifact_name                    = false
    packaging                                   = "NONE"
    type                                        = "CODEPIPELINE"
  }

  environment {
    compute_type                                = "BUILD_GENERAL1_SMALL"
    image                                       = "aws/codebuild/standard:6.0"
    image_pull_credentials_type                 = "CODEBUILD"
    privileged_mode                             = true
    type                                        = "LINUX_CONTAINER"
  }

  logs_config {
    cloudwatch_logs {
      status                                    = "ENABLED"
    }

    s3_logs {
      encryption_disabled                       = false
      status                                    = "DISABLED"
    }
  }

  source {
    # buildspec                                 = data.template_file.buildspec.rendered
    git_clone_depth                             = 0
    insecure_ssl                                = false
    report_build_status                         = false
    type                                        = "CODEPIPELINE"
  }
}

resource "aws_codepipeline" "krikey_frontend_codepipeline" {
  name                                          = "krikey-frontend-pipeline-${var.environment}"
  role_arn                                      = aws_iam_role.krikey_service_codepipeline_role.arn

  tags = {
    Environment                                 = var.environment
  }

  artifact_store {
    location                                    = aws_s3_bucket.krikey_service_artifact_store.bucket
    type                                        = "S3"
  }

  stage {
    name = "Source"

    action {
      name                                      = "Source"
      category                                  = "Source"
      owner                                     = "AWS"
      provider                                  = "CodeStarSourceConnection"
      version                                   = "1"
      output_artifacts                          = [
        "SourceArtifact"
      ]
      run_order                                 = "1"

      configuration = {
        ConnectionArn                           = var.codestar_connection_arn
        FullRepositoryId                        = var.frontend_repository_id
        BranchName                              = var.frontend_branch_name
        OutputArtifactFormat                    = "CODE_ZIP"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name                                      = "Build"
      category                                  = "Build"
      configuration                             = {
        "EnvironmentVariables" = jsonencode(
          [
            {
              name                              = "environment"
              type                              = "PLAINTEXT"
              value                             = var.environment
            },
            {
              name                              = "AWS_DEFAULT_REGION"
              type                              = "PLAINTEXT"
              value                             = var.region
            },
            {
              name                              = "AWS_ACCOUNT_ID"
              type                              = "PARAMETER_STORE"
              value                             = "ACCOUNT_ID"
            },
            {
              name                              = "BUCKET_NAME"
              type                              = "PLAINTEXT"
              value                             = var.krikey_frontend_bucket_name
            },
            {
              name                              = "CLOUDFRONT_ID"
              type                              = "PLAINTEXT"
              value                             = var.krikey_cloudfront_id
            },
            {
              name                              = "NODE_OPTIONS"
              type                              = "PLAINTEXT"
              value                             = "--max-old-space-size=8192"
            }
          ]
        )
        "ProjectName"                           = aws_codebuild_project.krikey_frontend_codebuild_project.name
      }
      input_artifacts = [
        "SourceArtifact",
      ]
      # output_artifacts = [
        # "BuildArtifact",
      # ]
      owner                                     = "AWS"
      provider                                  = "CodeBuild"
      run_order                                 = 1
      version                                   = "1"
    }
  }
}
