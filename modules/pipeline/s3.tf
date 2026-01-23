resource "aws_s3_bucket" "krikey_service_artifact_store" {
  bucket              = "krikey-service-pipeline-artifact-${var.environment}"

  tags = {
    Name              = "Codepipeline Artifact Store"
    Environment       = var.environment
  }
}

resource "aws_s3_bucket_ownership_controls" "krikey_service_artifact_ownership" {
  bucket = aws_s3_bucket.krikey_service_artifact_store.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "krikey_service_artifact_acl" {
  bucket = aws_s3_bucket.krikey_service_artifact_store.id

  acl    = "private"

  depends_on = [aws_s3_bucket_ownership_controls.krikey_service_artifact_ownership]
}
