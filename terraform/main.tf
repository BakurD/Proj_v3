provider "aws" {}

module "Remote_State" {
  source = "./s3"

  bucket_name = "remote-state-bakur-outfit-fisting"

  tags = {
    "Name" = "Remote_State"
    "Owner" = "Bakur DevOps"
  }
}
# terraform {
#   backend "s3" {
#     bucket = "remote-state-bakur-outfit"
#   }
# }
module "Infrastructure" {
  source = "./infrastructure"
  vpc_cidr_block = "10.0.0.0/16"
  public_subnet_cidr = [
    "10.0.11.0/24",
    "10.0.21.0/24"
  ]
  private_subnet = "10.0.12.0/24"
  min_size = "3"
  max_size = "3"
  min_elb = "3"
  vpc_tags = {
    "Owner" = "Bakurevych"
  }
}