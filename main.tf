terraform {
  required_version = ">= 1.3.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0"
    }
  }
}

locals {
  cloudwatch_exporter_chart_name = "prometheus-cloudwatch-exporter"
  release_name                   = "${var.release_name_prefix}-${random_id.suffix.hex}"
}

resource "random_id" "suffix" {
  # random enough to allow for multiple instances of cloudwatch exporter in the same cluster
  byte_length = 2
}

module "this" {
  source  = "aws-ia/eks-blueprints-addon/aws"
  version = "~> 1.0"

  repository    = "https://prometheus-community.github.io/helm-charts"
  chart         = local.cloudwatch_exporter_chart_name
  chart_version = var.chart_version
  name          = local.release_name
  namespace     = var.namespace # Same namespace as other Prometheus exporters

  values = concat(
    [templatefile("${path.module}/config/helm_values/cloudwatch-exporter.yaml", {
      service_account_name = local.release_name
      iam_role_arn         = module.this.iam_role_arn
    })],
    var.helm_additional_values
  )
  lint = true # To be tested. "Runs helm chart linter at terraform plan time"

  create_role = true
  role_name   = local.release_name
  role_policies = merge({
    cloudwatch-exporter = aws_iam_policy.this.arn
  }, var.iam_role_additional_policies)
  create_policy = false # required if creating the policy (i.e. aws_iam_policy.this) outside the module

  oidc_providers = {
    this = {
      provider_arn    = var.cluster_oidc_provider_arn
      service_account = local.release_name
    }
  }
}

resource "aws_iam_policy" "this" {
  name   = "allow-cloudwatch-exporter-getting-metrics"
  policy = data.aws_iam_policy_document.this.json
}

data "aws_iam_policy_document" "this" {
  statement {
    effect = "Allow"
    actions = [
      "cloudwatch:ListMetrics",
      "cloudwatch:GetMetricStatistics",
      "cloudwatch:GetMetricData",
      "tag:GetResources",
    ]
    resources = ["*"]
  }
}
