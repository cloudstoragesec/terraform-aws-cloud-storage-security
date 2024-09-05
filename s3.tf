resource "aws_s3_bucket" "application" {
  bucket        = local.application_bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_policy" "application_bucket_policy" {
  bucket        = aws_s3_bucket.application.id
  policy        = data.aws_iam_policy_document.application_bucket_policy_document.json
}

data "aws_iam_policy_document" "application_bucket_policy_document" {
  statement {
    sid = "AllowSSLRequestsOnly"

    effect = "Deny"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:*"
    ]

    resources = [
      aws_s3_bucket.application.arn,
      "${aws_s3_bucket.application.arn}/*",
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"

      values = [
        "false"
      ]
    }
  }
}