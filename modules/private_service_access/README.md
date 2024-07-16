# Submodule for Private Service Access

MySQL [Private IP](https://cloud.google.com/sql/docs/mysql/private-ip)
configurations require a special peering between your VPC network and a
VPC managed by Google. The module supports creating such a peering.

It is sufficient to instantiate this module once for all MySQL instances
that are connected to the same VPC.

> NOTE: See the linked [documentation](https://cloud.google.com/sql/docs/mysql/private-ip)
> for all requirements for accessing a MySQL instance via its Private IP.

## Usage
Basic usage of this module is as follows:

```
module "test_psa" {
  source  = "terraform-google-modules/sql-db/google//modules/private_service_access"
  version = "~> 21.0"

  project_id      = var.project_id
  vpc_network     = google_compute_network.default.name
  address         = "10.220.0.0"
  deletion_policy = "ABANDON"
  depends_on      = [google_compute_network.default]
}
```


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| address | First IP address of the IP range to allocate to CLoud SQL instances and other Private Service Access services. If not set, GCP will pick a valid one for you. | `string` | `""` | no |
| deletion\_policy | The deletion policy for the service networking connection. Setting to ABANDON allows the resource to be abandoned rather than deleted. This will enable a successful terraform destroy when destroying CloudSQL instances. Use with care as it can lead to dangling resources. | `string` | `null` | no |
| description | An optional description of the Global Address resource. | `string` | `""` | no |
| ip\_version | IP Version for the allocation. Can be IPV4 or IPV6. | `string` | `""` | no |
| labels | The key/value labels for the IP range allocated to the peered network. | `map(string)` | `{}` | no |
| prefix\_length | Prefix length of the IP range reserved for Cloud SQL instances and other Private Service Access services. Defaults to /16. | `number` | `16` | no |
| project\_id | The project ID of the VPC network to peer. This can be a shared VPC host projec. | `string` | n/a | yes |
| vpc\_network | Name of the VPC network to peer. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| address | First IP of the reserved range. |
| google\_compute\_global\_address\_name | URL of the reserved range. |
| peering\_completed | Use for enforce ordering between resource creation |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
