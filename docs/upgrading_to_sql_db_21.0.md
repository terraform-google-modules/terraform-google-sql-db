# Upgrading to SQL DB 21.0

The 21.0 release of SQL DB is a backward incompatible release.

# Maximum provider version
This update requires upgrading the minimum Terraform version `1.3`. Minimum provider version for `private_service_access` sub-module is `5.38`

# Removed settings.ip_configuration.require_ssl 
Removed `settings.ip_configuration.require_ssl` from all the modules (`google_sql_database_instance`) in favor of `settings.ip_configuration.ssl_mode`. This field is not available in [provider version 6+](https://github.com/hashicorp/terraform-provider-google/pull/19263)
