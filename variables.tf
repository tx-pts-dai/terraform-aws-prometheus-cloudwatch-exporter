variable "helm_additional_values" {
  description = "Additional list of values for Helm Release"
  type        = list(string)
  default     = []
}

variable "iam_role_additional_policies" {
  description = "Map ('name' => 'policy_arn') of additional policies to attach to the IAM Role assumed by the CloudWatch Exporter Pod"
  type        = map(string)
  default     = {}
}

variable "namespace" {
  description = "Kubernetes namespace where the Helm Release will be installed to"
  type        = string
  default     = "prometheus"
}

variable "chart_version" {
  description = "prometheus-cloudwatch-exporter chart version to be installed. Chart taken from https://github.com/prometheus-community/helm-charts"
  type        = string
}

variable "cluster_oidc_provider_arn" {
  description = "ARN of the EKS OpenIDConnect provider. Required for IAM Role for Service Account authentication."
  type        = string
}

variable "release_name_prefix" {
  description = "Name prefix of the Helm Release that will be created. This name is used to name the IAM role and Service Account that will be created."
  type        = string
  default     = "prometheus-cloudwatch-exporter"
}
