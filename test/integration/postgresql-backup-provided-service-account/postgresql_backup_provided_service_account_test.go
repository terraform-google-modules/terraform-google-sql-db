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

package postgresql_backup

import (
	"fmt"
	"testing"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/stretchr/testify/assert"
)

func TestPostgresqlBackupModuleProvidedServiceAccount(t *testing.T) {

	mySql := tft.NewTFBlueprintTest(t)

	mySql.DefineVerify(func(assert *assert.Assertions) {
		mySql.DefaultVerify(assert)

		projectID := mySql.GetStringOutput("project_id")
		workflowLocation := mySql.GetStringOutput("workflow_location")
		instanceName := mySql.GetStringOutput("instance_name")

		backupWorkflow := gcloud.Runf(t, "workflows describe %s --project=%s --location=%s", mySql.GetStringOutput("backup_workflow_name"), projectID, workflowLocation)
		exportWorkflow := gcloud.Runf(t, "workflows describe %s --project=%s --location=%s", mySql.GetStringOutput("export_workflow_name"), projectID, workflowLocation)

		serviceAccountSelfLink := fmt.Sprintf("projects/%s/serviceAccounts/%s", projectID, mySql.GetStringOutput("service_account"))

		assert.Equal(serviceAccountSelfLink, backupWorkflow.Get("serviceAccount").String())
		assert.Equal(serviceAccountSelfLink, exportWorkflow.Get("serviceAccount").String())

		backupContainsExpecations := []string{
			fmt.Sprintf("instance: %s", instanceName),
			fmt.Sprintf("project: %s", projectID),
			"- create new backup:",
			"- delete old backups:",
		}

		exportContainsExpecations := []string{
			fmt.Sprintf("instance: %s", instanceName),
			fmt.Sprintf("project: %s", projectID),
			"- backupTime: ${string(int(sys.now()))}",
			fmt.Sprintf("uri: ${\"gs://%s-backup/%[1]s-\" + database + \"-\" + backupTime + \".sql.gz\"}", instanceName),
		}

		for _, expected := range backupContainsExpecations {
			assert.Contains(backupWorkflow.Get("sourceContents").String(), expected)
		}

		for _, expected := range exportContainsExpecations {
			assert.Contains(exportWorkflow.Get("sourceContents").String(), expected)
		}

	})

	mySql.Test()
}
