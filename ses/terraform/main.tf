variable "admin_email" {
  type = string
}
variable "aws_access_key_id" {
  type = string
  sensitive = true
}
variable "aws_region" {
  type = string
  sensitive = true
}
variable "aws_secret_access_key" {
  type = string
  sensitive = true
}
variable "cloud_gov_email_notification_topic_arn" {
  type = string
}
variable "cloud_gov_environment" {
  type = string
}
variable "cloud_gov_slack_notification_topic_arn" {
  type = string
}
variable "dmarc_report_aggregate_recipients" {
  type = list(string)
}
variable "dmarc_report_failure_recipients" {
  type = list(string)
}
variable "domain" {
  type = string
}
variable "enable_feedback_notifications" {
  type = bool
}
variable "instance_id" {
  type = string
}
variable "mail_from_subdomain" {
  type = string
}

locals {
  service_offering_name = "aws-ses"
  service_plan_name = "base"
}

module "provision" {
  source = "git::https://github.com/cloud-gov/csb//brokerpaks/aws-ses/terraform/provision?ref=ses-topic"

  service_offering_name = local.service_offering_name
  service_plan_name = local.service_plan_name
  default_domain = "appmail.agency.gov"
  context = {}
  labels = {}

  admin_email = var.admin_email
  aws_access_key_id_commercial = var.aws_access_key_id
  aws_access_key_id_govcloud = var.aws_access_key_id
  aws_region_commercial = var.aws_region
  aws_region_govcloud = var.aws_region
  aws_secret_access_key_commercial = var.aws_secret_access_key
  aws_secret_access_key_govcloud = var.aws_secret_access_key
  cloud_gov_email_notification_topic_arn = var.cloud_gov_email_notification_topic_arn
  cloud_gov_environment = var.cloud_gov_environment
  cloud_gov_slack_notification_topic_arn = var.cloud_gov_slack_notification_topic_arn
  dmarc_report_aggregate_recipients = var.dmarc_report_aggregate_recipients
  dmarc_report_failure_recipients = var.dmarc_report_failure_recipients
  domain = var.domain
  enable_feedback_notifications = var.enable_feedback_notifications
  instance_id = var.instance_id
  mail_from_subdomain = var.mail_from_subdomain
}

module "bind" {
  source = "git::https://github.com/cloud-gov/csb//brokerpaks/aws-ses/terraform/bind?ref=ses-topic"

  context = {}
  source_ips = []

  aws_access_key_id_govcloud = var.aws_access_key_id
  aws_region_govcloud = var.aws_region
  aws_secret_access_key_govcloud = var.aws_secret_access_key
  binding_id = var.instance_id
  bounce_topic_arn = module.provision.bounce_topic_arn
  cloud_gov_environment = var.cloud_gov_environment
  complaint_topic_arn = module.provision.complaint_topic_arn
  configuration_set_arn = module.provision.configuration_set_arn
  domain_arn = module.provision.domain_arn
  instance_id = var.instance_id
  region = var.aws_region
  service_offering_name = local.service_offering_name
  service_plan_name = local.service_plan_name
  user_name = var.instance_id
}

output "smtp_password" {
  value = module.bind.smtp_password
  sensitive = true
}

output "smtp_user" {
  value = module.bind.smtp_user
  sensitive = true
}

output "smtp_server" {
  value = module.bind.smtp_server
  sensitive = true
}

output "aws_access_key_id" {
  value = module.bind.aws_access_key_id
  sensitive = true
}

output "aws_secret_access_key" {
  value = module.bind.aws_secret_access_key
  sensitive = true
}

output "aws_region" {
  value = var.aws_region
  sensitive = true
}

output "instructions" {
  value = module.provision.instructions
}

output "required_records" {
  value = module.provision.required_records
}
