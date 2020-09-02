data "aws_iam_policy_document" "assume_role_policy_document" {
  version = "2012-10-17"

  statement {
    effect = "Allow"

    condition {
      test = "StringEquals"
      values = [
        "au:000000000031153D"]
      variable = "sts:ExternalId"
    }
    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::926226587429:root"
      ]
    }
  }
}

data "aws_iam_policy_document" "bucket_access_policy_document" {
  for_each = var.bucket_names

  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:ListBucketVersions",
      "s3:ListBucket",
    ]
    resources = [
      "arn:aws:s3:::${each.key}",
      "arn:aws:s3:::${each.key}/*"
    ]
  }
}

resource "aws_iam_role" "sumologic_iam_role" {
  name = "SumologicIamRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_document.json
}

resource "aws_iam_role_policy" "sumologic_iam_role_policy" {
  for_each = var.bucket_names

  name = "${each.key}-BucketAccessPolicy"
  role = aws_iam_role.sumologic_iam_role.id
  policy = data.aws_iam_policy_document.bucket_access_policy_document[each.key].json
}
