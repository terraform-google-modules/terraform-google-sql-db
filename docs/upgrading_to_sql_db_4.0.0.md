# Upgrading to SQL DB 4.0.0

The v4.0.0 release of SQL DB is a backward incompatible release. The MySQL/PostgreSQL read replica state has been migrated to using `for_each` and the replica configuration is now a list of individual replica configuration rather then all replicas sharing the same settings.

In addition the deprecated `failover_*` variables used to manage the now deprecated MySQL failover instance for HA have been completely removed in favour of the new HA solution that was introduced in v3.2.0

## Migration Instructions
#### MySQL Failover Instance

This migration causes downtime, please read the CloudSQL docs first: [Updating an instance from legacy to current high availability](https://cloud.google.com/sql/docs/mysql/configure-ha#update-from-legacy)

1. Delete the failover instance via this module
2. Set `availability_type = "REGIONAL"` - This will cause downtime as the master instance is restarted

#### Read Replicas
The new `read_replicas` variable is used to manage all replica configuration. In order to migrate existing replicas you will need to perform a state migration that moves state from a `int` index to a `string` index.

- You must have `read_replica_size` objects inside `read_replicas`
- You must use the full `zone` id which includes the region e.g. `europe-west1-c` instead of `c`

```bash
# Move `read_replica_size ` number of state resources to new location
terraform state mv 'module.test.google_sql_database_instance.replicas[0]' 'module.test.google_sql_database_instance.replicas["0"]'
terraform state mv 'module.test.google_sql_database_instance.replicas[1]' 'module.test.google_sql_database_instance.replicas["1"]'
```

```diff
 module "test" {
  source  = "GoogleCloudPlatform/sql-db/google//modules/mysql"
-  version = "~> 3.2"
+  version = "~> 4.0"

   // Read replica configurations
-  read_replica_name_suffix                     = "-test"
-  read_replica_size                            = 1
-  read_replica_tier                            = "db-n1-standard-1"
-  read_replica_zones                           = "c"
-  read_replica_activation_policy               = "ALWAYS"
-  read_replica_crash_safe_replication          = true
-  read_replica_disk_size                       = 15
-  read_replica_disk_autoresize                 = true
-  read_replica_disk_type                       = "PD_HDD"
-  read_replica_replication_type                = "SYNCHRONOUS"
-  read_replica_maintenance_window_day          = 1
-  read_replica_maintenance_window_hour         = 22
-  read_replica_maintenance_window_update_track = "stable"
-
-  read_replica_user_labels = {
-    bar = "baz"
-  }
-
-  read_replica_database_flags = [
+  read_replica_name_suffix = "-test"
+  read_replicas = [
     {
-      name  = "long_query_time"
-      value = "1"
+      name = "0"
+      tier = "db-n1-standard-1"
+      zone = "europe-west1-c"
+      ip_configuration = {
+        ipv4_enabled        = true
+        require_ssl         = true
+        private_network     = var.host_vpc_link
+        authorized_networks = []
+      }
+      database_flags  = [{ name = "long_query_time", value = "1" }]
+      disk_autoresize = true
+      disk_size       = 15
+      disk_type       = "PD_HDD"
+      user_labels     = { bar = "baz" }
+    },
+    {
+      name = "1"
+      tier = "db-n1-standard-1"
+      zone = "europe-west1-c"
+      ip_configuration = {
+        ipv4_enabled        = true
+        require_ssl         = true
+        private_network     = var.host_vpc_link
+        authorized_networks = []
+      }
+      database_flags  = [{ name = "long_query_time", value = "1" }]
+      disk_autoresize = true
+      disk_size       = 15
+      disk_type       = "PD_HDD"
+      user_labels     = { bar = "baz" }
     },
   ]

-  read_replica_configuration = {
-    dump_file_path            = null
-    connect_retry_interval    = null
-    ca_certificate            = null
-    client_certificate        = null
-    client_key                = null
-    failover_target           = false
-    master_heartbeat_period   = null
-    password                  = null
-    ssl_cipher                = null
-    username                  = null
-    verify_server_certificate = null
-  }
-
-  read_replica_ip_configuration = {
-    ipv4_enabled        = true
-    require_ssl         = true
-    private_network     = var.host_vpc_link
-    authorized_networks = []
-  }
-
 }
```
