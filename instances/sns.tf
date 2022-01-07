resource "aws_sns_topic" "public-autoscaling-alert-topic" {
  display_name = "Frontend-AutoScaling-Topic"
  name         = "Frontend-AutoScaling-Topic"
}

resource "aws_sns_topic_subscription" "public-autoscaling-email-subscription" {
  topic_arn = aws_sns_topic.public-autoscaling-alert-topic.arn
  protocol  = "email"
  endpoint  = var.sns_email
}

resource "aws_autoscaling_notification" "public-autoscaling-notification" {
  group_names = [aws_autoscaling_group.ec2_public_autoscaling_group.name]
  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR"
  ]
  topic_arn = aws_sns_topic.public-autoscaling-alert-topic.arn
}
