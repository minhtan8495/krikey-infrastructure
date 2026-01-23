resource "aws_s3_bucket" "krikey_frontend_bucket" {
  bucket                            = "krikey.builds.${var.environment}"

  tags = {
    Name                            = "Krikey Frontend Builds"
    Environment                     = var.environment
  }
}

resource "aws_s3_bucket_public_access_block" "krikey_frontend_bucket_public_access" {
  bucket                            = aws_s3_bucket.krikey_frontend_bucket.id

  block_public_acls                 = false
  block_public_policy               = false
  ignore_public_acls                = false
  restrict_public_buckets           = false
}

resource "aws_s3_bucket_ownership_controls" "krikey_fe_bucket_ownership" {
  bucket                            = aws_s3_bucket.krikey_frontend_bucket.id

  rule {
    object_ownership                = "ObjectWriter"
  }

  depends_on = [ aws_s3_bucket_public_access_block.krikey_frontend_bucket_public_access ]
}

resource "aws_s3_bucket_acl" "krikey_fe_bucket_acl" {
  bucket                            = aws_s3_bucket.krikey_frontend_bucket.id

  acl                               = "public-read"

  depends_on                        = [aws_s3_bucket_ownership_controls.krikey_fe_bucket_ownership]
}

resource "aws_s3_bucket_cors_configuration" "krikey_fe_bucket_cors" {
  bucket                            = aws_s3_bucket.krikey_frontend_bucket.id

  cors_rule {
    allowed_headers                 = ["*"]
    allowed_methods                 = ["GET", "POST", "PUT", "HEAD"]
    allowed_origins                 = ["*"]
    expose_headers                  = ["ETag"]
    max_age_seconds                 = 3000
  }
}

resource "aws_s3_bucket_policy" "krikey_fe_bucket_policy" {
  bucket                            = aws_s3_bucket.krikey_frontend_bucket.id

  policy                            = templatefile("templates/s3-policy.json", { bucket = "krikey.builds.${var.environment}" })

  depends_on = [ aws_s3_bucket_public_access_block.krikey_frontend_bucket_public_access ]
}

resource "aws_s3_bucket_website_configuration" "krikey_fe_bucket_website" {
  bucket                            = aws_s3_bucket.krikey_frontend_bucket.id

  index_document {
    suffix                          = "index.html"
  }

  error_document {
    key                             = "error.html"
  }
}
