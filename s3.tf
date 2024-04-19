resource "aws_s3_bucket" "dashboard_reports_bucket" {
  bucket = local.reports_bucket_name
}