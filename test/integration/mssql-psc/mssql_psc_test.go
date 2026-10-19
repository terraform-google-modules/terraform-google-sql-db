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

package mssql_psc

import (
	"testing"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/utils"
	"github.com/stretchr/testify/assert"
)

func TestMsSqlPscModule(t *testing.T) {
	msSql := tft.NewTFBlueprintTest(t)

	msSql.DefineVerify(func(assert *assert.Assertions) {
		msSql.DefaultVerify(assert)

		projectId := msSql.GetStringOutput("project_id")
		op := gcloud.Runf(t, "sql instances describe %s --project %s", msSql.GetStringOutput("instance_name"), projectId)

		assert.Equal("RUNNABLE", op.Get("state").String(), "Expected RUNNABLE state")
		assert.False(op.Get("settings.ipConfiguration.ipv4Enabled").Bool(), "Expected FALSE ipv4Enabled")
		assert.True(op.Get("settings.ipConfiguration.pscConfig.pscEnabled").Bool(), "Expected TRUE pscEnabled")
		assert.Equal([]string{projectId}, utils.GetResultStrSlice(op.Get("settings.ipConfiguration.pscConfig.allowedConsumerProjects").Array()), "Expected the test project as the only allowed consumer project")
		assert.Equal(op.Get("pscServiceAttachmentLink").String(), msSql.GetStringOutput("instance_psc_attachment"), "Expected the instance_psc_attachment output to match the instance")
		assert.NotEmpty(msSql.GetStringOutput("instance_psc_attachment"), "Expected a PSC service attachment")
	})

	msSql.Test()
}
