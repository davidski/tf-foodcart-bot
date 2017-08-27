provider "aws" {
  region  = "${var.aws_region}"
  profile = "${var.aws_profile}"

  assume_role {
    role_arn = "arn:aws:iam::754135023419:role/administrator-service"
  }
}

# Data source for the availability zones in this zone
data "aws_availability_zones" "available" {}

# Data source for current account number
data "aws_caller_identity" "current" {}

# Data source for main infrastructure state
data "terraform_remote_state" "main" {
  backend = "s3"

  config {
    bucket  = "infrastructure-severski"
    key     = "terraform/infrastructure.tfstate"
    region  = "us-west-2"
    encrypt = "true"
  }
}

/*
  -------------
  | IAM Roles |
  -------------
*/

resource "aws_iam_role" "lambda_worker" {
  name_prefix = "foodcart-bot"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_worker_logs" {
  role       = "${aws_iam_role.lambda_worker.id}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

output "lambda_role_arn" {
  value = "${aws_iam_role.lambda_worker.arn}"
}

/*
  ----------------------------
  | Schedule Lambda Function |
  ----------------------------
*/

resource "aws_cloudwatch_event_rule" "default" {
  name                = "foodcart_bot_trigger"
  description         = "Trigger Foodcart-bot Lambda at 12:00 UTC every weekday"
  schedule_expression = "cron(0 12 ? * MON-FRI *)"
}

resource "aws_cloudwatch_event_target" "default" {
  rule      = "${aws_cloudwatch_event_rule.default.name}"
  target_id = "TriggerFoodcartBot"
  arn       = "${aws_lambda_function.foodcart_bot.arn}"
}

resource "aws_lambda_permission" "from_cloudwatch_events" {
  statement_id  = "AllowExecutionFromCWEvents"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.foodcart_bot.arn}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.default.arn}"
}

resource "aws_lambda_function" "foodcart_bot" {
  s3_bucket        = "artifacts-severski"
  s3_key           = "lambdas/foodcart-bot.zip"
  source_code_hash = "FOO"
  function_name    = "foodcart_bot"
  role             = "${aws_iam_role.lambda_worker.arn}"
  handler          = "main.lambda_handler"
  description      = "Post today's food carts to Slack."
  runtime          = "python3.6"
  timeout          = 10

  environment {
    variables = {
      slack_webhook_url = "${var.slack_webhook}"
      attachment_color  = "${var.attachment_color}"
    }
  }

  tags {
    project    = "${var.project}"
    managed_by = "Terraform"
  }
}
