# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this
project adheres to [Semantic Versioning](http://semver.org/).

## [20.0.0](https://github.com/terraform-google-modules/terraform-google-sql-db/compare/v19.0.0...v20.0.0) (2024-03-08)


### ⚠ BREAKING CHANGES

* **TPG>=5.12:** Add option to create and failover a replica instance in Postgresql and MsSQL sub-module ([#582](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/582))
* **TPG>=5.6:** bump required google provider to 5.6 for postgres

### Features

* **TPG>=5.12:** Add option to create and failover a replica instance in Postgresql and MsSQL sub-module ([#582](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/582)) ([141e54a](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/141e54a9256feae704220ceed24c9a94ebaf7e27))


### Bug Fixes

* mark replicas_instance_server_ca_certs output as sensitive ([#579](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/579)) ([faa064e](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/faa064e069a4678f54e6688825e85dcfb3dcf1c2))
* **TPG>=5.6:** bump required google provider to 5.6 for postgres ([0d3b434](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/0d3b43426b93c1492f6a82e3367e40f2d41b0edc))

## [19.0.0](https://github.com/terraform-google-modules/terraform-google-sql-db/compare/v18.2.0...v19.0.0) (2024-02-08)


### ⚠ BREAKING CHANGES

* Allow passing ssl_mode for MySQL Module ([#575](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/575))

### Features

* Allow passing ssl_mode for MySQL Module ([#575](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/575)) ([c7ab6ec](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/c7ab6ecbcdfaaee94586b2251ff643d05311a5cc))
* Make MySQL CloudSQL zone optional ([#572](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/572)) ([3c4b504](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/3c4b504671cffc222b408b1f3051175837757b1e))


### Bug Fixes

* **backup:** backups are not deleted when retained nr of backups &gt;= 20 ([#566](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/566)) ([6c4b0e3](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/6c4b0e38b7d37e67107955da3d9a46e691b3f47a))
* Cloud SQL does not support multiple deny_maintenance_period block. Update variable description ([#564](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/564)) ([9e55c87](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/9e55c87c54371780f175734212abce3e4d4963c3))
* **deps:** Update cft/developer-tools Docker tag to v1.19 ([#571](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/571)) ([bd18ee6](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/bd18ee68a2a05c5587706d9cbca6023b8eab0ae1))
* Improve MySQL root_password documentation ([#573](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/573)) ([611edfd](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/611edfd8d72d4560c629fa8e3863932eb309323d))

## [18.2.0](https://github.com/terraform-google-modules/terraform-google-sql-db/compare/v18.1.0...v18.2.0) (2024-01-03)


### Features

* add master_instance_name and instance_type to mysql module ([#556](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/556)) ([6cda644](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/6cda644a136a1cac3ada9358007619f02f90a169))


### Bug Fixes

* Don't define backup_configuration if default DB is configured as a replica ([#559](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/559)) ([52224ad](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/52224ada14af2f828fefc84f1e7fce2aeb52f670))

## [18.1.0](https://github.com/terraform-google-modules/terraform-google-sql-db/compare/v18.0.0...v18.1.0) (2023-12-13)


### Features

* **postgres:** add root password parameter ([#521](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/521)) ([be2da56](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/be2da560ca7a006c56cbffab71e0b6e931661f7c))


### Bug Fixes

* add dns_name to output in postgresql module ([#544](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/544)) ([2ade7eb](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/2ade7ebe44362c0593cfb38e0704d9098d231092))

## [18.0.0](https://github.com/terraform-google-modules/terraform-google-sql-db/compare/v17.1.0...v18.0.0) (2023-12-04)


### ⚠ BREAKING CHANGES

* safer_mysql module's `assign_public_ip` input should be bool type ([#541](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/541))

### Features

* add support for ssl_mode to postgresql module ([#547](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/547)) ([9c59232](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/9c59232a37725aef57162e836090c64495e6acd9))


### Bug Fixes

* safer_mysql module's `assign_public_ip` input should be bool type ([#541](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/541)) ([4521594](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/45215943968dc371d5198b8cb3d4fa956aa745dd))

## [17.1.0](https://github.com/terraform-google-modules/terraform-google-sql-db/compare/v17.0.1...v17.1.0) (2023-11-09)


### Features

* added cloudsql serverless_export ([#530](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/530)) ([aae3181](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/aae3181fcfd45a7df08c25a28503a6080e5d20ad))
* adding data_cache_config to postgresql module ([#531](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/531)) ([f04d617](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/f04d617ee31459cccc2df70013697a10286dd49d))


### Bug Fixes

* reduce number of replicas in postgres-ha test ([#539](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/539)) ([c769aa5](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/c769aa53e92df5f48b7e7e71ad425c5748502376))

## [17.0.1](https://github.com/terraform-google-modules/terraform-google-sql-db/compare/v17.0.0...v17.0.1) (2023-11-03)


### Bug Fixes

* **deps:** update actions/checkout action to v4 ([#510](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/510)) ([9012164](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/90121648e30b9c82dc72ada72fb9adcec2b9ffb0))
* **deps:** update cft/developer-tools docker tag to v1.15 ([#508](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/508)) ([8c32574](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/8c325747ef30e668a5462be2839eb062be9d2f8f))
* Fix zone auto-detection when var.zones are not set ([#534](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/534)) ([8409f72](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/8409f72ba7ffaeb23e07f795eff969d8775fb3d4))
* upgraded versions.tf to include minor bumps from tpg v5 ([#523](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/523)) ([5102a7b](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/5102a7b1dcf413380367c3aed730aca839636a0b))

## [17.0.0](https://github.com/terraform-google-modules/terraform-google-sql-db/compare/v16.1.0...v17.0.0) (2023-09-04)


### ⚠ BREAKING CHANGES

* **TPG >= 4.80:** add support for psc (private service connect) ([#507](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/507))

### Features

* add connector params timeout and export from replica ([#406](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/406)) ([e563f8a](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/e563f8a1f2a13f16ab1e787e904566cd73f564ba))
* add support for query_plans_per_minute ([#484](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/484)) ([ffb674c](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/ffb674ccffc632ffb8bb25e479a87a317eb9134b))
* MySQL binary logs on replica ([#466](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/466)) ([0e0c196](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/0e0c19637ffaee07e2eaaa9e003a49e01e2acec0))
* **TPG >= 4.80:** add support for psc (private service connect) ([#507](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/507)) ([64c2435](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/64c24358c2a79f1ba89674f1cfebad28ba476b2a))


### Bug Fixes

* **deps:** update module github.com/googlecloudplatform/cloud-foundation-toolkit/infra/blueprint-test to v0.8.0 ([#505](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/505)) ([5b111a6](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/5b111a66614ffb9d8d41a93c73bdf73cdf093c50))

## [16.1.0](https://github.com/terraform-google-modules/terraform-google-sql-db/compare/v16.0.0...v16.1.0) (2023-08-23)


### Features

* config connector_enforcement in postgres and mssql ([#500](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/500)) ([5789b54](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/5789b541a1b7e8c08eef58a85278e98114985d3e))

## [16.0.0](https://github.com/terraform-google-modules/terraform-google-sql-db/compare/v15.2.0...v16.0.0) (2023-08-09)


### ⚠ BREAKING CHANGES

* added `edition` in mssql, mysql, postgresql, safer_sql and `data_cache_config` to mysql and safer_sql modules ([#491](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/491))

### Features

* added `edition` in mssql, mysql, postgresql, safer_sql and `data_cache_config` to mysql and safer_sql modules ([#491](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/491)) ([0024b24](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/0024b24c22525ac21870d7ccea15930e1c9c301a))


### Bug Fixes

* to avoid password reset for existing additional users for mssql ([#489](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/489)) ([923cd11](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/923cd1129fafa98c2dbe596fed75d6611334e484))

## [15.2.0](https://github.com/terraform-google-modules/terraform-google-sql-db/compare/v15.1.0...v15.2.0) (2023-07-18)


### Features

* add time_zone for mssql ([#488](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/488)) ([0938dec](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/0938deceedac7cf15c0fa51d6b81faac7216e0ad))

## [15.1.0](https://github.com/terraform-google-modules/terraform-google-sql-db/compare/v15.0.0...v15.1.0) (2023-06-20)


### Features

* added support for enable_private_path_for_google_cloud_services field in replica instances. ([#471](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/471)) ([3d0c204](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/3d0c204ac670ad99c08c64a8024325f3c8f90a9d))
* include log for each database name in export workflow ([#407](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/407)) ([e638a24](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/e638a24eacc953d3e8ebf248c12bda0b66021745))


### Bug Fixes

* port iam_users from postgresql module ([#467](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/467)) ([5732125](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/573212575b70325eb344dae7c7cf4086eb147f41))
* to avoid password reset for existing additional users ([#461](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/461)) ([1fcdcc4](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/1fcdcc4616ab37436e7344ed7530077e7221fa08))

## [15.0.0](https://github.com/terraform-google-modules/terraform-google-sql-db/compare/v14.1.0...v15.0.0) (2023-04-18)


### ⚠ BREAKING CHANGES

* pass iam_user_emails as map to postgres module ([#414](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/414))

### Features

* add deletion_protection.enabled for read replicas ([#437](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/437)) ([4cdb81c](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/4cdb81c86c702aebed269d82e7fcbbd92afa699d))
* added enable_private_path_for_google_cloud_services field in ip_configuration for google_sql_database_instance resource ([#449](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/449)) ([64618c4](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/64618c48df3a99052aad765d97e04dfcfd739479))
* support query insights for MySQL for read replicas ([#453](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/453)) ([59b32af](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/59b32af83e03da4b4dc0eb1fa6d5372dc4a3b696))


### Bug Fixes

* pass iam_user_emails as map to postgres module ([#414](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/414)) ([15298c2](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/15298c275e2d531e3379d1c445b2317c99e6363b))
* prevent auto-update of random_password resource ([#446](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/446)) ([ed83b8b](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/ed83b8b67875ac9641b99fb8071aa2cd196511a9))
* remove replica pwd validation config ([#441](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/441)) ([daa3772](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/daa3772575bbf0788e5754fed1a5b7384e55b1a9))

## [14.1.0](https://github.com/terraform-google-modules/terraform-google-sql-db/compare/v14.0.1...v14.1.0) (2023-03-15)


### Features

* increased timeout to 30m to support micro instances also. ([#425](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/425)) ([5ed6288](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/5ed6288d064e4cb18d435ab7e740ae9d8ed200b8))
* make connector enforcement configurable ([#439](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/439)) ([2df794b](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/2df794beefdbea5737e6ebd848c7ebecd4ec9a12))


### Bug Fixes

* random password for default user and additional users will also follow password validation policy ([#443](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/443)) ([0ceb0ed](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/0ceb0ed1fdd5fb12129ded7fff7eebf9bb3042fe))

## [14.0.1](https://github.com/terraform-google-modules/terraform-google-sql-db/compare/v14.0.0...v14.0.1) (2023-02-10)


### Bug Fixes

* make special chars opt in for generated passwords ([#421](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/421)) ([1c9ce24](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/1c9ce24b910802b58409731a99bca28135b29d42))
* updates the TF version constraint to 1.3 ([#419](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/419)) ([add16eb](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/add16eb6969334bdf85d0754467b0beea4a36db2))

## [14.0.0](https://github.com/terraform-google-modules/terraform-google-sql-db/compare/v13.0.1...v14.0.0) (2023-01-27)


### ⚠ BREAKING CHANGES

* Requires [Terraform](https://www.terraform.io/downloads.html) >= 1.3.0
* Add pwd validation policy for mysql modules ([#409](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/409))
* adds settings.deletion_protection_enabled to modules ([#404](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/404))
* Aligned the behaviour of additional_users resource in all 3 Cloud SQL instance modules. ([#398](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/398))
* Add ```deny_maintenance_period``` for MySQL, MsSQL, PostgreSQL and safer_sql ([#399](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/399))
* removes instanceUser iam binding from the postgresql module ([#382](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/382))
* Add Password Validation Policy to Postgres Module ([#376](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/376))
* Add name_override variable for MySQL, PostgreSQL and safer_sql to Override default read replica name ([#393](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/393))

### Features

* Add ```deny_maintenance_period``` for MySQL, MsSQL, PostgreSQL and safer_sql ([#399](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/399)) ([55f4206](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/55f4206e6fbb4f1d241a12563b6296166b895833))
* add `secondary_zone`, `follow_gae_application` to safer_mysql ([#390](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/390)) ([05cd2b6](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/05cd2b6983b0c88f3cbade94abdb1c74a0dc388c))
* Add name_override variable for MySQL, PostgreSQL and safer_sql to Override default read replica name ([#393](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/393)) ([045bed1](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/045bed1d212aeb8e7ec8bf89896c74fffec38f8a))
* Add Password Validation Policy to Postgres Module ([#376](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/376)) ([562455b](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/562455bf558c84cd856420374653c095d49b1f9c))
* Add pwd validation policy for mysql modules ([#409](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/409)) ([df8accd](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/df8accdea3091883e8aef9a2896ffa6f7a09582a))
* add Suffix to backup configurations ([#377](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/377)) ([0ea1968](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/0ea1968291957d3637724ebe8f69af48736a45e4))
* adds deletion_policy parameter for google_sql_user and google_sql_database resource. ([#386](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/386)) ([8ab6e37](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/8ab6e374dd74a8c3f5d6963640f9eb945cd996f5))
* adds settings.deletion_protection_enabled to modules ([#404](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/404)) ([af48cd3](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/af48cd39b510fa21b1c7c5b2a7a20b5085b04d57))
* adds settings.location_preference.follow_gae_application parameter to modules. ([#385](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/385)) ([edefa43](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/edefa43e0b42f382fc2f9e96d8a28cefea473c98))
* Aligned the behaviour of additional_users resource in all 3 Cloud SQL instance modules. ([#398](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/398)) ([7d6b209](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/7d6b2095f0e2312424c97a416dbb929d57c73eaa))


### Bug Fixes

* Added functionality to simply specify the database version number ins… ([#388](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/388)) ([83ca2e2](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/83ca2e2a2791325421162b68eafa6264a550ecfa))
* Added sensitive field in output "primary" in mssql module ([#394](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/394)) ([4b32479](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/4b32479921fa85ce1a477ad1415032d795dc3953))
* fixes lint issues and generates metadata ([#392](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/392)) ([dd1d75c](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/dd1d75cff8d21c16299a026edb88d3939daf99d1))
* made 'allocated_ip_range' variable optional ([#395](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/395)) ([243c1c5](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/243c1c556b801505fb6c1e35dd5ffe23091bce0b))
* removes instanceUser iam binding from the postgresql module ([#382](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/382)) ([cc39074](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/cc39074a0d6c9393be7fc05f9afd62bbc292ff4c))
* sensitive output safer mysql ([#401](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/401)) ([5cc5e08](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/5cc5e08d575f16f1cf588bd7fd28f3e50b29647d))

## [13.0.1](https://github.com/terraform-google-modules/terraform-google-sql-db/compare/v13.0.0...v13.0.1) (2022-11-11)


### Bug Fixes

* revert null provider version to major.minor ([#372](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/372)) ([b4c0555](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/b4c055536d4abe43d78590694dbc5605fd83d7ec))

## [13.0.0](https://github.com/terraform-google-modules/terraform-google-sql-db/compare/v12.1.0...v13.0.0) (2022-11-07)


### ⚠ BREAKING CHANGES

* **deps:** update terraform null to ~> 3.2.0 (#366)
* Make compression default for Backups
* Adds `secondary_zone` to db modules

### Features

* Adds `secondary_zone` to db modules ([7818a7e](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/7818a7e85107e8cfb149ced278749909eeb68b32))
* Support Query Insights for MySQL ([d932391](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/d932391484bb02d28b27618b75dda152cbd6dc90))


### Bug Fixes

* Db master and replica update solution for MYSQL ([f991c22](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/f991c22e618d77c280aa0aa496411a1df4ac8cb2))
* Make compression default for Backups ([ff37244](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/ff3724429a04b54d25bfea6eb3db68d78d1128bb))
* Postgresql availability type shouldn't prevent backup configuration ([#352](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/352)) ([e796b3c](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/e796b3cb44500bcc144fc28fc482111a461ad465)), closes [#351](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/351)
* removed invalid parameter for PostgrSQL binary_log_enabled ([#341](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/341)) ([b51427e](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/b51427ed2fee415f8d5d301374f8106c33fd0a12))


### Miscellaneous Chores

* **deps:** update terraform null to ~&gt; 3.2.0 ([#366](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/366)) ([643e6e5](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/643e6e58c24560f936ee6bb0574cde17e080fb10))

## [12.1.0](https://github.com/terraform-google-modules/terraform-google-sql-db/compare/v12.0.0...v12.1.0) (2022-10-07)


### Features

* Added cloud sql restore module that uses database import ([#343](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/343)) ([da4033b](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/da4033b0b2e12d66bbc3869d2be32096f2a685b8))


### Bug Fixes

* for_each issue on the sql_audit_config ([#340](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/340)) ([95e48a1](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/95e48a1473714fc5a5ba46b4dce69b21bb6e00d7))

## [12.0.0](https://github.com/terraform-google-modules/terraform-google-sql-db/compare/v11.0.0...v12.0.0) (2022-08-15)


### ⚠ BREAKING CHANGES

* Minimum Google Beta provider version increased to v4.28.0.
* Change additional user default password (#332)
* adds availability_type for read_replicas (#329)

### Features

* add support for settings.sql_server_audit_config setting ([64b8a18](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/64b8a186e19b2383e3b6f9b10e413fcc31814791))
* adds availability_type for read_replicas ([#329](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/329)) ([e26861e](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/e26861e5736d7001994ef7e99e72b4ecf6fea22c))
* Provide an option to compress backups for PostreSQL and MySQL ([#335](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/335)) ([b1ef34d](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/b1ef34d0ee1a84ef2c0be4141cb83448052264da))


### Bug Fixes

* Change additional user default password ([#332](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/332)) ([f96f71e](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/f96f71ed00e590a56083bb4faffc5b54e4583603))
* set replicas output as sensitive pgsql ([#334](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/334)) ([ad6f427](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/ad6f427e2063d6174eb77670772ab7b3b2153c74))

## [11.0.0](https://github.com/terraform-google-modules/terraform-google-sql-db/compare/v10.1.0...v11.0.0) (2022-06-02)


### ⚠ BREAKING CHANGES

* Switch to random_password instead of random_id (#308)
* Add support for setting disk_autoresize_limit (#288)
* add support for settings.active_directory_config for SQL module (#305)

### Features

* Add sensitive flag for MySQL module outputs ([#303](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/303)) ([6a15c26](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/6a15c26de30d7eb652857e5d077c980969a02990))
* Add support for setting disk_autoresize_limit ([#288](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/288)) ([e07f141](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/e07f14155e526ee205807bb85386a1bccce50c91))
* add support for settings.active_directory_config for SQL module ([#305](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/305)) ([449f1a2](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/449f1a2dbb522cda93eae8a574345356db7497f2))
* Switch to random_password instead of random_id ([#308](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/308)) ([9126ee6](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/9126ee6c38e085d922ce3e674b429d802577277a))

## [10.1.0](https://github.com/terraform-google-modules/terraform-google-sql-db/compare/v10.0.2...v10.1.0) (2022-05-13)


### Features

* Add a description variable for google_compute_global_address resource ([#299](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/299)) ([fe91aa5](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/fe91aa5093c03b8cc823c2f1f43c18f0b9d0812a))
* Create SQL Backup and export module ([#296](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/296)) ([c51bf29](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/c51bf296e392fca246aae1c9ba4299a5a97ef274))

### [10.0.2](https://github.com/terraform-google-modules/terraform-google-sql-db/compare/v10.0.1...v10.0.2) (2022-04-19)


### Bug Fixes

* added sensitive flag ([#294](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/294)) ([17da833](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/17da8338e8f0f6658797648d758988c676cee88f))

### [10.0.1](https://github.com/terraform-google-modules/terraform-google-sql-db/compare/v10.0.0...v10.0.1) (2022-03-16)


### Bug Fixes

* Add missing google-beta provider to required_providers ([#282](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/282)) ([714428c](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/714428cb50fc3a26caf8cb3e539d62ac092f67d1))
* Ignore changes to CMEK on read replicas ([#284](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/284)) ([b73b465](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/b73b465baabb89112958fc23c414885c02628b48))

## [10.0.0](https://github.com/terraform-google-modules/terraform-google-sql-db/compare/v9.0.0...v10.0.0) (2022-02-18)


### ⚠ BREAKING CHANGES

* `allocated_ip_range` must now be specified for instances; `allocated_ip_range = null` can be used to preserve old default.

### Features

* Add allocated_ip_range property to CloudSQL modules ([#277](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/277)) ([ab8c768](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/ab8c76836668b31ccb3999ed0825dafebac27111))


### Bug Fixes

* Ignore changes to root_password ([#279](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/279)) ([d8c9959](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/d8c99593631b5f8336b90abee4d483a27b31ac4d))

## [9.0.0](https://github.com/terraform-google-modules/terraform-google-sql-db/compare/v8.0.0...v9.0.0) (2022-01-28)


### ⚠ BREAKING CHANGES

* update TPG version constraints to allow 4.0, add Terraform 0.13 constraint  (#258)

### Features

* update TPG version constraints to allow 4.0, add Terraform 0.13 constraint  ([#258](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/258)) ([9cff52a](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/9cff52ad19b08364594f822b4e00788450702bf6))


### Bug Fixes

* add depends on replicas for user creation ([#268](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/268)) ([d45df79](https://github.com/terraform-google-modules/terraform-google-sql-db/commit/d45df79be9e2d429b6fa6b1cb1620d5242a252de))

## [8.0.0](https://www.github.com/terraform-google-modules/terraform-google-sql-db/compare/v7.1.0...v8.0.0) (2021-10-13)


### ⚠ BREAKING CHANGES

* `var.read_replicas` now requires an encryption key name. Set `encryption_key_name = null` to preserve the old behavior.

### Features

* Add CMEK support for cross-region read replicas ([#251](https://www.github.com/terraform-google-modules/terraform-google-sql-db/issues/251)) ([426724a](https://www.github.com/terraform-google-modules/terraform-google-sql-db/commit/426724a50d19ffe76a1a2571022903d53fe615b9))
* MySQL - Allow setting type for additional_users ([#237](https://www.github.com/terraform-google-modules/terraform-google-sql-db/issues/237)) ([e1a6fc7](https://www.github.com/terraform-google-modules/terraform-google-sql-db/commit/e1a6fc732f130d7f97e4672d7da993018f27f52f))

## [7.1.0](https://www.github.com/terraform-google-modules/terraform-google-sql-db/compare/v7.0.0...v7.1.0) (2021-09-10)


### Features

* Create random passwords for additional_users ([#236](https://www.github.com/terraform-google-modules/terraform-google-sql-db/issues/236)) ([94ef3de](https://www.github.com/terraform-google-modules/terraform-google-sql-db/commit/94ef3de432006bbeded6bb0b9d240d9c920a9a30))

## [7.0.0](https://www.github.com/terraform-google-modules/terraform-google-sql-db/compare/v6.0.0...v7.0.0) (2021-09-02)


### ⚠ BREAKING CHANGES

* [Deprecated](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance#authorized_gae_applications) attribute authorized_gae_applications has been removed. See [upgrade docs](https://cloud.google.com/sql/docs/mysql/deprecation-notice) for more details (#240)

### Bug Fixes

* delete deprecated attribute authorized_gae_applications ([#240](https://www.github.com/terraform-google-modules/terraform-google-sql-db/issues/240)) ([d35b23c](https://www.github.com/terraform-google-modules/terraform-google-sql-db/commit/d35b23c0ec844716d7fea6ac958bbf5fa63534bf))

## [6.0.0](https://www.github.com/terraform-google-modules/terraform-google-sql-db/compare/v5.1.1...v6.0.0) (2021-07-02)


### ⚠ BREAKING CHANGES

* `null` and `random` providers upgraded to `v3.x.x`.
* When setting the backup_configuration variable, transaction_log_retention_days, retained_backups, and retention_unit must be set. Use `null` to preserve default behavior.

### Features

* Added option to enable insights for replica instances ([#230](https://www.github.com/terraform-google-modules/terraform-google-sql-db/issues/230)) ([6b928f6](https://www.github.com/terraform-google-modules/terraform-google-sql-db/commit/6b928f6ac1a621c0e277bfebbabb32b5ce0d60c9))
* Added support for setting transaction_log_retention_days, retained_backups, and retention_unit to backup_configuration. ([#203](https://www.github.com/terraform-google-modules/terraform-google-sql-db/issues/203)) ([2237a3d](https://www.github.com/terraform-google-modules/terraform-google-sql-db/commit/2237a3d5c9e6944077ffa9c0bfa40ba07d4a3157))


### Miscellaneous Chores

* Update null and random providers ([#228](https://www.github.com/terraform-google-modules/terraform-google-sql-db/issues/228)) ([21d3771](https://www.github.com/terraform-google-modules/terraform-google-sql-db/commit/21d3771b93e3b5c1bb8e949be58641732313166d))

### [5.1.1](https://www.github.com/terraform-google-modules/terraform-google-sql-db/compare/v5.1.0...v5.1.1) (2021-05-27)


### Bug Fixes

* Properly handle null from being passed as password for additional_users ([#223](https://www.github.com/terraform-google-modules/terraform-google-sql-db/issues/223)) ([5facf6a](https://www.github.com/terraform-google-modules/terraform-google-sql-db/commit/5facf6aa5f4011eec6ed0a092f0c4d5a860eb6a1))

## [5.1.0](https://www.github.com/terraform-google-modules/terraform-google-sql-db/compare/v5.0.1...v5.1.0) (2021-05-19)


### Features

* extended the postgresql module to accept IAM users and services accounts ([#218](https://www.github.com/terraform-google-modules/terraform-google-sql-db/issues/218)) ([4c0472e](https://www.github.com/terraform-google-modules/terraform-google-sql-db/commit/4c0472eb94b8f410ef9092490ef626babf5bb8a7))


### Bug Fixes

* deprecates the usage of gcp-inspec and replaces integration tests with gcloud ([#216](https://www.github.com/terraform-google-modules/terraform-google-sql-db/issues/216)) ([b81ff73](https://www.github.com/terraform-google-modules/terraform-google-sql-db/commit/b81ff732d1240949b42471e6c02886d0f74b5525))

### [5.0.1](https://www.github.com/terraform-google-modules/terraform-google-sql-db/compare/v5.0.0...v5.0.1) (2021-04-22)


### Bug Fixes

* Add outputs for the actual `google_sql_database_instance` resources ([#193](https://www.github.com/terraform-google-modules/terraform-google-sql-db/issues/193)) ([70205b0](https://www.github.com/terraform-google-modules/terraform-google-sql-db/commit/70205b0023df9ff68783fc1b7a5c4adf2dda90ef))

## [5.0.0](https://www.github.com/terraform-google-modules/terraform-google-sql-db/compare/v4.5.0...v5.0.0) (2021-03-25)


### ⚠ BREAKING CHANGES

* add Terraform 0.13 constraint and module attribution (#202)

### Features

* Add support for configuring Query Insights on Postgres instances ([#198](https://www.github.com/terraform-google-modules/terraform-google-sql-db/issues/198)) ([2619b42](https://www.github.com/terraform-google-modules/terraform-google-sql-db/commit/2619b42df54a4bfe78726eee3a86e927b996e17d))
* add Terraform 0.13 constraint and module attribution ([#202](https://www.github.com/terraform-google-modules/terraform-google-sql-db/issues/202)) ([ec0911c](https://www.github.com/terraform-google-modules/terraform-google-sql-db/commit/ec0911c686e6d534fe89c73f0cfb4d3f31519c42))


### Bug Fixes

* remove empty string from replicas output lists ([#194](https://www.github.com/terraform-google-modules/terraform-google-sql-db/issues/194)) ([e14fc7a](https://www.github.com/terraform-google-modules/terraform-google-sql-db/commit/e14fc7a3fe41782d81a50f8674766e1752ec4f4e))

## [4.5.0](https://www.github.com/terraform-google-modules/terraform-google-sql-db/compare/v4.4.0...v4.5.0) (2021-01-27)


### Features

* add encryption_key_name to safer_mysql module ([#185](https://www.github.com/terraform-google-modules/terraform-google-sql-db/issues/185)) ([487397c](https://www.github.com/terraform-google-modules/terraform-google-sql-db/commit/487397c160ad698af7e3e01ccd175d4d72fcc2a0))
* Add variables for managing the creation of the default database and user (mysql) ([#170](https://www.github.com/terraform-google-modules/terraform-google-sql-db/issues/170)) ([5765a5f](https://www.github.com/terraform-google-modules/terraform-google-sql-db/commit/5765a5f8acfb6154e32c6c75f1ee3718b20d2f76))


### Bug Fixes

* Fix typo in database timeout description ([#166](https://www.github.com/terraform-google-modules/terraform-google-sql-db/issues/166)) ([55f135f](https://www.github.com/terraform-google-modules/terraform-google-sql-db/commit/55f135f78c100e89a1957f15625412b7a0bba0db))

## [4.4.0](https://www.github.com/terraform-google-modules/terraform-google-sql-db/compare/v4.3.0...v4.4.0) (2020-12-03)


### Features

* Add variable for managing the creation of the default database and user ([#163](https://www.github.com/terraform-google-modules/terraform-google-sql-db/issues/163)) ([eb300d3](https://www.github.com/terraform-google-modules/terraform-google-sql-db/commit/eb300d32ed1fe149e2f8d1ac8521de2fb967cd67))
* Update versions to allow for Terraform 0.14 (#165) (b13bbee)

## [4.3.0](https://www.github.com/terraform-google-modules/terraform-google-sql-db/compare/v4.2.0...v4.3.0) (2020-11-11)


### Features

* Add variable for managing read replica deletion protection ([#155](https://www.github.com/terraform-google-modules/terraform-google-sql-db/issues/155)) ([9e22cfd](https://www.github.com/terraform-google-modules/terraform-google-sql-db/commit/9e22cfd35f97608d6b5a76dd30c80299d5b782e3))
* Update all uses of zone to use the expected variable format. ([#156](https://www.github.com/terraform-google-modules/terraform-google-sql-db/issues/156)) ([5210126](https://www.github.com/terraform-google-modules/terraform-google-sql-db/commit/52101264c2aa53bc15372b72459c5475a8aaf795))

## [4.2.0](https://www.github.com/terraform-google-modules/terraform-google-sql-db/compare/v4.1.0...v4.2.0) (2020-10-23)


### Features

* **postgres:** Added point_in_time_recovery_enabled backup option for Postgres ([#142](https://www.github.com/terraform-google-modules/terraform-google-sql-db/issues/142)) ([1fcae8a](https://www.github.com/terraform-google-modules/terraform-google-sql-db/commit/1fcae8a4480e1720c83eb2cb9e84c4f768dc767f))
* Add deletion_protection variable, defaulted to true ([#151](https://www.github.com/terraform-google-modules/terraform-google-sql-db/issues/151)) ([69e1911](https://www.github.com/terraform-google-modules/terraform-google-sql-db/commit/69e19111f8cd0fa60edea437d48e8d8a2ead1f94))

## [4.1.0](https://www.github.com/terraform-google-modules/terraform-google-sql-db/compare/v4.0.0...v4.1.0) (2020-10-06)


### Features

* Add support for backup_configuration to mssql database submodule ([#143](https://www.github.com/terraform-google-modules/terraform-google-sql-db/issues/143)) ([bed1cb4](https://www.github.com/terraform-google-modules/terraform-google-sql-db/commit/bed1cb487de3858c9eccfae9ebd3707f94569e0c))

## [4.0.0](https://www.github.com/terraform-google-modules/terraform-google-sql-db/compare/v3.2.0...v4.0.0) (2020-08-26)


### ⚠ BREAKING CHANGES

* Replica configuration has been reworked. Please see the upgrade guide for details.
* Users and databases have been moved and require a state migration. See the upgrade guide for details.

### Features

* Add encryption_key_name variable for MS SQL module ([#132](https://www.github.com/terraform-google-modules/terraform-google-sql-db/issues/132)) ([2bd0f41](https://www.github.com/terraform-google-modules/terraform-google-sql-db/commit/2bd0f41ba4ecd321f32f17dda36f7fa04dad1a41))
* Add location support to backup_configuration block ([#126](https://www.github.com/terraform-google-modules/terraform-google-sql-db/issues/126)) ([aa907bd](https://www.github.com/terraform-google-modules/terraform-google-sql-db/commit/aa907bd75281991445962fab2d70d04e21492a19))
* add SQL Server support with new submodule ([#112](https://www.github.com/terraform-google-modules/terraform-google-sql-db/issues/112)) ([4a775fb](https://www.github.com/terraform-google-modules/terraform-google-sql-db/commit/4a775fbfbc628df9573cdbc7443a2a47ed3a16e3))
* Added random_id option for instance name ([#116](https://www.github.com/terraform-google-modules/terraform-google-sql-db/issues/116)) ([7c8c799](https://www.github.com/terraform-google-modules/terraform-google-sql-db/commit/7c8c799552f0567d71df287770936d53b2bd8138))
* Rework replicas to use `for_each` and new configuration style ([5e1ae20](https://www.github.com/terraform-google-modules/terraform-google-sql-db/commit/5e1ae20e5b7efdbb35f733897f5a4378389337d3))


### Bug Fixes

* Fix issue with replica state key and random IDs ([#141](https://www.github.com/terraform-google-modules/terraform-google-sql-db/issues/141)) ([71b51fd](https://www.github.com/terraform-google-modules/terraform-google-sql-db/commit/71b51fd0d4687f7c2cecf85724649a2d9785e053))
* Update versions to allow for Terraform 0.13 ([#135](https://www.github.com/terraform-google-modules/terraform-google-sql-db/issues/135)) ([86c533a](https://www.github.com/terraform-google-modules/terraform-google-sql-db/commit/86c533a65a2cb3d3602bb5ef1f1e1b81b4b8fa15))
* **docs:** Update links for database flags on postgresql and mysql ([#134](https://www.github.com/terraform-google-modules/terraform-google-sql-db/issues/134)) ([e6a31ca](https://www.github.com/terraform-google-modules/terraform-google-sql-db/commit/e6a31cad5cbb15fa3716edeebe5b1e3421e09d60))
* Relax Provider version ([#133](https://www.github.com/terraform-google-modules/terraform-google-sql-db/issues/133)) ([ec2a109](https://www.github.com/terraform-google-modules/terraform-google-sql-db/commit/ec2a1092a71c41abd68d974bcd03afc0ede07fd0))
* Updated users and databases creation to use for_each ([#100](https://www.github.com/terraform-google-modules/terraform-google-sql-db/issues/100)) ([d433995](https://www.github.com/terraform-google-modules/terraform-google-sql-db/commit/d4339956caa9d16ea07b3d99925b926765322894))

## [3.2.0](https://www.github.com/terraform-google-modules/terraform-google-sql-db/compare/v3.1.0...v3.2.0) (2020-04-24)


### Features

* Added "encryption_key_name" variable for postgresql and mysql modules. ([#101](https://www.github.com/terraform-google-modules/terraform-google-sql-db/issues/101)) ([cf87a9d](https://www.github.com/terraform-google-modules/terraform-google-sql-db/commit/cf87a9d1490d5970f3557866b1ad2508115904c5))
* Support new regional HA for MySQL ([#99](https://www.github.com/terraform-google-modules/terraform-google-sql-db/issues/99)) ([d3ed591](https://www.github.com/terraform-google-modules/terraform-google-sql-db/commit/d3ed591f4d3ef425f0afca908b0b692626e4f0da))


### Bug Fixes

* Disable binary_logging option as it is not valid for Postgres instances ([#94](https://www.github.com/terraform-google-modules/terraform-google-sql-db/issues/94)) ([c74b15d](https://www.github.com/terraform-google-modules/terraform-google-sql-db/commit/c74b15d09298e0821b2e5da3996fc0839c13ffeb))

## [3.1.0](https://www.github.com/terraform-google-modules/terraform-google-sql-db/compare/v3.0.0...v3.1.0) (2020-02-11)


### Features

* Update google and google-beta provider versions to ~>3.5 ([#87](https://www.github.com/terraform-google-modules/terraform-google-sql-db/issues/87)) ([706b173](https://www.github.com/terraform-google-modules/terraform-google-sql-db/commit/706b173e9a4f586e50f306fa055aad4e337e7b69))

## [3.0.0] - 2019-12-17

### Removed

- Removed variable `peering_completed`. [#78]

### Added

- The `public_ip_address`, `private_ip_address`, and `instance_address` outputs to the `mysql` submodule, the `postgresql`
submodule, and the `safer_mysql` submodule. [#76]
- Added variable `module_depends_on`. [#78]

### Changed

- Renamed output `instance_address` to `instance_ip_address` in `mysql`, `postgresql` and `safer_mysql` submodules. [#83]

## [2.0.0] - 2019-09-26

2.0.0 is a backward incompatible release. Review the
[upgrade guide](docs/upgrading_to_sql_db_2.0.0.md) for more information.

### Added

- `peering_completed` marker to postgresql module [#43]
- `private_address` to postgresql module [#43]

### Changed

- Added support for Terraform 0.12 [#53]
- the root module has been deprecated [#56]

### Fixed

- The network reference in the `private_service_access` module uses the
  self link. [#61]

## [1.2.0] - 2019-07-30

## [1.1.2] - 2019-06-14

## [1.1.1] - 2019-03-15

## [1.1.0] - 2019-02-28

## [1.0.1] - 2019-02-14

## [1.0.0] - 2019-02-14

[Unreleased]: https://github.com/terraform-google-modules/terraform-google-sql-db/compare/v3.0.0...HEAD
[3.0.0]: https://github.com/terraform-google-modules/terraform-google-sql-db/compare/v2.0.0...v3.0.0
[2.0.0]: https://github.com/terraform-google-modules/terraform-google-sql-db/compare/v1.2.0...v2.0.0
[1.2.0]: https://github.com/terraform-google-modules/terraform-google-sql-db/compare/1.1.2...v1.2.0
[1.1.2]: https://github.com/terraform-google-modules/terraform-google-sql-db/compare/1.1.1...1.1.2
[1.1.1]: https://github.com/terraform-google-modules/terraform-google-sql-db/compare/1.1.0...1.1.1
[1.1.0]: https://github.com/terraform-google-modules/terraform-google-sql-db/compare/1.0.1...1.1.0
[1.0.1]: https://github.com/terraform-google-modules/terraform-google-sql-db/compare/1.0.0...1.0.1
[1.0.0]: https://github.com/terraform-google-modules/terraform-google-sql-db/releases/tag/1.0.0

[#83]: https://github.com/terraform-google-modules/terraform-google-sql-db/pull/83
[#78]: https://github.com/terraform-google-modules/terraform-google-sql-db/pull/78
[#76]: https://github.com/terraform-google-modules/terraform-google-sql-db/pull/76
[#61]: https://github.com/terraform-google-modules/terraform-google-sql-db/pull/61
[#56]: https://github.com/terraform-google-modules/terraform-google-sql-db/pull/56
[#53]: https://github.com/terraform-google-modules/terraform-google-sql-db/pull/53
[#43]: https://github.com/terraform-google-modules/terraform-google-sql-db/pull/43
