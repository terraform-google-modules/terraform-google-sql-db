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

package postgresql_ha

import (
	"fmt"
	"testing"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/utils"
	"github.com/stretchr/testify/assert"
)

func TestPostgreSqlHaModule(t *testing.T) {
	pSql := tft.NewTFBlueprintTest(t)

	pSql.DefineVerify(func(assert *assert.Assertions) {
		pSql.DefaultVerify(assert)

		instaceNames := []string{pSql.GetStringOutput("name")}
		op := gcloud.Run(t, fmt.Sprintf("sql instances describe %s --project %s", instaceNames[0], pSql.GetStringOutput("project_id")))
		assert.Equal(1, len(op.Get("replicaNames").Array()), "Expected 1 replicas")
		instaceNames = append(instaceNames, utils.GetResultStrSlice(op.Get("replicaNames").Array())...)

		for _, instance := range instaceNames {
			op = gcloud.Run(t, fmt.Sprintf("sql instances describe %s --project %s", instance, pSql.GetStringOutput("project_id")))

			// assert general database settings
			assert.Equal("ALWAYS", op.Get("settings.activationPolicy").String(), "Expected ALWAYS activationPolicy")
			assert.Equal(int64(10), op.Get("settings.dataDiskSizeGb").Int(), "Expected 10 dataDiskSizeGb")
			assert.Equal("sql#settings", op.Get("settings.kind").String(), "Expected sql#settings kind")
			assert.Equal("PER_USE", op.Get("settings.pricingPlan").String(), "Expected PER_USE pricingPlan")
			assert.Equal("SYNCHRONOUS", op.Get("settings.replicationType").String(), "Expected SYNCHRONOUS replicationType")
			assert.True(op.Get("settings.storageAutoResize").Bool(), "Expected TRUE storageAutoResize")
			assert.Equal(int64(0), op.Get("settings.storageAutoResizeLimit").Int(), "Expected 0 storageAutoResizeLimit")
			assert.Equal("db-custom-1-3840", op.Get("settings.tier").String(), "Expected db-custom-1-3840 tier")

			// assert database flags
			assert.JSONEq(`{"name": "autovacuum", "value": "off"}`, op.Get("settings.databaseFlags").Array()[0].Raw, `Expected {"name": "autovacuum", "value": "off"} databaseFlags`)

			// assert network settings
			authNetworks := op.Get("settings.ipConfiguration.authorizedNetworks").Array()
			assert.Equal(1, len(authNetworks), "Expected one auth network")
			authNetworkMap := authNetworks[0].Map()
			assert.Equal(fmt.Sprintf("%s-cidr", pSql.GetStringOutput("project_id")), authNetworkMap["name"].String(), "Expected auth network")
			assert.Equal(pSql.GetStringOutput("authorized_network"), authNetworkMap["value"].String(), "Expected auth network within cdir range")

			/// assert standard database settings
			assert.Equal("POSTGRES_9_6", op.Get("databaseVersion").String(), "Expected POSTGRES_9_6 databaseVersion")
			assert.Equal("SECOND_GEN", op.Get("backendType").String(), "Expected SECOND_GEN backendType")
			assert.Equal("RUNNABLE", op.Get("state").String(), "Expected RUNNABLE state")
			assert.Equal("us-central1", op.Get("region").String(), "Expected us-central1 region")

			// master specific validation
			if instance == pSql.GetStringOutput("name") {
				// assert general database settings
				assert.Equal("REGIONAL", op.Get("settings.availabilityType").String(), "Expected REGIONAL availabilityType")
				assert.Equal("PD_SSD", op.Get("settings.dataDiskType").String(), "Expected PD_SSD dataDiskType")
				assert.True(op.Get("settings.ipConfiguration.requireSsl").Bool(), "Expected TRUE SSL")

				// assert user labels
				assert.JSONEq(`{"foo": "bar"}`, op.Get("settings.userLabels").Raw, `Expected {"foo": "bar"} userLabels`)

				// assert location database settings
				assert.Equal("sql#locationPreference", op.Get("settings.locationPreference.kind").String(), "Expected sql#locationPreference locationPreference.kind")
				assert.Equal("us-central1-c", op.Get("settings.locationPreference.zone").String(), "Expected us-central1-c locationPreference.zone")
				assert.Equal("us-central1-c", op.Get("gceZone").String(), "Expected us-central1-c gceZone")

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

				// assert users
				op = gcloud.Run(t, fmt.Sprintf("sql users list --instance %s --project %s", pSql.GetStringOutput("name"), pSql.GetStringOutput("project_id")))
				assert.Equal(4, len(op.Array()), "Expected at least 4 users")

				// replica specific validation
			} else {
				// assert general database settings
				assert.Equal("REGIONAL", op.Get("settings.availabilityType").String(), "Expected REGIONAL availabilityType")
				assert.Equal("PD_HDD", op.Get("settings.dataDiskType").String(), "Expected PD_HDD dataDiskType")
				assert.False(op.Get("settings.ipConfiguration.requireSsl").Bool(), "Expected FALSE SSL")

				// assert user labels
				assert.JSONEq(`{"bar": "baz"}`, op.Get("settings.userLabels").Raw, `Expected {"bar": "baz"} userLabels`)
			}
		}
	})

	pSql.Test()
}
