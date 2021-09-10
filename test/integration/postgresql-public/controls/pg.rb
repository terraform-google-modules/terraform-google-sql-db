# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

project_id = attribute('project_id')
basename   = attribute('name')
db_version = "POSTGRES_9_6"
region = "us-central1"
tier = "db-f1-micro"
public_ip_address = attribute('public_ip_address')

activation_policy = "ALWAYS"
data_disk_size_gb = 10
data_disk_type = "PD_SSD"
kind = "sql#settings"
pricing_plan = "PER_USE"
replication_type = "SYNCHRONOUS"
storage_auto_resize = true
storage_auto_resize_limit = 0

describe command("gcloud --project='#{project_id}' sql instances describe #{basename} --format=json") do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should eq '' }

  let!(:data) do
    if subject.exit_status == 0
      JSON.parse(subject.stdout)
    else
      {}
    end
  end

  describe "postgresql_public_database" do
    it "global settings are valid" do
      expect(data['settings']['activationPolicy']).to eq "#{activation_policy}"
      expect(data['settings']['dataDiskSizeGb']).to eq "#{data_disk_size_gb}"
      expect(data['settings']['dataDiskType']).to eq "#{data_disk_type}"
      expect(data['settings']['kind']).to eq "#{kind}"
      expect(data['settings']['pricingPlan']).to eq "#{pricing_plan}"
      expect(data['settings']['replicationType']).to eq "#{replication_type}"
      expect(data['settings']['storageAutoResize']).to eq storage_auto_resize
      expect(data['settings']['storageAutoResizeLimit']).to eq "#{storage_auto_resize_limit}"
      expect(data['settings']['tier']).to eq "#{tier}"
    end

    it "backend type is valid" do
      expect(data['backendType']).to eq 'SECOND_GEN'
    end

    it "database versions is valid" do
      expect(data['databaseVersion']).to eq db_version
    end

    it "state is valid" do
      expect(data['state']).to eq 'RUNNABLE'
    end

    it "region is valid" do
      expect(data['region']).to eq region
    end

    it "gce zone is valid" do
      expect(data['gceZone']).to eq "#{region}-c"
    end

    it "location preference is valid" do
      expect(data['settings']['locationPreference']).to include(
      "kind" => "sql#locationPreference",
      "zone" => "#{region}-c")
    end

    it "maintenance window is valid" do
      expect(data['settings']['maintenanceWindow']).to include(
      "kind" => "sql#maintenanceWindow",
      "day" => 1,
      "hour" => 23,
      "updateTrack" => "canary")
    end
  end

  describe "Postgres SQL pubic instance" do
    it "has both a public and an outgoing IP address assigned" do
      expect(data["ipAddresses"].count).to eq(2)
    end

    it "has expected external IP address" do
      expect(data["ipAddresses"][0]).to eq(
        {
          "type" => "PRIMARY",
          "ipAddress" => "#{public_ip_address}"
        }
      )
    end
  end
end
