 resource "aws_iam_role" "flow_logs" {
  name = "vpc-flow-logs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "vpc-flow-logs.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}
resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
    name = "/aws/vpc/flow-logs"
    retention_in_days = 7
}

resource "aws_iam_role_policy" "flow_logs" {
  name = "vpc-flow-logs-policy"
  role = aws_iam_role.flow_logs.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams"
      ]
      Resource = "${aws_cloudwatch_log_group.vpc_flow_logs.arn}:*"
    }]
  })
}

resource "aws_flow_log" "primary" {
    vpc_id = aws_vpc.primary.id
    traffic_type = "ALL"
    log_destination_type = "cloud-watch-logs"
    log_destination = aws_cloudwatch_log_group.vpc_flow_logs.arn
    iam_role_arn = aws_iam_role.flow_logs.arn
}
resource "aws_flow_log" "secondary" {
    vpc_id = aws_vpc.secondary.id
    traffic_type = "ALL"
    log_destination_type = "cloud-watch-logs"
    log_destination = aws_cloudwatch_log_group.vpc_flow_logs.arn
    iam_role_arn = aws_iam_role.flow_logs.arn
  
}
resource "aws_flow_log" "security" {
    vpc_id = aws_vpc.security.id
    traffic_type = "ALL"
    log_destination_type = "cloud-watch-logs"
    log_destination = aws_cloudwatch_log_group.vpc_flow_logs.arn
    iam_role_arn = aws_iam_role.flow_logs.arn
  
}