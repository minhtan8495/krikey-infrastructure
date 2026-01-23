# Cloudfront CachePolicy
resource "aws_cloudfront_cache_policy" "krikey_fe_cache_policy" {
  name        = "Krikey-FE-cache-policy"
  comment     = "Krikey Frontend cache policy"

  default_ttl = 86400
  min_ttl     = 1
  max_ttl     = 31536000

  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "none"
    }
    headers_config {
      header_behavior = "none"
    }
    query_strings_config {
      query_string_behavior = "none"
    }

    enable_accept_encoding_brotli = true
    enable_accept_encoding_gzip = true
  }
}

resource "aws_cloudfront_distribution" "krikey_fe_distribution" {
  origin {
    domain_name                     = aws_s3_bucket_website_configuration.krikey_fe_bucket_website.website_endpoint
    origin_id                       = "S3-krikey.builds.${var.environment}"

    custom_origin_config {
      http_port                     = 80
      https_port                    = 443
      origin_protocol_policy        = "http-only"
      origin_ssl_protocols          = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  enabled                           = true
  is_ipv6_enabled                   = true
  default_root_object               = "index.html"

  custom_error_response {
    error_caching_min_ttl           = 0
    error_code                      = 404
    response_code                   = 200
    response_page_path              = "/index.html"
  }

  default_cache_behavior {
    allowed_methods                 = ["GET", "HEAD"]
    cached_methods                  = ["GET", "HEAD"]
    target_origin_id                = "S3-krikey.builds.${var.environment}"

    viewer_protocol_policy          = "redirect-to-https"
    # min_ttl                         = 31536000
    # default_ttl                     = 31536000
    # max_ttl                         = 31536000
    compress                        = true
    cache_policy_id                 = aws_cloudfront_cache_policy.krikey_fe_cache_policy.id
  }

  restrictions {
    geo_restriction {
      restriction_type              = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate  = true
    ssl_support_method              = "sni-only"
    minimum_protocol_version        = "TLSv1"
  }

  tags = {
    Name                            = "Krikey Frontend CloudFront"
    Environment                     = var.environment
  }
}
