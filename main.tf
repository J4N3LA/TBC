provider "aws" {
    region = var.aws_region 
}


resource "aws_instance" "webserver1" {
    ami = var.ami_id
    instance_type = "t2.micro"
    user_data_replace_on_change = true
    key_name = var.key
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

    tags = {
        Name = "webserver1"
    }
}

resource "aws_instance" "webserver2" {
    ami = var.ami_id
    instance_type = "t2.micro"
    key_name = var.key
    user_data_replace_on_change = true
    user_data = <<-EOF
              #!/bin/bash
              set -x
              exec > /var/log/user-data.log 2>&1
              apt update -y
              apt install -y apache2
              mkdir -p /var/www/html
              echo "<html><body><h1>Web2</h1>
              <img src='https://${aws_cloudfront_distribution.cdn.domain_name}/image.jpg' width='300' >
              </body></html>" | tee /var/www/html/index.html > /dev/null
              chown www-data:www-data /var/www/html/index.html
              systemctl enable apache2
              systemctl start apache2
              EOF


    tags = {
        Name = "webserver2"
    }
}

resource "aws_eip" "web_ip" {
    instance = aws_instance.webserver1.id
}
