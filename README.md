# Foodcart Bot

> *DEPRECATED* This component has been merged into my primary mono-repo.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.0, < 0.14.0 |
| aws | ~> 2.7 |
| aws | ~> 2.70 |
| random | ~> 2.2 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 2.7 ~> 2.70 |
| terraform | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| attachment\_color | Color to use for attachement postings. | `string` | `"#00704a"` | no |
| aws\_profile | Name of AWS profile to use for API access. | `string` | `"default"` | no |
| aws\_region | n/a | `string` | `"us-west-2"` | no |
| project | Default value for project tag. | `string` | `"foodcart"` | no |
| slack\_webhook | Slack incoming webhook to use for posting. | `any` | n/a | yes |
| vpc\_cidr | CIDR for build VPC | `string` | `"192.168.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| lambda\_role\_arn | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
