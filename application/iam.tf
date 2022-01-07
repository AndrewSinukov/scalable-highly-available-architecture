resource "aws_iam_role" "ec2_iam_role" {
  name               = "EC2-Iam_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
   {
     "Effect": "Allow",
     "Principal": {
       "Service": ["ecs.amazonaws.com", "application-autoscaling.amazonaws.com"]
     },
     "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "ec2_iam_role_policy" {
  name   = "EC2-Iam-Policy"
  role   = aws_iam_role.ec2_iam_role.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
   {
     "Effect": "Allow",
     "Action": [
        "ec2:*",
        "elasticloadbalancing:*",
        "cloudwatch:*",
        "logs:*"
      ]
     "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "EC2-Iam-instance-profile"
  role = aws_iam_role.ec2_iam_role.name
}

#???!
data "aws_ami" "launch_configuration_ami" {
  most_recent = true
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
  owners = []
}
