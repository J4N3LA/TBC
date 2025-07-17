variable "aws_region" {
    default = "us-east-1"
}

variable "ami_id" {
    default = "ami-08c40ec9ead489470"
}

variable "key" {
    description = " key name"
    default = "ec2-key"
    }

variable "bucket_name" {
    description = "s3 name"
    default = "buckettbc1234"
    }
