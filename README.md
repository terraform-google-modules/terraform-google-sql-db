# terraform-google-sql

terraform-google-sql makes it easy to create Google CloudSQL instance and implement high availability settings.
This module consists of the following submodules:

- [mysql](./modules/mysql)
- [postgresql](./modules/postgresql)

See more details in each module's README.

## Compatibility

This module is meant for use with Terraform 0.12. If you haven't
[upgraded](https://www.terraform.io/upgrade-guides/0-12.html)
and need a Terraform 0.11.x-compatible version of this module, the last
released version intended for Terraform 0.11.x is
[v1.2.0](https://registry.terraform.io/modules/GoogleCloudPlatform/sql-db/google/1.2.0).

## Root module

The root module has been deprecated. Please switch to using one of the submodules.

## Requirements

### Installation Dependencies

- [terraform](https://www.terraform.io/downloads.html) 0.12.x
- [terraform-provider-google](https://github.com/terraform-providers/terraform-provider-google) plugin v2.5.x

### Configure a Service Account

In order to execute this module you must have a Service Account with the following:

#### Roles

- Cloud SQL Admin: `roles/cloudsql.admin`

### Enable APIs

In order to operate with the Service Account you must activate the following APIs on the project where the Service Account was created:

- Cloud SQL Admin API: `sqladmin.googleapis.com`

In order to use Private Service Access, required for using Private IPs, you must activate
the following APIs on the project where your VPC resides:

- Cloud SQL Admin API: `sqladmin.googleapis.com`
- Compute Engine API: `compute.googleapis.com`
- Service Networking API: `servicenetworking.googleapis.com`
- Cloud Resource Manager API: `cloudresourcemanager.googleapis.com`

#### Service Account Credentials

You can pass the service account credentials into this module by setting the following environment variables:

* `GOOGLE_CREDENTIALS`
* `GOOGLE_CLOUD_KEYFILE_JSON`
* `GCLOUD_KEYFILE_JSON`

See more [details](https://www.terraform.io/docs/providers/google/provider_reference.html#configuration-reference).

## Testing

### Requirements

- [bundler](https://bundler.io/)
- [ruby](https://www.ruby-lang.org/) 2.5.x
- [python](https://www.python.org/getit/) 2.7.x
- [terraform-docs](https://github.com/segmentio/terraform-docs) 0.4.5
- [google-cloud-sdk](https://cloud.google.com/sdk/)

### Generate docs automatically

```sh
$ make generate_docs
```

### Integration Test

The integration tests for this module leverage kitchen-terraform and kitchen-inspec.

You must set up by manually before running the integration test:

```sh
for instance in mysql-simple mysql-ha postgresql-simple postgresql-ha safer-mysql-simple; do
  cp "test/fixtures/$instance/terraform.tfvars.example" "test/fixtures/$instance/terraform.tfvars"
  $EDITOR "test/fixtures/$instance/terraform.tfvars"
done
```

And then, you should pass the service account credentials for running inspec by setting the following environment variables:

- `GOOGLE_APPLICATION_CREDENTIALS`

The project used for testing needs the Cloud Resource Manager API service enabled, and the service account should be assigned `roles/compute.networkAdmin` (in addition to `roles/cloudsql.admin`) to instantiate the VPC required in the tests.

The tests will do the following:

- Perform `bundle install` command
  - Installs `test-kitchen`, `kitchen-terraform` and `kitchen-inspec`
- Perform `bundle exec kitchen create` command
  - Performs `terraform init`
- Perform `bundle exec kitchen converge` command
  - Performs `terraform apply -auto-approve`
- Perform `bundle exec kitchen verify` command
  - Performs inspec tests
- Perform `bundle exec kitchen destroy` command
  - Performs `terraform destroy -force`

You can use the following command to run the integration test in the root directory.

```sh
$ make test_integration
```

## Linting

The makefile in this project will lint or sometimes just format any shell, Python, golang, Terraform, or Dockerfiles. The linters will only be run if the makefile finds files with the appropriate file extension.

All of the linter checks are in the default make target, so you just have to run

```sh
$ make -s
```

The -s is for 'silent'. Successful output looks like this

```
Running shellcheck
Running flake8
Running go fmt and go vet
Running terraform validate
Running terraform fmt
Checking for required files
The following lines have trailing whitespace
Generating markdown docs with terraform-docs
```

The linters
are as follows:
- Shell - shellcheck. Can be found in homebrew
- Python - flake8. Can be installed with `pip install flake8`
- Golang - gofmt. gofmt comes with the standard golang installation. golang
-s a compiled language so there is no standard linter.
- Terraform - terraform has a built-in linter in the `terraform validate` command.
- Dockerfiles - hadolint. Can be found in homebrew
