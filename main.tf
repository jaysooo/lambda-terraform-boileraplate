
provider "aws" {
  region  = var.myaws_region
  version = "~> 4.0"
}

data "archive_file" "zip"{
  type = "zip"
  source_file = "./lambda_function/mylambda.py"
  output_path = "./lambda_function/mylambda.zip"
}

data "aws_iam_policy_document" "policy" {
  statement {
    sid    = ""
    effect = "Allow"
    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda"{
  name = "my_terraform_lambda_role"
  assume_role_policy = data.aws_iam_policy_document.policy.json
}

resource "aws_lambda_function" "lambda"{
  function_name = var.lambda_name
  filename = data.archive_file.zip.output_path
  source_code_hash = data.archive_file.zip.output_base64sha256
  role = aws_iam_role.iam_for_lambda.arn
  handler = "mylambda.lambda_handler"
  runtime = "python3.9"
}