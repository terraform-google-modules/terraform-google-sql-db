# Upgrading to SQL DB 22.0

The 22.0 release of SQL DB is a backward incompatible release.

# Maximum provider version
This update requires upgrading the minimum Terraform version `1.3`. Maximum provider version is relaxed to use provider version 6.X+

# Removed settings.ip_configuration.require_ssl 
Removed `settings.ip_configuration.require_ssl` from all the modules (`google_sql_database_instance`) in favor of `settings.ip_configuration.ssl_mode`. This field is not available in [provider version 6+](https://github.com/hashicorp/terraform-provider-google/pull/19263)
