resource "aws_s3_bucket" "club-events-front-end" {
  bucket = "club-events-front-end"
  tags = {
    Name = "To be distributed by cloud front"
  }
}

resource "aws_s3_bucket_versioning" "club-events-front-end-ver" {
  bucket = aws_s3_bucket.club-events-front-end.bucket
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "club-events-front-end-lifecycle" {
  bucket = aws_s3_bucket.club-events-front-end.bucket

  rule {
    id = "TTL non current"

    noncurrent_version_expiration {
      noncurrent_days = 90
    }

    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "club-events-front-end-access" {
  bucket = aws_s3_bucket.club-events-front-end.bucket

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "club-events_s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.club-events-front-end.arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
  }
}

resource "aws_s3_bucket_policy" "example" {
  bucket = aws_s3_bucket.club-events-front-end.id
  policy = data.aws_iam_policy_document.club-events_s3_policy.json
}