resource "aws_s3_bucket" "application" {
  bucket = local.application_bucket_name
}