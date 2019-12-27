# Cloud SQL Database Example with External Master

This example shows how create Cloud SQL databases for for MySQL with external master, using the Terraform module.

## Run Terraform

Create resources with terraform:

```bash
terraform init
terraform plan
terraform apply
```

To remove all resources created by terraform:

```bash
terraform destroy
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| project\_id |  | string | n/a | yes |
| region |  | string | `"us-central1"` | no |
| source\_ip\_address |  | string | n/a | yes |
| source\_port |  | string | `"3306"` | no |
| zone |  | string | `"us-central1-b"` | no |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
