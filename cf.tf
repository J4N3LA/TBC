resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "cdn-oac"
  description                       = "OAC for private S3 access"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "cdn" {
    origin {
        #domain_name = "${var.bucket_name}.s3.amazonaws.com"
        domain_name = aws_s3_bucket.photo_bucket.bucket_regional_domain_name

        origin_id = "s3-origin"
        s3_origin_config {
            origin_access_identity = ""
            }
            origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
        }

    enabled = true
    default_root_object = "image.jpg"

    default_cache_behavior {
        target_origin_id = "s3-origin"
        viewer_protocol_policy = "redirect-to-https"
        allowed_methods = ["GET", "HEAD"]
        cached_methods = ["GET", "HEAD"]
        forwarded_values {
            query_string = false
            cookies {
                forward = "none"
            }
         }
    }

    
    viewer_certificate {
        cloudfront_default_certificate = "true"
    }
    restrictions {
      geo_restriction {
         restriction_type = "none"
      } 
    }
    
    tags = {
        Name = "cdn"
    }

}

