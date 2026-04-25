resource "aws_vpc" "giropops_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "MinhaVPC"
  }
}

resource "aws_flow_log" "vpc_flow_log" {
  iam_role_arn    = aws_iam_role.flow_log_role.arn
  log_destination = aws_cloudwatch_log_group.vpc_flow_log.arn
  traffic_type    = "REJECT"
  vpc_id           = aws_vpc.giropops_vpc.id

  tags = {
    Name = "VPCFlowLog"
  }
}

resource "aws_iam_role" "flow_log_role" {
  name = "vpc-flow-log-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
      }
    ]
  })
}

#tfsec:ignore:aws-iam-no-policy-wildcards
resource "aws_iam_role_policy" "flow_log_policy" {
  name = "flow-log-policy"
  role = aws_iam_role.flow_log_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Effect = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_cloudwatch_log_group" "vpc_flow_log" {
  name              = "vpc-flow-log"
  kms_key_id        = aws_kms_key.flow_log_key.arn

  tags = {
    Name = "VPCFlowLogGroup"
  }
}

resource "aws_kms_key" "flow_log_key" {
  description             = "KMS key for VPC Flow Logs"
  deletion_window_in_days  = 10
  enable_key_rotation      = true

  tags = {
    Name = "flow-log-key"
  }
}

resource "aws_kms_alias" "flow_log_key_alias" {
  name          = "alias/vpc-flow-log-key"
  target_key_id = aws_kms_key.flow_log_key.key_id
}