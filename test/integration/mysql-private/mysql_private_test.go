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

package mysql_private

import (
	"fmt"
	"testing"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/stretchr/testify/assert"
)

func TestMySqlPrivateModule(t *testing.T) {

	const databaseVersion = "MYSQL_5_6"
	const backendType = "SECOND_GEN"
	const state = "RUNNABLE"
	const region = "us-central1"
	const gceZone = "us-central1-c"

	const activationPolicy = "ALWAYS"
	const dataDiskSizeGb = int64(10)
	const dataDiskType = "PD_SSD"
	const kind = "sql#settings"
	const pricingPlan = "PER_USE"
	const replicationType = "SYNCHRONOUS"
	const storageAutoResize = true
	const storageAutoResizeLimit = int64(0)
	const tier = "db-n1-standard-1"

	const locationPreferenceKind = "sql#locationPreference"
	const locationPreferenceZone = gceZone

	const maintenanceWindowKind = "sql#maintenanceWindow"
	const maintenanceWindowDay = int64(1)
	const maintenanceWindowHour = int64(23)
	const maintenanceWindowUpdateTrack = "stable"

	mySql := tft.NewTFBlueprintTest(t)

	mySql.DefineVerify(func(assert *assert.Assertions) {
		mySql.DefaultVerify(assert)

		op := gcloud.Run(t, fmt.Sprintf("sql instances describe %s --project %s", mySql.GetStringOutput("name"), mySql.GetStringOutput("project_id")))

		// assert general database settings
		assert.Equalf(op.Get("settings.activationPolicy").String(), activationPolicy, "Expected activationPolicy [%s]", activationPolicy)
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

		// assert maintenance windows
		assert.Equalf(op.Get("settings.maintenanceWindow.kind").String(), maintenanceWindowKind, "Expected maintenanceWindow.kind [%s]", maintenanceWindowKind)
		assert.Equalf(op.Get("settings.maintenanceWindow.day").Int(), maintenanceWindowDay, "Expected maintenanceWindow.day [%v]", maintenanceWindowDay)
		assert.Equalf(op.Get("settings.maintenanceWindow.hour").Int(), maintenanceWindowHour, "Expected maintenanceWindow.hour [%v]", maintenanceWindowHour)
		assert.Equalf(op.Get("settings.maintenanceWindow.updateTrack").String(), maintenanceWindowUpdateTrack, "Expected maintenanceWindow.updateTrack [%s]", maintenanceWindowUpdateTrack)

		// assert standard database settings
		assert.Equalf(op.Get("databaseVersion").String(), databaseVersion, "Expected databaseVersion [%s]", databaseVersion)
		assert.Equalf(op.Get("backendType").String(), backendType, "Expected backendType [%s]", backendType)
		assert.Equalf(op.Get("state").String(), state, "Expected state [%s]", state)
		assert.Equalf(op.Get("region").String(), region, "Expected region [%s]", region)
		assert.Equalf(op.Get("gceZone").String(), gceZone, "Expected gceZone [%s]", gceZone)

		// assert ip database settings
		ipAddresses := op.Get("ipAddresses").Array()
		assert.Equal(len(ipAddresses), 2, "Expected 2 addresses")
		assert.Equalf(ipAddresses[0].Get("ipAddress").String(), mySql.GetStringOutput("public_ip_address"), "Expected PublicIp [%s]", mySql.GetStringOutput("public_ip_address"))
		assert.Equal(ipAddresses[0].Get("type").String(), "PRIMARY")
		assert.Equalf(ipAddresses[1].Get("ipAddress").String(), mySql.GetStringOutput("private_ip_address"), "Expected PrivateIp [%s]", mySql.GetStringOutput("private_ip_address"))
		assert.Equal(ipAddresses[1].Get("type").String(), "PRIVATE")

		op = gcloud.Run(t, fmt.Sprintf("compute addresses list --global --filter='%s' --project %s", mySql.GetStringOutput("reserved_range_name"), mySql.GetStringOutput("project_id")))
		assert.Equal(len(op.Array()), 1, "Expected one peering setup")
	})

	mySql.Test()
}
