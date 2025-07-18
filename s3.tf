resource "aws_s3_bucket" "photo_bucket" {
    bucket = var.bucket_name
    force_destroy = true
}

resource "aws_s3_object" "photo" {
    bucket = aws_s3_bucket.photo_bucket.id
    key = "image.jpg"
    source = "image.jpg"
    content_type = "image/jpeg"
}


resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "cdn-oac"
  description                       = "OAC for private S3 access"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}


resource "aws_s3_bucket_policy" "allow_cloudfront" {
  bucket = aws_s3_bucket.photo_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "AllowCloudFrontRead",
        Effect    = "Allow",
        Principal = {
          Service = "cloudfront.amazonaws.com"
        },
        Action    = "s3:GetObject",
        Resource  = "arn:aws:s3:::${aws_s3_bucket.photo_bucket.id}/*",
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.cdn.arn
          }
        }
      }
    ]
  })

  depends_on = [aws_cloudfront_distribution.cdn]
}



