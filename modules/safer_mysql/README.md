# terraform-google-sql for a safer MySQL

The module sets up a MySQL installation that relies on Cloud IAM for
authenticating its users. The use of Cloud IAM centralizes identity
management, access control, and permits to strengthen the credentials
being used for authentication.

The module uses the terraform-google-sql module for MySQL, but controls
more strictly the type of network connections that are allowed: in all
cases, network connections need to be mediated via the Cloud SQL Proxy and,
hence, be authorized via Cloud IAM.

The most secure setup doesn't assign a public IP to the instance
(assign_public_ip = false), and permits connections only from within the
given VPC. In such a setup, sharing the instance between projects requires
setting up Shared VPCs, and direct mysql access from engineering workstations
is not possible: any debugging needs to be performed via bastion hosts or
custom tooling running on VMs connected to the VPC.

If assign_public_ip = true, the instance will be assigned a public IP. However,
the module ensures that no authorized networks can be configured on the instance,
so all accesses are need to be mediated via the Cloud SQL proxy and
authenticated via Cloud IAM. Such a setup still provide strong identity
guarantees that go beyond the use of only username/password or long-lived
certificates.

## Cloud IAM Policy Recommendation

We have two levels of access to Cloud SQL: access to the data, and
administrative access to the server's configurations. The two
level of access correspond to the `roles/cloudsql.admin` and
`roles/cloudsql.client`.

`roles/cloudsql.admin`:

-   Modifications to the instance configurations should be very rare, we suggest
    to assign such permissions only to automation users (e.g.,
    Terraform run as part of a CI/CD pipeline), or as part of breakglass access
    to the project's resources.

`roles/cloudsql.client`

-   Service accounts of applications can be bound directly to the role (e.g.,
    `xxxx-prod@xxxx.iam.gserviceaccont.com`)

-   Humans that need to access the data for debugging purposes should get the
    access via membership group. Make sure that the group allows only members
    from within the organization, and that only invited members can join.

You can add the following Cloud IAM snippet to the project policy:

```
    - auditLogConfigs:
    - logType: DATA_READ
    - logType: DATA_WRITE
    service: cloudsql.googleapis.com

    - members:
      - group:xxxx-breakglass@groups.your-org.com
    role: roles/cloudsql.admin

    - members:
      - group:xxxx-data-access@groups.your-org.com
      - serviceAccount:xxxx-prod@xxxx.iam.gserviceaccont.com
    role: roles/cloudsql.client
```

## Define MySQL users and passwords on your instance

Because Cloud IAM acts as a primary athentication and authorization mechanism,
we can consider MySQL usernames and passwords are a secondary access controls that
can be used to further restrict access for reliability or safety
purposes. For example, removing the ability of modifying tables from production
users that don't need such a capability.

The module, by default, creates users that:

-   only allow connections from host ~cloudsqlproxy to ensure that nobody can
    access data without connecting via the Cloud SQL Proxy.
-   have randomly generated passwords, which can be stored in configuration
    files. Such passwords can be considered as secure as API Keys rather than
    strong credentials for access.

To maintain the user list manageable, we suggest to consider MySQL users in a
way similar to roles rather than individual human users. For example, a simple
application could define the following roles:

-   **admin**: root-like users with full permissions on all tables and data.
    This can be used in breakglass emergencies, or as part of the release cycle
    to perform structural modifications of the DB (e.g., add tables and columns)

-   **app**: permissions required for running the application. Generally, it
    will have read/write permissions on data, but no ability of performing
    structural modifications to the DB.

    *   Multiple roles for different apps can be defined if more protection
        against accidental errors is desired.

-   **readonly**: permissions required for reading data in the database for
    debugging or customer support.

*   Once users are created, you need to assign them
    permissions by executing the following commands on a MySQL client.
    *   The permissions can be customized further is more fine-grained access is
        appropriate.

```
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'app'@'cloudproxy~%';
GRANT SELECT, INSERT, UPDATE, LOCK TABLES ON your_app_db.*
  TO 'app'@'cloudproxy~%';

REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'readonly'@'cloudproxy~%';
GRANT SELECT ON your_app_db.* TO 'readonly'@'cloudproxy~%';

FLUSH PRIVILEGES;
```


## SWE / SRE Workflows

The rest of the workflow is implemented by SREs and SWEs using the instance.

### Access the Cloud SQL instance from production

*   Create a service account and assign to it the `roles/cloudsql.client`
    permissions as described above.
*   Use the service account in your VMs or GKE node pools, so that it can be
    used by application as the default service account of the machine.
