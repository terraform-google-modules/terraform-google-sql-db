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

require 'json'

project_id = attribute('project_id')
basename   = attribute('name')
authorized_network = attribute('authorized_network')
replicas = attribute('replicas')
instances = attribute('instances')
mysql_version = "MYSQL_5_7"
region = "us-central1"

activation_policy = "ALWAYS"
availability_type = "REGIONAL"
availability_type_replica = "ZONAL"
data_disk_size_gb = 10
data_disk_type = "PD_SSD"
data_disk_type_replica = "PD_HDD"
kind = "sql#settings"
pricing_plan = "PER_USE"
replication_type = "SYNCHRONOUS"
storage_auto_resize = true
storage_auto_resize_limit = 0
tier = "db-n1-standard-1"

describe command("gcloud --project='#{project_id}' sql instances list --filter='name ~ ^#{basename}' --format=json") do
  let!(:data) do
    if subject.exit_status == 0
      JSON.parse(subject.stdout)
    else
      {}
    end
  end

  describe "mysql_ha_database" do
    it "has 1 primary instance and 3 replicas" do
      expect(data.size).to eq 4
    end
  end
end

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

  describe "mysql_ha_database" do
    it "global settings are valid" do
      expect(data['settings']['activationPolicy']).to eq "#{activation_policy}"
      expect(data['settings']['availabilityType']).to eq "#{availability_type}"
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
      expect(data['databaseVersion']).to eq mysql_version
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
      "day" => 7,
      "hour" => 12,
      "updateTrack" => "stable")
    end

    it "ip configuration and authorized networks are valid" do
      expect(data['settings']['ipConfiguration']).to include(
        ["authorizedNetworks"][0] => [{
          "kind" => "sql#aclEntry",
          "name" => "#{project_id}-cidr",
          "value" => authorized_network
        }],
        "ipv4Enabled" => true,
        "requireSsl" => true,
      )
    end

    it "user labels are set" do
      expect(data['settings']['userLabels']).to include(
        "foo" => "bar")
    end

    it "database flags are set" do
      expect(data['settings']['databaseFlags']).to include({
        "name" => "long_query_time",
        "value" => "1"})
    end

    it "backup configuration is enabled" do
      expect(data['settings']['backupConfiguration']).to include(
        "backupRetentionSettings" => {
          "retainedBackups" => 365,
          "retentionUnit" => "COUNT"
        },
        "binaryLogEnabled" => true,
        "enabled" => true,
        "kind" => "sql#backupConfiguration",
        "startTime" => "20:55")
    end

  end
end

%i[a b c].each_with_index do |zone, index|
  replica_name = "#{basename}-replica-test#{index}"

  describe command("gcloud --project='#{project_id}' sql instances describe #{replica_name} --format=json") do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq '' }

    let!(:data) do
      if subject.exit_status == 0
        JSON.parse(subject.stdout)
      else
        {}
      end
    end

    describe "mysql_ha_database" do
      it "global settings are valid" do
        expect(data['settings']['activationPolicy']).to eq "#{activation_policy}"
        expect(data['settings']['availabilityType']).to eq "#{availability_type_replica}"
        expect(data['settings']['dataDiskSizeGb']).to eq "#{data_disk_size_gb}"
        expect(data['settings']['dataDiskType']).to eq "#{data_disk_type_replica}"
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
        expect(data['databaseVersion']).to eq mysql_version
      end

      it "state is valid" do
        expect(data['state']).to eq 'RUNNABLE'
      end

      it "region is valid" do
        expect(data['region']).to eq region
      end

      it "gce zone is valid" do
        expect(data['gceZone']).to eq "#{region}-#{zone}"
      end

      it "location preference is valid" do
        expect(data['settings']['locationPreference']).to include(
        "kind" => "sql#locationPreference",
        "zone" => "#{region}-#{zone}")
      end

      it "ip configuration and authorized networks are valid" do
        expect(data['settings']['ipConfiguration']).to include(
          ["authorizedNetworks"][0] => [{
            "kind" => "sql#aclEntry",
            "name" => "#{project_id}-cidr",
            "value" => authorized_network
          }],
          "ipv4Enabled" => true,
          "requireSsl" => false,
        )
      end

      it "user labels are set" do
        expect(data['settings']['userLabels']).to include(
          "bar" => "baz")
      end

      it "database flags are set" do
        expect(data['settings']['databaseFlags']).to include({
          "name" => "long_query_time",
          "value" => "1"})
      end
    end
  end
end

describe command("gcloud --project='#{project_id}' sql users list --instance #{basename} --format=json") do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should eq '' }

  let!(:data) do
    if subject.exit_status == 0
      JSON.parse(subject.stdout)
    else
      {}
    end
  end

  describe "mysql_ha_database" do
    it "has 3 users" do
      expect(data.select {|k,v| k['name'].start_with?("tftest")}.size).to eq 3
    end

    it "is setup for localhost" do
      expect(data.select {|k,v| k['host'] == "localhost"}.size).to be >= 1
    end
  end
end
