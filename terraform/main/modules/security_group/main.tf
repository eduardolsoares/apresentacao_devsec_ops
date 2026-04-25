resource "aws_security_group" "webserver_sg" {
  name        = "webserver-security-group"
  description = "Security group for webserver allowing HTTP traffic"
  vpc_id      = var.vpc_id

  # tfsec:ignore:aws-ec2-no-public-ingress-sgr
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP traffic from anywhere"
  }

  # tfsec:ignore:aws-ec2-no-public-ingress-sgr
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS traffic from anywhere"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
    description = "Allow SSH from internal network only"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/8"]
    description = "Allow all outbound traffic to internal network only"
  }

  tags = {
    Name = "WebServerSG"
  }
}