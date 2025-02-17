terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.87.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "web" {
  ami           = "ami-0cb91c7de36eed2cb"
  instance_type = "t3.micro"
  tags = {
    Name = "Blah"
  }
}
