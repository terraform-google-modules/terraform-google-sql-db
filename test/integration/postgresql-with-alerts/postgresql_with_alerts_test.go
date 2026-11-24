// Copyright 2026 Google LLC
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

package postgresql_with_alerts

import (
	"fmt"
	"testing"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/stretchr/testify/assert"
)

func TestPostgreSqlWithAlertsModule(t *testing.T) {
	pSql := tft.NewTFBlueprintTest(t)

	pSql.DefineVerify(func(assert *assert.Assertions) {
		pSql.DefaultVerify(assert)

		projectID := pSql.GetStringOutput("project_id")
		databaseID := fmt.Sprintf("%s:%s", projectID, pSql.GetStringOutput("name"))
		policies := pSql.GetJsonOutput("alert_policies").Map()

		// disk_utilization is enabled because the example sets disk_autoresize_limit
		expected := []string{"cpu_utilization", "memory_utilization", "disk_utilization", "instance_down", "transaction_id_utilization"}
		assert.Len(policies, len(expected), "Expected one alert policy per default alert")
		for _, name := range expected {
			assert.Contains(policies, name, "Expected alert policy %s", name)
		}

		// With an autoresize limit, the disk alert compares bytes used against 80% of the limit (GB = 1024^3 bytes)
		disk := gcloud.Runf(t, "alpha monitoring policies describe %s --project %s", policies["disk_utilization"].String(), projectID)
		assert.Contains(disk.Get("conditions.0.conditionThreshold.filter").String(), "cloudsql.googleapis.com/database/disk/bytes_used", "Expected disk alert on bytes used")
		assert.InDelta(0.8*20*1024*1024*1024, disk.Get("conditions.0.conditionThreshold.thresholdValue").Float(), 1, "Expected disk threshold at 80% of the 20 GB autoresize limit")

		for name, policyName := range policies {
			op := gcloud.Runf(t, "alpha monitoring policies describe %s --project %s", policyName.String(), projectID)

			assert.True(op.Get("enabled").Bool(), "Expected %s to be enabled", name)

			channels := op.Get("notificationChannels").Array()
			assert.Len(channels, 1, "Expected %s to notify one channel", name)
			assert.Contains(channels[0].String(), fmt.Sprintf("projects/%s/notificationChannels/", projectID), "Expected %s to notify the example channel", name)

			filter := op.Get("conditions.0.conditionThreshold.filter").String()
			assert.Contains(filter, fmt.Sprintf("one_of(\"%s\")", databaseID), "Expected %s to be scoped to the instance", name)

			assert.Contains(op.Get("documentation.subject").String(), "${resource.label.database_id}", "Expected %s subject to name the affected instance", name)
		}
	})

	pSql.Test()
}
