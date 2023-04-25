resource "aws_s3_bucket" "remote-state-bakur-outfit" {
    bucket = var.bucket_name
    acl = "private"
    versioning {
      enabled = true
    }
    tags = var.tags
}
