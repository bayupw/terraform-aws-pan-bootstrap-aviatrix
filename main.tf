data "aws_region" "current" {}

# Create random string
resource "random_string" "this" {
  count = var.random_suffix ? 1 : 0

  length  = var.random_string_length
  number  = true
  special = false
  upper   = false
}

# ---------------------------------------------------------------------------------------------------------------------
# S3 Bucket
# ---------------------------------------------------------------------------------------------------------------------

# Create an S3 Bucket
resource "aws_s3_bucket" "this" {
  bucket        = local.bootstrap_bucket
  force_destroy = true

  tags = {
    Name = local.bootstrap_bucket
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

# Create bootstrap folders
resource "aws_s3_object" "bootstrap_folders" {
  for_each = local.bootstrap_folders

  bucket = aws_s3_bucket.this.id
  key    = each.key
}

# Upload bootstrap.xml
resource "aws_s3_object" "bootstrap_xml" {
  bucket = aws_s3_bucket.this.id
  key    = "config/bootstrap.xml"
  content = templatefile("${path.module}/bootstrap.xml",
    {
      "config_version"           = var.config_version,
      "detail_version"           = var.detail_version,
      "admin_user"               = var.admin_user,
      "admin_password_phash"     = var.admin_password_phash,
      "admin_public_key"         = var.admin_public_key,
      "admin_api_user"           = var.admin_api_user,
      "admin_api_profile_name"   = var.admin_api_profile_name,
      "admin_api_password_phash" = var.admin_api_password_phash
    }
  )

  depends_on = [aws_s3_object.bootstrap_folders]
}

# Upload init-cfg.txt
resource "aws_s3_object" "init_cfg_txt" {
  bucket = aws_s3_bucket.this.id
  key    = "config/init-cfg.txt"
  source = "${path.module}/init-cfg.txt"

  depends_on = [aws_s3_object.bootstrap_folders]
}

# ---------------------------------------------------------------------------------------------------------------------
# AWS IAM
# ---------------------------------------------------------------------------------------------------------------------

# Create IAM Role
resource "aws_iam_role" "this" {
  name               = local.aws_iam_role
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# Create IAM Policy
resource "aws_iam_policy" "this" {
  name        = local.aws_iam_policy
  description = local.aws_iam_policy

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": [
                "${aws_s3_bucket.this.arn}"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "${aws_s3_bucket.this.arn}"
            ]
        }
    ]
}
EOF
}

# Attach IAM Policy ARN to IAM Role
resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn

  depends_on = [aws_s3_object.bootstrap_xml,aws_s3_object.init_cfg_txt]
}

# Create IAM Instance Profile
# Note: name must be same as IAM role, else firewall instance will throw an error 'No Instance profile found for IAM role name'
resource "aws_iam_instance_profile" "this" {
  name = local.aws_iam_role
  role = aws_iam_role.this.name
  depends_on = [aws_s3_object.bootstrap_xml,aws_s3_object.init_cfg_txt]
}