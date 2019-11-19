# Cloud SQL Database Example

This example shows how create public Cloud SQL databases for for MySQL and PostgreSQL using the Terraform module.

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
| authorized\_networks | List of mapped public networks authorized to access to the instances. Default - short range of GCP health-checkers IPs | list(map(string)) | `<list>` | no |
| mysql\_version |  | string | `"MYSQL_5_6"` | no |
| postgresql\_version |  | string | `"POSTGRES_9_6"` | no |
| project\_id |  | string | n/a | yes |
| region |  | string | `"us-central1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| mysql\_conn | The connection name of the master instance to be used in connection strings |
| mysql\_user\_pass | The password for the default user. If not set, a random one will be generated and available in the generated_user_password output variable. |
| psql\_conn | The connection name of the master instance to be used in connection strings |
| psql\_user\_pass | The password for the default user. If not set, a random one will be generated and available in the generated_user_password output variable. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
