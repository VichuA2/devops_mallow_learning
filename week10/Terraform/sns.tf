resource "aws_sns_topic" "alerts" {
  name = "vishnu-terraform-alert"
}

resource "aws_sns_topic_subscription" "email_alert" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = "vishnuarumugam0207@gmail.com"
}