*   For GKE and VM, setup CloudSQL proxy as described in the
    [public documentation](https://cloud.google.com/sql/docs/mysql/sql-proxy).
*   User and password of the MySQL user can be set as configurations of the
    application, or GKE secrets.

*   All applications should construct SQL queries following principles and
    libraries that protect against SQL Injection Attacks.

### Human Access to the Cloud SQL instance data.

*   Download and install Cloud SQL proxy on their workstation as
    described in the
    [public documentation](https://cloud.google.com/sql/docs/mysql/sql-proxy).

```
wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O cloud_sql_proxy
chmod +x cloud_sql_proxy
```

Connections from engineers' workstations is directly possible only if the instance
has been assiged a public ip (assign_public_ip = "true"). If only Private IPs are
used, then access needs to be mediated by bastion hosts connected to the same VPC,
or through custom UI or other tools.

If public IP is available, engineers can use the following process to connect:

```
mkdir $HOME/mysql_sockets
./cloud_sql_proxy --dir=$HOME/mysql_sockets --instances=myproject:region:instance

mysql -S $HOME/mysql_sockets/myproject:region:instance -u user -p
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| activation\_policy | The activation policy for the master instance. Can be either `ALWAYS`, `NEVER` or `ON_DEMAND`. | string | `"ALWAYS"` | no |
| additional\_databases | A list of databases to be created in your cluster | object | `<list>` | no |
| additional\_users | A list of users to be created in your cluster | object | `<list>` | no |
| assign\_public\_ip | Set to true if the master instance should also have a public IP (less secure). | string | `"false"` | no |
| authorized\_gae\_applications | The list of authorized App Engine project names | list(string) | `<list>` | no |
| backup\_configuration | The backup_configuration settings subblock for the database setings | object | `<map>` | no |
| create\_timeout | The optional timout that is applied to limit long database creates. | string | `"15m"` | no |
| database\_flags | The database flags for the master instance. See [more details](https://cloud.google.com/sql/docs/mysql/flags) | object | `<list>` | no |
| database\_version | The database version to use | string | n/a | yes |
| db\_charset | The charset for the default database | string | `""` | no |
| db\_collation | The collation for the default database. Example: 'utf8_general_ci' | string | `""` | no |
| db\_name | The name of the default database to create | string | `"default"` | no |
| delete\_timeout | The optional timout that is applied to limit long database deletes. | string | `"15m"` | no |
| disk\_autoresize | Configuration to increase storage size | bool | `"true"` | no |
| disk\_size | The disk size for the master instance | number | `"10"` | no |
| disk\_type | The disk type for the master instance. | string | `"PD_SSD"` | no |
| failover\_replica | Specify true if the failover instance is required | bool | `"false"` | no |
| failover\_replica\_activation\_policy | The activation policy for the failover replica instance. Can be either `ALWAYS`, `NEVER` or `ON_DEMAND`. | string | `"ALWAYS"` | no |
| failover\_replica\_configuration | The replica configuration for the failover replica instance. In order to create a failover instance, need to specify this argument. | object | `<map>` | no |
| failover\_replica\_crash\_safe\_replication | The crash safe replication is to indicates when crash-safe replication flags are enabled. | bool | `"true"` | no |
| failover\_replica\_database\_flags | The database flags for the failover replica instance. See [more details](https://cloud.google.com/sql/docs/mysql/flags) | object | `<list>` | no |
| failover\_replica\_disk\_autoresize | Configuration to increase storage size. | bool | `"true"` | no |
| failover\_replica\_disk\_size | The disk size for the failover replica instance. | number | `"10"` | no |
| failover\_replica\_disk\_type | The disk type for the failover replica instance. | string | `"PD_SSD"` | no |
| failover\_replica\_maintenance\_window\_day | The day of week (1-7) for the failover replica instance maintenance. | number | `"1"` | no |
| failover\_replica\_maintenance\_window\_hour | The hour of day (0-23) maintenance window for the failover replica instance maintenance. | number | `"23"` | no |
| failover\_replica\_maintenance\_window\_update\_track | The update track of maintenance window for the failover replica instance maintenance. Can be either `canary` or `stable`. | string | `"canary"` | no |
| failover\_replica\_name\_suffix | The optional suffix to add to the failover instance name | string | `""` | no |
| failover\_replica\_pricing\_plan | The pricing plan for the failover replica instance. | string | `"PER_USE"` | no |
| failover\_replica\_replication\_type | The replication type for the failover replica instance. Can be one of ASYNCHRONOUS or SYNCHRONOUS. | string | `"SYNCHRONOUS"` | no |
| failover\_replica\_tier | The tier for the failover replica instance. | string | `""` | no |
| failover\_replica\_user\_labels | The key/value labels for the failover replica instance. | map(string) | `<map>` | no |
| failover\_replica\_zone | The zone for the failover replica instance, it should be something like: `a`, `c`. | string | `""` | no |
| maintenance\_window\_day | The day of week (1-7) for the master instance maintenance. | number | `"1"` | no |
| maintenance\_window\_hour | The hour of day (0-23) maintenance window for the master instance maintenance. | number | `"23"` | no |
| maintenance\_window\_update\_track | The update track of maintenance window for the master instance maintenance. Can be either `canary` or `stable`. | string | `"stable"` | no |
| module\_depends\_on | List of modules or resources this module depends on. | list(any) | `<list>` | no |
| name | The name of the Cloud SQL resources | string | n/a | yes |
| pricing\_plan | The pricing plan for the master instance. | string | `"PER_USE"` | no |
| project\_id | The project ID to manage the Cloud SQL resources | string | n/a | yes |
| read\_replica\_activation\_policy | The activation policy for the read replica instances. Can be either `ALWAYS`, `NEVER` or `ON_DEMAND`. | string | `"ALWAYS"` | no |
| read\_replica\_configuration | The replica configuration for use in all read replica instances. | object | `<map>` | no |
| read\_replica\_crash\_safe\_replication | The crash safe replication is to indicates when crash-safe replication flags are enabled. | bool | `"true"` | no |
| read\_replica\_database\_flags | The database flags for the read replica instances. See [more details](https://cloud.google.com/sql/docs/mysql/flags) | object | `<list>` | no |
| read\_replica\_disk\_autoresize | Configuration to increase storage size. | bool | `"true"` | no |
| read\_replica\_disk\_size | The disk size for the read replica instances. | number | `"10"` | no |
| read\_replica\_disk\_type | The disk type for the read replica instances. | string | `"PD_SSD"` | no |
| read\_replica\_maintenance\_window\_day | The day of week (1-7) for the read replica instances maintenance. | number | `"1"` | no |
| read\_replica\_maintenance\_window\_hour | The hour of day (0-23) maintenance window for the read replica instances maintenance. | number | `"23"` | no |
| read\_replica\_maintenance\_window\_update\_track | The update track of maintenance window for the read replica instances maintenance. Can be either `canary` or `stable`. | string | `"canary"` | no |
| read\_replica\_name\_suffix | The optional suffix to add to the read instance name | string | `""` | no |
| read\_replica\_pricing\_plan | The pricing plan for the read replica instances. | string | `"PER_USE"` | no |
| read\_replica\_replication\_type | The replication type for read replica instances. Can be one of ASYNCHRONOUS or SYNCHRONOUS. | string | `"SYNCHRONOUS"` | no |
| read\_replica\_size | The size of read replicas | number | `"0"` | no |
| read\_replica\_tier | The tier for the read replica instances. | string | `""` | no |
| read\_replica\_user\_labels | The key/value labels for the read replica instances. | map(string) | `<map>` | no |
| read\_replica\_zones | The zones for the read replica instancess, it should be something like: `a,b,c`. Given zones are used rotationally for creating read replicas. | string | `""` | no |
| region | The region of the Cloud SQL resources | string | n/a | yes |
| tier | The tier for the master instance. | string | `"db-n1-standard-1"` | no |
| update\_timeout | The optional timout that is applied to limit long database updates. | string | `"15m"` | no |
| user\_labels | The key/value labels for the master instances. | map(string) | `<map>` | no |
| user\_name | The name of the default user | string | `"default"` | no |
| user\_password | The password for the default user. If not set, a random one will be generated and available in the generated_user_password output variable. | string | `""` | no |
| vpc\_network | Existing VPC network to which instances are connected. The networks needs to be configured with https://cloud.google.com/vpc/docs/configure-private-services-access. | string | n/a | yes |
| zone | The zone for the master instance, it should be something like: `a`, `c`. | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| failover-replica\_instance\_connection\_name | The connection name of the failover-replica instance to be used in connection strings |
| failover-replica\_instance\_name | The instance name for the failover replica instance |
| failover-replica\_instance\_self\_link | The URI of the failover-replica instance |
| failover-replica\_instance\_service\_account\_email\_address | The service account email addresses assigned to the failover-replica instance |
| generated\_user\_password | The auto generated default user password if not input password was provided |
| instance\_address | The IPv4 addesses assigned for the master instance |
| instance\_connection\_name | The connection name of the master instance to be used in connection strings |
| instance\_name | The instance name for the master instance |
| instance\_self\_link | The URI of the master instance |
| instance\_service\_account\_email\_address | The service account email address assigned to the master instance |
| mysql\_version | The MySQL version to use. |
| private\_ip\_address | The first private (PRIVATE) IPv4 address assigned for the master instance |
| public\_ip\_address | The first public (PRIMARY) IPv4 address assigned for the master instance |
| read\_replica\_instance\_names | The instance names for the read replica instances |
| region | The region of the Cloud SQL resources |
| replicas\_instance\_connection\_names | The connection names of the replica instances to be used in connection strings |
| replicas\_instance\_self\_links | The URIs of the replica instances |
| replicas\_instance\_service\_account\_email\_addresses | The service account email addresses assigned to the replica instances |
| tier | The tier for the master instance. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
