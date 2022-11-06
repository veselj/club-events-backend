locals {
  s3_bucket = aws_s3_bucket.club-events-front-end.bucket
  regional_name = aws_s3_bucket.club-events-front-end.bucket_regional_domain_name
  originId = "club-events-origin"
}

resource "aws_cloudfront_origin_access_control" "club-events-access" {
  name                              = "club-events-access"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

#data "aws_cloudfront_origin_access_identities" "dsc-events-identity" {
#  id = "E2IKI1KMU09S2H"
#}


resource "aws_cloudfront_distribution" "club-events-distribution" {
  origin {
    domain_name              = local.regional_name
    origin_access_control_id = aws_cloudfront_origin_access_control.club-events-access.id
    origin_id                = local.originId

#    s3_origin_config {
#      origin_access_identity = data.aws_cloudfront_origin_access_identities.dsc-events-identity.id
#    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "club-events-distribution"
  default_root_object = "index.html"


  aliases = ["dsc-events.janman.cc"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.originId

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 1800
    max_ttl                = 3600
  }

  # Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern     = "/content/immutable/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = local.originId

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 1800
    max_ttl                = 3600
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  # Cache behavior with precedence 1
  ordered_cache_behavior {
    path_pattern     = "/content/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.originId

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 1800
    max_ttl                = 3600
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE"]
    }
  }

  tags = {
    Environment = "production"
  }

  viewer_certificate {
    acm_certificate_arn = "arn:aws:acm:us-east-1:072103297669:certificate/ea7f9a5f-dad7-41fd-a44a-125e2272b48d"
    ssl_support_method = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}
