locals {
  ecs_krikey_service_container_definitions_environment = {
    APP_PORT = 3000

    APP_MAX_UPLOAD_LIMIT = "50mb"
    APP_MAX_PARAMETER_LIMIT = "5000"
    CORS_ENABLED = false

    API_PREFIX = "api"
  }

  ecs_krikey_service_container_secrets = {
    APP_ENV                                 = "appEnv"

    POSTGRES_HOST                           = "host"
    POSTGRES_PORT                           = "port"
    POSTGRES_DATABASE                       = "dbname"
    POSTGRES_USER                           = "username"
    POSTGRES_PASSWORD                       = "password"
  }

  // map to ECS Task Definition JSON helpers
  ecs_krikey_service_container_definitions_environment_json = join(",\n", formatlist(
    <<-EOF
    {
      "name": "%s",
      "value": "%s"
    }
    EOF
    ,
    keys(local.ecs_krikey_service_container_definitions_environment),
    values(local.ecs_krikey_service_container_definitions_environment)
  ))

  ecs_krikey_service_container_secrets_json = join(",\n", formatlist(
    <<-EOF
    {
      "name": "%s",
      "valueFrom": "${aws_secretsmanager_secret.krikey_secrets.arn}:%s::"
    }
    EOF
    ,
    keys(local.ecs_krikey_service_container_secrets),
    values(local.ecs_krikey_service_container_secrets)
  ))
}
