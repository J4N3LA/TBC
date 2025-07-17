output "webserver1_ip" {
  value = aws_instance.webserver1.public_ip
}

output "webserver2_ip" {
  value = aws_instance.webserver2.public_ip
}

output "elastic_ip" {
  value = aws_eip.web_ip.public_ip
}

output "s3_url" {
  value = "https://${var.bucket_name}.s3.amazonaws.com/photo.jpg"
}

output "cloudfront_url" {
  value = "https://${aws_cloudfront_distribution.cdn.domain_name}"
}

