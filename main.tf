resource "aws_ecr_repository" "this" {
  name = var.name
  image_tag_mutability = var.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = false
  }

  tags = {
    Name = var.name
  }
}

resource "aws_ecr_lifecycle_policy" "lifecycle_policy" {
  count = length(var.lifecycle_rules) > 0 ? 1 : 0
  repository = aws_ecr_repository.this.name
  policy     = data.template_file.lifecycle_policy.rendered
}

data "template_file" "lifecycle_policy"{
  template = file("${path.module}/files/lifecycle_policy.tpl")
  vars = {
    rules = join(",", var.lifecycle_rules)
  }
}

resource "aws_ecr_repository_policy" "this" {
  repository = aws_ecr_repository.this.name
  policy     = data.aws_iam_policy_document.this.json
}

data "aws_iam_policy_document" "this" {
  statement {
    sid = "AllowAllOperationsToAdmins"

    actions = [
      "ecr:*"
    ]

    principals {
      type        = "AWS"
      identifiers = var.admin_arns
    }
  }

  statement {
    sid = "AllowReadOperations"

    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
      "ecr:GetLifecyclePolicy",
      "ecr:GetLifecyclePolicyPreview",
      "ecr:ListTagsForResource",
      "ecr:DescribeImageScanFindings"
    ]

    principals {
      type        = "AWS"
      identifiers = distinct(compact(concat(var.readwrite_arns, var.readonly_arns)))
    }
  }

  statement {
    sid = "AllowWriteOperations"

    actions = [
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:PutImage"
    ]

    principals {
      type        = "AWS"
      identifiers = var.readwrite_arns
    }
  }
}
