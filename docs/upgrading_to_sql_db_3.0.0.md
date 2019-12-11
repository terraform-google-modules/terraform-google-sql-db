# Upgrading to SQL DB 3.0.0

The 3.0.0 release of SQL DB is a backward incompatible release. The `peering_completed` string variable along with hardcoded "tf_dependency" label in `user_labels` variable used to ensure that resources are created in a proper order when using private IPs and service network peering were dropped from `postgresql` and `safer_mysql` submodules. Instead the `module_depends_on` variable was added to the `postgresql`, `safer_mysql` and `mysql` submodules, which is a list of modules/resources a submodule depends on.

## Migration Instructions

Prior to the 3.0.0 release, you needed to set the optional `peering_completed` input with a string id of a resource that should have been created before the target sql module (e.g. safer_mysql).

```hcl
// We define a connection with the VPC of the Cloud SQL instance.
module "private-service-access" {
  source      = "GoogleCloudPlatform/sql-db/google//modules/private_service_access"
  project_id  = var.project_id
  vpc_network = google_compute_network.default.name
}

module "safer-mysql-db" {
  source           = "GoogleCloudPlatform/sql-db/google//modules/safer_mysql"
  version          = "2.0.0"

  name             = "example-safer-mysql-${random_id.name.hex}"
  database_version = var.mysql_version
  project_id       = var.project_id
  region           = var.region
  zone             = "c"

  ...

  assign_public_ip = true
  vpc_network      = google_compute_network.default.self_link

  // Used to enforce ordering in the creation of resources.
  peering_completed = module.private-service-access.complete
}

```

With the 3.0.0 release, the `module_depends_on` variable is presented which contains a list of modules/resources that should be created before the target sql module.

```diff
// We define a connection with the VPC of the Cloud SQL instance.
module "private-service-access" {
  source      = "GoogleCloudPlatform/sql-db/google//modules/private_service_access"
  project_id  = var.project_id
  vpc_network = google_compute_network.default.name
}

module "safer-mysql-db" {
  source           = "GoogleCloudPlatform/sql-db/google//modules/safer_mysql"
- version          = "2.0.0"
+ version          = "3.0.0"

  name             = "example-safer-mysql-${random_id.name.hex}"
  database_version = var.mysql_version
  project_id       = var.project_id
  region           = var.region
  zone             = "c"

  ...

  assign_public_ip = true
  vpc_network      = google_compute_network.default.self_link

  // Used to enforce ordering in the creation of resources.
- peering_completed = module.private-service-access.complete
+ module_depends_on = [module.private-service-access.complete]
}

```
