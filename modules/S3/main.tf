# Locals to construct full bucket names
locals {
  primary_bucket_full = "${var.primary_bucket_name}-${var.primary_region}"
  replica_bucket_full = "${var.replica_bucket_name}-${var.replica_region}"
}


# IAM Role for replication
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "replication" {
  name               = "tf-iam-role-replication"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# Primary S3 bucket
resource "aws_s3_bucket" "primary_bucket" {
  provider = aws.primary
  bucket   = local.primary_bucket_full
}

resource "aws_s3_bucket_versioning" "primary_bucket_versioning" {
  provider = aws.primary
  bucket   = aws_s3_bucket.primary_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_acl" "primary_bucket_acl" {
  provider = aws.primary
  bucket   = aws_s3_bucket.primary_bucket.id
  acl      = "private"
}

# Replica S3 bucket
resource "aws_s3_bucket" "replica_bucket" {
  provider = aws.replica
  bucket   = local.replica_bucket_full
}

resource "aws_s3_bucket_versioning" "replica_bucket_versioning" {
  provider = aws.replica
  bucket   = aws_s3_bucket.replica_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# IAM policy for replication
data "aws_iam_policy_document" "replication_rules" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetReplicationConfiguration",
      "s3:ListBucket",
    ]
    resources = [aws_s3_bucket.primary_bucket.arn]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:GetObjectVersionForReplication",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionTagging",
    ]
    resources = ["${aws_s3_bucket.primary_bucket.arn}/*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:ReplicateObject",
      "s3:ReplicateDelete",
      "s3:ReplicateTags",
    ]
    resources = ["${aws_s3_bucket.replica_bucket.arn}/*"]
  }
}

resource "aws_iam_policy" "replication_policy" {
  name   = "tf-iam-role-policy-replication"
  policy = data.aws_iam_policy_document.replication_rules.json
}

resource "aws_iam_role_policy_attachment" "replication_attachment" {
  role       = aws_iam_role.replication.name
  policy_arn = aws_iam_policy.replication_policy.arn
}

# S3 Replication Configuration
resource "aws_s3_bucket_replication_configuration" "replication_config" {
  provider = aws.primary
  depends_on = [
    aws_s3_bucket_versioning.primary_bucket_versioning,
    aws_s3_bucket_versioning.replica_bucket_versioning
  ]

  role   = aws_iam_role.replication.arn
  bucket = aws_s3_bucket.primary_bucket.id

  rule {
    id     = "replication-rule"
    status = "Enabled"

    filter {
      prefix = "" # replicate all objects
    }

    destination {
      bucket        = aws_s3_bucket.replica_bucket.arn
      storage_class = "STANDARD"
    }
  }
}
