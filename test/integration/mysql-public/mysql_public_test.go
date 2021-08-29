// Copyright 2021 Google LLC
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

// define test package name
package mysql_public

import (
	"fmt"
	"testing"

	// import the new Blueprints test framework modules for testing and assertions
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/stretchr/testify/assert"
)

func TestMySqlPublicModule(t *testing.T) { // name the function as Test*

	// define constants for all required assertions in the test case
	const databaseVersion = `MYSQL_5_6`
	const gceZone = `us-central1-c`
	const region = `us-central1`
	const tier = `db-n1-standard-1`
	const authNetName = `sample-gcp-health-checkers-range`
	const authNetCidr = `130.211.0.0/28`
	const dbFlagName = `log_bin_trust_function_creators`
	const dbFlagValue = `on`

	mySqlT := tft.NewTFBlueprintTest(t)                   // initialize Terraform test from the Blueprints test framework
	mySqlT.DefineVerify(func(assert *assert.Assertions) { // define and write a custom verifier for this test case
		// call the default verify for confirming no additional changes
		mySqlT.DefaultVerify(assert)
		// invoke the gcloud module in the Blueprints test framework to run a gcloud command that will output resource properties in a JSON format
		// the tft struct can be used to pull output variables of the TF module being invoked by this test and use the op object (a gjson struct)
		// to parse through the JSON results and assert the values of the resource against the constants defined above
		op := gcloud.Run(t, fmt.Sprintf("sql instances describe %s --project %s", mySqlT.GetStringOutput("name"), mySqlT.GetStringOutput("project_id")))

		// assert values that are contained in the expected output
		assert.Contains(op.Get("gceZone").String(), region, "GCE region is valid")

		// assert boolean values
		assert.True(op.Get("settings.ipConfiguration.ipv4Enabled").Bool(), "ipv4 is enabled")

		// assert values that are greater than or equal to the expected value
		assert.GreaterOrEqual(op.Get("settings.dataDiskSizeGb").Float(), 10.0, "at least 5 backups are retained")

		// assert values that are supposed to be empty or nil
		assert.Empty(op.Get("settings.userLabels"), "no labels are set")

		// assert values that are supposed to be equal to the expected values
		assert.Equal(databaseVersion, op.Get("databaseVersion").String(), "database versions is valid is set to "+databaseVersion)
		assert.Equal(region, op.Get("region").String(), "Equals ===> GCE region is valid")
		assert.Equal(tier, op.Get("settings.tier").String(), "database tier is valid")
		assert.Equal(true, op.Get("settings.ipConfiguration.requireSsl").Bool(), "SSL is required")

		// the gjson struct (op) also allow for easy parsing through arrays and maps
		authNetworks := op.Get("settings.ipConfiguration.authorizedNetworks").Array()
		authNetworkMap := authNetworks[0].Map()
		assert.Equal(authNetName, authNetworkMap["name"].String(), "found one valid authorized network")
		assert.Equal(authNetCidr, authNetworkMap["value"].String(), "found one valid authorized network with the right CIDR range")

		dbFlags := op.Get("settings.databaseFlags").Array()
		dbFlagMap := dbFlags[0].Map()
		assert.Equal(dbFlagName, dbFlagMap["name"].String(), "found one valid DB Flag")
		assert.Equal(dbFlagValue, dbFlagMap["value"].String(), "found one valid DB Flag value")
	})
	mySqlT.Test() // call the test function to execute the integration test
}
