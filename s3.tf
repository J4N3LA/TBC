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




resource "aws_s3_bucket_public_access_block" "no_block" {
  bucket = aws_s3_bucket.photo_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.photo_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "arn:aws:s3:::${aws_s3_bucket.photo_bucket.id}/*"
      }
    ]
  })
}



