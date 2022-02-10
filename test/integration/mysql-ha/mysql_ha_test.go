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

package mysql_ha

import (
	"fmt"
	"testing"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/stretchr/testify/assert"
)

func TestMySqlHaModule(t *testing.T) {

	const databaseVersion = "MYSQL_5_7"
	const backendType = "SECOND_GEN"
	const state = "RUNNABLE"
	const region = "us-central1"

	const activationPolicy = "ALWAYS"
	const dataDiskSizeGb = int64(10)
	const kind = "sql#settings"
	const pricingPlan = "PER_USE"
	const replicationType = "SYNCHRONOUS"
	const storageAutoResize = true
	const storageAutoResizeLimit = int64(0)
	const tier = "db-n1-standard-1"

	const locationPreferenceKind = "sql#locationPreference"

	const maintenanceWindowKind = "sql#maintenanceWindow"
	const maintenanceWindowDay = int64(7)
	const maintenanceWindowHour = int64(12)
	const maintenanceWindowUpdateTrack = "stable"

	const databaseFlags = `{
        "name": "long_query_time",
        "value": "1"
      }`

	const binaryLogEnabled = true
	const backupConfigurationEnabled = true
	const backupConfigurationKind = "sql#backupConfiguration"
	const backupConfigurationStartTime = "20:55"
	const backupConfigurationRetainedBackups = int64(365)
	const backupConfigurationRetentionUnit = "COUNT"

	mySql := tft.NewTFBlueprintTest(t)

	mySql.DefineVerify(func(assert *assert.Assertions) {
		mySql.DefaultVerify(assert)

		zone := []string{"c", "a", "b", "c"}
		instaceNames := []string{mySql.GetStringOutput("name")}
		op := gcloud.Run(t, fmt.Sprintf("sql instances describe %s --project %s", instaceNames[0], mySql.GetStringOutput("project_id")))
		assert.Equal(len(op.Get("replicaNames").Array()), 3, "Expected 3 replicas")
		instaceNames = append(instaceNames, op.Get("replicaNames").Array()[0].String())
		instaceNames = append(instaceNames, op.Get("replicaNames").Array()[1].String())
		instaceNames = append(instaceNames, op.Get("replicaNames").Array()[2].String())

		for idx, instance := range instaceNames {
			op = gcloud.Run(t, fmt.Sprintf("sql instances describe %s --project %s", instance, mySql.GetStringOutput("project_id")))

			// Master instance values
			gceZone := fmt.Sprintf("%s-c", region)
			locationPreferenceZone := gceZone
			availabilityType := "REGIONAL"
			dataDiskType := "PD_SSD"
			sslRequired := "true"
			userLabels := `{"foo": "bar"}`
			isMaster := true

			// Replica instance values
			if instance != mySql.GetStringOutput("name") {
				gceZone = fmt.Sprintf("%s-%s", region, zone[idx])
				locationPreferenceZone = gceZone
				availabilityType = "ZONAL"
				dataDiskType = "PD_HDD"
				sslRequired = "false"
				userLabels = `{"bar": "baz"}`
				isMaster = false
			}

			// assert general database settings
			assert.Equalf(op.Get("settings.activationPolicy").String(), activationPolicy, "Expected activationPolicy [%s]", activationPolicy)
			assert.Equalf(op.Get("settings.availabilityType").String(), availabilityType, "Expected availabilityType [%s]", availabilityType)
			assert.Equalf(op.Get("settings.dataDiskSizeGb").Int(), dataDiskSizeGb, "Expected dataDiskSizeGb [%v]", dataDiskSizeGb)
			assert.Equalf(op.Get("settings.dataDiskType").String(), dataDiskType, "Expected dataDiskType [%s]", dataDiskType)
			assert.Equalf(op.Get("settings.kind").String(), kind, "Expected kind [%s]", kind)
			assert.Equalf(op.Get("settings.pricingPlan").String(), pricingPlan, "Expected pricingPlan [%s]", pricingPlan)
			assert.Equalf(op.Get("settings.replicationType").String(), replicationType, "Expected replicationType [%s]", replicationType)
			assert.Truef(op.Get("settings.storageAutoResize").Bool(), "Expected storageAutoResize [%t]", storageAutoResize)
			assert.Equalf(op.Get("settings.storageAutoResizeLimit").Int(), storageAutoResizeLimit, "Expected storageAutoResizeLimit [%v]", storageAutoResizeLimit)
			assert.Equalf(op.Get("settings.tier").String(), tier, "Expected tier [%s]", tier)

			// assert location database settings
			assert.Equalf(op.Get("settings.locationPreference.kind").String(), locationPreferenceKind, "Expected locationPreference.kind [%s]", locationPreferenceKind)
			assert.Equalf(op.Get("settings.locationPreference.zone").String(), locationPreferenceZone, "Expected locationPreference.zone [%s]", locationPreferenceZone)

			// assert user labels
			assert.JSONEqf(op.Get("settings.userLabels").Raw, userLabels, "Expected userLabels [%s]", userLabels)

			// assert database flags
			assert.JSONEqf(op.Get("settings.databaseFlags").Array()[0].Raw, databaseFlags, "Expected databaseFlags [%s]", databaseFlags)

			// assert network settings
			authNetworks := op.Get("settings.ipConfiguration.authorizedNetworks").Array()
			assert.Equal(len(authNetworks), 1, "Expected one auth network")
			assert.Equalf(op.Get("settings.ipConfiguration.requireSsl").String(), sslRequired, "Expected SSL to be [%s]", sslRequired)
			authNetworkMap := authNetworks[0].Map()
			assert.Equal(authNetworkMap["name"].String(), fmt.Sprintf("%s-cidr", mySql.GetStringOutput("project_id")), "Expected auth network")
			assert.Equal(authNetworkMap["value"].String(), mySql.GetStringOutput("authorized_network"), "Expected auth network within cdir range")

			// assert standard database settings
			assert.Equalf(op.Get("databaseVersion").String(), databaseVersion, "Expected databaseVersion [%s]", databaseVersion)
			assert.Equalf(op.Get("backendType").String(), backendType, "Expected backendType [%s]", backendType)
			assert.Equalf(op.Get("state").String(), state, "Expected state [%s]", state)
			assert.Equalf(op.Get("region").String(), region, "Expected region [%s]", region)
			assert.Equalf(op.Get("gceZone").String(), gceZone, "Expected gceZone [%s]", gceZone)

			if isMaster {
				// assert maintenance windows
				assert.Equalf(op.Get("settings.maintenanceWindow.kind").String(), maintenanceWindowKind, "Expected maintenanceWindow.kind [%s]", maintenanceWindowKind)
				assert.Equalf(op.Get("settings.maintenanceWindow.day").Int(), maintenanceWindowDay, "Expected maintenanceWindow.day [%v]", maintenanceWindowDay)
				assert.Equalf(op.Get("settings.maintenanceWindow.hour").Int(), maintenanceWindowHour, "Expected maintenanceWindow.hour [%v]", maintenanceWindowHour)
				assert.Equalf(op.Get("settings.maintenanceWindow.updateTrack").String(), maintenanceWindowUpdateTrack, "Expected maintenanceWindow.updateTrack [%s]", maintenanceWindowUpdateTrack)

				// assert backup configuration
				assert.Equalf(op.Get("settings.backupConfiguration.kind").String(), backupConfigurationKind, "Expected backupConfigurationKind [%s]", backupConfigurationKind)
				assert.Equalf(op.Get("settings.backupConfiguration.startTime").String(), backupConfigurationStartTime, "Expected backupConfigurationStartTime [%s]", backupConfigurationStartTime)
				assert.Truef(op.Get("settings.backupConfiguration.binaryLogEnabled").Bool(), "Expected binaryLogEnabled [%t]", binaryLogEnabled)
				assert.Truef(op.Get("settings.backupConfiguration.enabled").Bool(), "Expected backupConfigurationEnabled [%t]", backupConfigurationEnabled)
				assert.Equalf(op.Get("settings.backupConfiguration.backupRetentionSettings.retainedBackups").Int(), backupConfigurationRetainedBackups, "Expected backupConfigurationRetainedBackups [%v]", backupConfigurationRetainedBackups)
				assert.Equalf(op.Get("settings.backupConfiguration.backupRetentionSettings.retentionUnit").String(), backupConfigurationRetentionUnit, "Expected backupConfigurationRetentionUnit [%s]", backupConfigurationRetentionUnit)

				// assert users
				op = gcloud.Run(t, fmt.Sprintf("sql users list --instance %s --project %s", mySql.GetStringOutput("name"), mySql.GetStringOutput("project_id")))
				assert.Equal(len(op.Array()), 2, "Expected at least 3 users")
			}
		}
	})

	mySql.Test()
}
