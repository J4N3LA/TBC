# 📦 TBC პრაქტიკული დავალება


## 📚 სარჩევი

- [Architecture](#architecture)
- [Infrastructure Details](#Infrastructure)
- [Variables](#variables)


## 🏗️ Architecture

- Diagram 
![Alt text](miro.png)

- EC2 instances - ჰოსტავენ სტატიკურ index.hmtl ფაილს apache2 სერვისის დახმარებით. index.html შეიცავს რეფერენს  Cloudfront-ის URL-ზე სურათის წამოსაღებად.
- S3 bucket - ადგილი სადაც სურათი ინახება, წვდომადია მხოლოდ CloudFront-დან (OAC)
- CloudFront - მოაქვს სურათი, ქეშავს და აწვდის ევბსერვერს
- Elastic IP - ქმნის სტატიკურ მისამართს ერთ-ერთი ვებსერვერისთვის.

## 🛠️ .tf ფაილები

- main.tf
  ქმნის ec2 რესურსებს, რომლების user_data პარამეტრის დახმარებით კონტეინერში აინსტალირებენ და სტარტავენ apache2 სერვისს და აგენერირებენ index.html ფაილს:
  
  ```
  user_data = <<-EOF
              #!/bin/bash
              set -x
              exec > /var/log/user-data.log 2>&1
              apt update -y
              apt install -y apache2
              mkdir -p /var/www/html
              echo "<html><body><h1>Web1</h1>
              <img src='https://${aws_cloudfront_distribution.cdn.domain_name}/image.jpg' width='300' >
              </body></html>" | tee /var/www/html/index.html > /dev/null
              chown www-data:www-data /var/www/html/index.html
              systemctl enable apache2
              systemctl start apache2
              EOF
  ```
  ქმნის elasticIP რესურს, რომელიც ებმება ვებსერვერ webserver1-ს. შესამაბისად ამ ვებსერვერს ენიჭება სტატიკური IP მისამართი.
  ```
  resource "aws_eip" "web_ip" {
    instance = aws_instance.webserver1.id
  }
  ```
- s3.tf
  ქმნის ბაკეტს სახელით photo-bucket და ტვირთავს სურათს
  ```
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
  ```
  ქმნის OAC (cdn-oac) და AC პოლიტიკას s3 რესურსზე წვომაზე cloudFront-დან
  ```
  resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "cdn-oac"
  description                       = "OAC for private S3 access"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
  }
  ```
  ```
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
  ```
  
- 1x S3 bucket
- 1x CloudFront distribution
- 1x Elastic IP
- Security Groups 
