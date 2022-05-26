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

package postgresql_public

import (
	"fmt"
	"testing"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/stretchr/testify/assert"
)

func TestPostgreSqlPublicModule(t *testing.T) {
	pSql := tft.NewTFBlueprintTest(t)

	pSql.DefineVerify(func(assert *assert.Assertions) {
		pSql.DefaultVerify(assert)

		op := gcloud.Run(t, fmt.Sprintf("sql instances describe %s --project %s", pSql.GetStringOutput("name"), pSql.GetStringOutput("project_id")))

		// assert general database settings
		assert.Equal("ALWAYS", op.Get("settings.activationPolicy").String(), "Expected ALWAYS activationPolicy")
		assert.Equal(int64(10), op.Get("settings.dataDiskSizeGb").Int(), "Expected 10 dataDiskSizeGb")
		assert.Equal("PD_SSD", op.Get("settings.dataDiskType").String(), "Expected PD_SSD dataDiskType")
		assert.Equal("sql#settings", op.Get("settings.kind").String(), "Expected sql#settings kind")
		assert.Equal("PER_USE", op.Get("settings.pricingPlan").String(), "Expected PER_USE pricingPlan")
		assert.Equal("SYNCHRONOUS", op.Get("settings.replicationType").String(), "Expected SYNCHRONOUS replicationType")
		assert.True(op.Get("settings.storageAutoResize").Bool(), "Expected TRUE storageAutoResize")
		assert.Equal(int64(0), op.Get("settings.storageAutoResizeLimit").Int(), "Expected 0 storageAutoResizeLimit")
		assert.Equal("db-custom-1-3840", op.Get("settings.tier").String(), "Expected db-custom-1-3840 tier")

		// assert location database settings
		assert.Equal("sql#locationPreference", op.Get("settings.locationPreference.kind").String(), "Expected sql#locationPreference locationPreference.kind")
		assert.Equal("us-central1-c", op.Get("settings.locationPreference.zone").String(), "Expected us-central1-c locationPreference.zone")

		// assert maintenance windows
		assert.Equal("sql#maintenanceWindow", op.Get("settings.maintenanceWindow.kind").String(), "Expected sql#maintenanceWindow maintenanceWindow.kind")
		assert.Equal(int64(1), op.Get("settings.maintenanceWindow.day").Int(), "Expected 1 maintenanceWindow.day")
		assert.Equal(int64(23), op.Get("settings.maintenanceWindow.hour").Int(), "Expected 23 maintenanceWindow.hour")
		assert.Equal("canary", op.Get("settings.maintenanceWindow.updateTrack").String(), "Expected canary maintenanceWindow.updateTrack")

		// assert standard database settings
		assert.Equal("POSTGRES_9_6", op.Get("databaseVersion").String(), "Expected POSTGRES_9_6 databaseVersion")
		assert.Equal("SECOND_GEN", op.Get("backendType").String(), "Expected SECOND_GEN backendType")
		assert.Equal("RUNNABLE", op.Get("state").String(), "Expected RUNNABLE state")
		assert.Equal("us-central1", op.Get("region").String(), "Expected us-central1 region")
		assert.Equal("us-central1-c", op.Get("gceZone").String(), "Expected us-central1-c gceZone")

		// assert ip database settings
		ipAddresses := op.Get("ipAddresses").Array()
		assert.Equal(2, len(ipAddresses), "Expected 2 addresses")
		assert.Equalf(pSql.GetStringOutput("public_ip_address"), ipAddresses[0].Get("ipAddress").String(), "Expected %s PublicIp", pSql.GetStringOutput("public_ip_address"))
		assert.Equal("PRIMARY", ipAddresses[0].Get("type").String())
	})

	pSql.Test()
}
