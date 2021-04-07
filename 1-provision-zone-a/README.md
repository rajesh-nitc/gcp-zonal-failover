## Provision Zone A

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >=0.12 |
| terraform | >=0.12 |
| google | >= 3.39.0, <4.0.0 |

## Providers

| Name | Version |
|------|---------|
| google | >= 3.39.0, <4.0.0 |
| google-beta | n/a |
| null | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bootstrap | n/a | `bool` | `true` | no |
| device\_name\_region | n/a | `string` | `"region-data"` | no |
| device\_name\_zonal | n/a | `string` | `"zone-data"` | no |
| disk\_regional | n/a | `string` | n/a | yes |
| disk\_zo\_a | n/a | `string` | n/a | yes |
| instance\_name | n/a | `string` | n/a | yes |
| instance\_name\_zo\_b | n/a | `string` | n/a | yes |
| latest\_snapshot\_zonal\_disk\_b | Latest snapshot | `string` | `""` | no |
| project\_id | GCP Project id | `string` | n/a | yes |
| region | n/a | `string` | n/a | yes |
| uig\_name | n/a | `string` | n/a | yes |
| zone\_a | n/a | `string` | n/a | yes |
| zone\_b | n/a | `string` | n/a | yes |

## Outputs

No output.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->