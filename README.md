# Terraform AWS Prometheus CloudWatch Exporter

This module takes care of deploying CloudWatch Exporter (via the official [prometheus-cloudwatch-exporter Helm Chart](https://github.com/prometheus-community/helm-charts/blob/main/charts/prometheus-cloudwatch-exporter)) and configures the minimum AWS IAM permissions to get metrics. The authentication is done using OpenIDConnect and [IAM Role for Service Account](https://aws.amazon.com/blogs/opensource/introducing-fine-grained-iam-roles-service-accounts) functionality recommended by AWS in EKS clusters.

It aims at supporting good default with possibility to override basic configuration like Helm values and allowing to attach custom IAM policies in case more permissions are required.

## Usage

```hcl
module "cloudwatch_exporter" {
  source = "tx-pts-dai/terraform-aws-prometheus-cloudwatch-exporter"
  version = "~> 0.1.0"

  chart_version             = "0.25.1"
  cluster_oidc_provider_arn = module.eks.cluster_oidc_provider_arn
  helm_additional_values    = [file("cloudwatch-exporter.yaml")]
}
```

Note: Multiple installations (for monitoring multiple AWS regions) of the CloudWatch exporter are supported.

## Explanation and description of interesting use-cases

< create a h2 chapter for each section explaining special module concepts >

## Examples

< if the folder `examples/` exists, put here the link to the examples subfolders with their descriptions >

## Contributing

< issues and contribution guidelines for public modules >

### Pre-Commit

Installation: [install pre-commit](https://pre-commit.com/) and execute `pre-commit install`. This will generate pre-commit hooks according to the config in `.pre-commit-config.yaml`

Before submitting a PR be sure to have used the pre-commit hooks or run: `pre-commit run -a`

The `pre-commit` command will run:

- Terraform fmt
- Terraform validate
- Terraform docs
- Terraform validate with tflint
- check for merge conflicts
- fix end of files

as described in the `.pre-commit-config.yaml` file

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_this"></a> [this](#module\_this) | aws-ia/eks-blueprints-addon/aws | ~> 1.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [random_id.suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | prometheus-cloudwatch-exporter chart version to be installed. Chart taken from https://github.com/prometheus-community/helm-charts | `string` | n/a | yes |
| <a name="input_cluster_oidc_provider_arn"></a> [cluster\_oidc\_provider\_arn](#input\_cluster\_oidc\_provider\_arn) | ARN of the EKS OpenIDConnect provider. Required for IAM Role for Service Account authentication. | `string` | n/a | yes |
| <a name="input_helm_additional_values"></a> [helm\_additional\_values](#input\_helm\_additional\_values) | Additional list of values for Helm Release | `list(string)` | `[]` | no |
| <a name="input_iam_role_additional_policies"></a> [iam\_role\_additional\_policies](#input\_iam\_role\_additional\_policies) | Map ('name' => 'policy\_arn') of additional policies to attach to the IAM Role assumed by the CloudWatch Exporter Pod | `map(string)` | `{}` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Kubernetes namespace where the Helm Release will be installed to | `string` | `"prometheus"` | no |
| <a name="input_release_name_prefix"></a> [release\_name\_prefix](#input\_release\_name\_prefix) | Name prefix of the Helm Release that will be created. This name is used to name the IAM role and Service Account that will be created. | `string` | `"prometheus-cloudwatch-exporter"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_iam_role_arn"></a> [iam\_role\_arn](#output\_iam\_role\_arn) | IAM Role ARN created for letting the Pod authenticate through IRSA |
| <a name="output_iam_role_name"></a> [iam\_role\_name](#output\_iam\_role\_name) | IAM Role ARN created for letting the Pod authenticate through IRSA |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module is maintained by [Alfredo Gottardo](https://github.com/AlfGot), [David Beauvererd](https://github.com/Davidoutz), [Davide Cammarata](https://github.com/DCamma), [Demetrio Carrara](https://github.com/sgametrio) and [Roland Bapst](https://github.com/rbapst-tamedia)

## License

Apache 2 Licensed. See [LICENSE](< link to license file >) for full details.
