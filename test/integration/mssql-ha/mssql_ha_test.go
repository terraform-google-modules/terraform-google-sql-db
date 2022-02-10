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

package mssql_ha

import (
	"fmt"
	"testing"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/stretchr/testify/assert"
)

func TestMsSqlHaModule(t *testing.T) {

	const databaseVersion = "SQLSERVER_2017_STANDARD"
	const backendType = "SECOND_GEN"
	const state = "RUNNABLE"
	const region = "us-central1"
	const gceZone = "us-central1-a"

	const activationPolicy = "ALWAYS"
	const availabilityType = "REGIONAL"
	const dataDiskSizeGb = int64(10)
	const dataDiskType = "PD_SSD"
	const kind = "sql#settings"
	const pricingPlan = "PER_USE"
	const replicationType = "SYNCHRONOUS"
	const storageAutoResize = true
	const storageAutoResizeLimit = int64(0)
	const tier = "db-custom-1-3840"

	const locationPreferenceKind = "sql#locationPreference"
	const locationPreferenceZone = gceZone

	const maintenanceWindowKind = "sql#maintenanceWindow"
	const maintenanceWindowDay = int64(7)
	const maintenanceWindowHour = int64(12)
	const maintenanceWindowUpdateTrack = "stable"

	msSql := tft.NewTFBlueprintTest(t)

	msSql.DefineVerify(func(assert *assert.Assertions) {
		msSql.DefaultVerify(assert)

		op := gcloud.Run(t, fmt.Sprintf("sql instances describe %s --project %s", msSql.GetStringOutput("name"), msSql.GetStringOutput("project_id")))

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
		assert.Equalf(op.Get("settings.tier").String(), tier, "Expected tier [%s] ", tier)

		// assert location database settings
		assert.Equalf(op.Get("settings.locationPreference.kind").String(), locationPreferenceKind, "Expected locationPreference.kind [%s]", locationPreferenceKind)
		assert.Equalf(op.Get("settings.locationPreference.zone").String(), locationPreferenceZone, "Expected locationPreference.zone [%s]", locationPreferenceZone)

		// assert maintenance windows
		assert.Equalf(op.Get("settings.maintenanceWindow.kind").String(), maintenanceWindowKind, "Expected maintenanceWindow.kind [%s]", maintenanceWindowKind)
		assert.Equalf(op.Get("settings.maintenanceWindow.day").Int(), maintenanceWindowDay, "Expected maintenanceWindow.day [%v]", maintenanceWindowDay)
		assert.Equalf(op.Get("settings.maintenanceWindow.hour").Int(), maintenanceWindowHour, "Expected maintenanceWindow.hour [%v]", maintenanceWindowHour)
		assert.Equalf(op.Get("settings.maintenanceWindow.updateTrack").String(), maintenanceWindowUpdateTrack, "Expected maintenanceWindow.updateTrack [%s]", maintenanceWindowUpdateTrack)

		// assert user labels
		assert.JSONEq(op.Get("settings.userLabels").Raw, `{"foo": "bar"}`, "Expected {\"foo\": \"bar\"}")

		// assert network settings
		authNetworks := op.Get("settings.ipConfiguration.authorizedNetworks").Array()
		assert.Equal(len(authNetworks), 1, "Expected one auth network")
		assert.True(op.Get("settings.ipConfiguration.requireSsl").Bool(), "SSL is required")
		authNetworkMap := authNetworks[0].Map()
		assert.Equal(authNetworkMap["name"].String(), fmt.Sprintf("%s-cidr", msSql.GetStringOutput("project_id")), "Expected auth network")
		assert.Equal(authNetworkMap["value"].String(), msSql.GetStringOutput("authorized_network"), "Expected auth network within cdir range")

		// assert standard database settings
		assert.Equalf(op.Get("databaseVersion").String(), databaseVersion, "Expected databaseVersion [%s]", databaseVersion)
		assert.Equalf(op.Get("backendType").String(), backendType, "Expected backendType [%s]", backendType)
		assert.Equalf(op.Get("state").String(), state, "Expected state [%s]", state)
		assert.Equalf(op.Get("region").String(), region, "Expected region [%s]", region)
		assert.Equalf(op.Get("gceZone").String(), gceZone, "Expected gceZone [%s]", gceZone)

		// assert users
		op = gcloud.Run(t, fmt.Sprintf("sql users list --instance %s --project %s", msSql.GetStringOutput("name"), msSql.GetStringOutput("project_id")))
		assert.GreaterOrEqual(len(op.Array()), 6, "Expected at least 6 users")

	})

	msSql.Test()
}
