resource "aws_cloudfront_distribution" "cdn" {
    origin {
        domain_name = "${var.bucket_name}.s3.amazonaws.com"
        origin_id = "s3-origin"
        s3_origin_config {
            origin_access_identity = ""
            }
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

