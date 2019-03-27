provider "aws" {
  region = "eu-west-1"
}

resource "aws_route53_zone" "helloclue-com" {
  name = "helloclue.com"
}
