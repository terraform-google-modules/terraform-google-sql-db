# Upgrading to SQL DB 20.0.0

The 20.0.0 release of SQL DB is a backward incompatible release.

This update requires upgrading the minimum provider version `5.12` and minimum Terraform version `1.3`


In `mysql` and `postgresql` sub-module output `instance_server_ca_cert` and `replicas_instance_server_ca_certs` are also marked as `sensitive`

In `mysql` and `postgresql` sub-module default value for `zone` is changed from `"us-central1-a"` to `null`
