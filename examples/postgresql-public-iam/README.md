# Cloud SQL Database Example

This example shows how to create the public Postgres Cloud SQL database using the Terraform module with IAM accounts.

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
|------|-------------|------|---------|:--------:|
| authorized\_networks | List of mapped public networks authorized to access to the instances. Default - short range of GCP health-checkers IPs | `list(map(string))` | <pre>[<br>  {<br>    "name": "sample-gcp-health-checkers-range",<br>    "value": "130.211.0.0/28"<br>  }<br>]</pre> | no |
| cloudsql\_pg\_sa | IAM service account user created for Cloud SQL. | `string` | n/a | yes |
| db\_name | The name of the SQL Database instance | `string` | `"example-postgres-public"` | no |
| project\_id | The ID of the project in which resources will be provisioned. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| name | The name for Cloud SQL instance |
| project\_id | The project to run tests against |
| psql\_conn | The connection name of the master instance to be used in connection strings |
| psql\_user\_pass | The password for the default user. If not set, a random one will be generated and available in the generated\_user\_password output variable. |
| public\_ip\_address | The first public (PRIMARY) IPv4 address assigned for the master instance |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
