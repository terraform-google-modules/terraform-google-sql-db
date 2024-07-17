// Copyright 2022 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package postgresql_cross_region_failover

import (
	"fmt"
	"testing"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/stretchr/testify/assert"
)

func TestPostgreSqlCrossRegionFailover(t *testing.T) {
	pSql := tft.NewTFBlueprintTest(t)

	pSql.DefineVerify(func(assert *assert.Assertions) {
		// pSql.DefaultVerify(assert)

		projectID := pSql.GetStringOutput("project_id")
		instace1Name := pSql.GetStringOutput("instance1_name")
		kmsKeyName1 := pSql.GetStringOutput("kms_key_name1")
		instace2Name := pSql.GetStringOutput("instance2_name")
		masterInstanceName := pSql.GetStringOutput("master_instance_name")

		op := gcloud.Run(t, fmt.Sprintf("sql instances describe %s --project %s", instace1Name, projectID))
		assert.Equal(instace1Name, op.Get("name").String(), "Expected instance name")
		assert.Equal("CLOUD_SQL_INSTANCE", op.Get("instanceType").String(), "Expected instanceType CLOUD_SQL_INSTANCE")

		assert.Equal("ALWAYS", op.Get("settings.activationPolicy").String(), "Expected ALWAYS activationPolicy")
		assert.Equal(int64(10), op.Get("settings.dataDiskSizeGb").Int(), "Expected 10 dataDiskSizeGb")
		assert.Equal("sql#settings", op.Get("settings.kind").String(), "Expected sql#settings kind")
		assert.Equal("PER_USE", op.Get("settings.pricingPlan").String(), "Expected PER_USE pricingPlan")
		assert.Equal("SYNCHRONOUS", op.Get("settings.replicationType").String(), "Expected SYNCHRONOUS replicationType")
		assert.True(op.Get("settings.storageAutoResize").Bool(), "Expected TRUE storageAutoResize")
		assert.Equal(int64(0), op.Get("settings.storageAutoResizeLimit").Int(), "Expected 0 storageAutoResizeLimit")
		assert.Equal("db-perf-optimized-N-2", op.Get("settings.tier").String(), "Expected db-perf-optimized-N-2 tier")
		assert.Equal("ENTERPRISE_PLUS", op.Get("settings.edition").String(), "Expected edition ENTERPRISE_PLUS")
		assert.True(op.Get("settings.insightsConfig.queryInsightsEnabled").Bool(), "Expected queryInsightsEnabled true")
		assert.Equal("5", op.Get("settings.insightsConfig.queryPlansPerMinute").String(), "Expected queryPlansPerMinute 5")

		// assert database flags
		assert.JSONEq(`{"name": "autovacuum", "value": "off"}`, op.Get("settings.databaseFlags").Array()[0].Raw, `Expected {"name": "autovacuum", "value": "off"} databaseFlags`)

		// assert network settings
		authNetworks := op.Get("settings.ipConfiguration.authorizedNetworks").Array()
		assert.Equal(1, len(authNetworks), "Expected one auth network")

		/// assert standard database settings
		assert.Equal("POSTGRES_14", op.Get("databaseVersion").String(), "Expected POSTGRES_14 databaseVersion")
		assert.Equal("SECOND_GEN", op.Get("backendType").String(), "Expected SECOND_GEN backendType")
		assert.Equal("RUNNABLE", op.Get("state").String(), "Expected RUNNABLE state")
		assert.Equal("us-central1", op.Get("region").String(), "Expected us-central1 region")

		// assert general database settings
		assert.Equal("REGIONAL", op.Get("settings.availabilityType").String(), "Expected REGIONAL availabilityType")
		assert.Equal("PD_SSD", op.Get("settings.dataDiskType").String(), "Expected PD_SSD dataDiskType")
		assert.True(op.Get("settings.ipConfiguration.requireSsl").Bool(), "Expected TRUE SSL")

		// assert user labels
		assert.JSONEq(`{"foo": "bar", "instance": "instance-1"}`, op.Get("settings.userLabels").Raw, `Expected {"foo": "bar", "instance": "instance-1"} userLabels`)

		// assert maintenance windows
		assert.Equal("sql#maintenanceWindow", op.Get("settings.maintenanceWindow.kind").String(), "Expected sql#maintenanceWindow maintenanceWindow.kind")
		assert.Equal(int64(7), op.Get("settings.maintenanceWindow.day").Int(), "Expected 7 maintenanceWindow.day")
		assert.Equal(int64(12), op.Get("settings.maintenanceWindow.hour").Int(), "Expected 12 maintenanceWindow.hour")
		assert.Equal("stable", op.Get("settings.maintenanceWindow.updateTrack").String(), "Expected stable maintenanceWindow.updateTrack")

		// assert backup configuration
		assert.Equal("sql#backupConfiguration", op.Get("settings.backupConfiguration.kind").String(), "Expected sql#backupConfiguration backupConfigurationKind")
		assert.Equal("20:55", op.Get("settings.backupConfiguration.startTime").String(), "Expected 20:55 backupConfigurationStartTime")
		assert.True(op.Get("settings.backupConfiguration.enabled").Bool(), "Expected TRUE backupConfigurationEnabled")
		assert.Equal(int64(365), op.Get("settings.backupConfiguration.backupRetentionSettings.retainedBackups").Int(), "Expected 365 backupConfigurationRetainedBackups")
		assert.Equal("COUNT", op.Get("settings.backupConfiguration.backupRetentionSettings.retentionUnit").String(), "Expected COUNT backupConfigurationRetentionUnit")
		assert.True(op.Get("settings.backupConfiguration.pointInTimeRecoveryEnabled").Bool(), "Expected TRUE SSL")
		assert.Equal("14", op.Get("settings.backupConfiguration.transactionLogRetentionDays").String(), "Expected transactionLogRetentionDays 14")

		// assert Encryption configuration
		assert.Equal("sql#diskEncryptionConfiguration", op.Get("diskEncryptionConfiguration.kind").String(), "Expected sql#backupConfiguration backupConfigurationKind")
		assert.Equal(kmsKeyName1, op.Get("diskEncryptionConfiguration.kmsKeyName").String(), "Expected kms key name")

		// assert Replicas
		replicaNames := op.Get("replicaNames").Array()
		assert.Equal(2, len(replicaNames), "Expected 2 replicas")

		assert.True(op.Get("settings.dataCacheConfig.dataCacheEnabled").Bool(), "Expected dataCacheConfig true")

		op2 := gcloud.Run(t, fmt.Sprintf("sql instances describe %s --project %s", instace2Name, projectID))
		assert.Equal(instace2Name, op2.Get("name").String(), "Expected instance2 name")
		assert.Equal("READ_REPLICA_INSTANCE", op2.Get("instanceType").String(), "Expected instanceType READ_REPLICA_INSTANCE")
		assert.Equal("us-east1", op2.Get("region").String(), "Expected us-east1 region")
		assert.Equal(projectID + ":" + masterInstanceName, op2.Get("masterInstanceName").String(), "Expected master instance name")
	})

	pSql.Test()
}
