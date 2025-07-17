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


