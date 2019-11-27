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
mysql_version = attribute('mysql_version')
region = attribute('region')
tier = attribute('tier')
public_ip_address = attribute('public_ip_address')
private_ip_address = attribute('private_ip_address')

describe google_sql_database_instance(project: project_id, database: basename) do
  let(:expected_settings) {
    {
      activation_policy: "ALWAYS",
      data_disk_size_gb: 10,
      data_disk_type: "PD_SSD",
      kind: "sql#settings",
      pricing_plan: "PER_USE",
      replication_type: "SYNCHRONOUS",
      storage_auto_resize: true,
      storage_auto_resize_limit: 0,
      tier: tier,
    }
  }
  let(:settings)                { subject.settings.item }
  let(:location_preference)     { settings[:location_preference] }
  let(:maintenance_window)      { settings[:maintenance_window] }
  let(:instance_ip_addresses)   { subject.ip_addresses }

  its(:backend_type)     { should eq 'SECOND_GEN' }
  its(:database_version) { should eq mysql_version }
  its(:state)            { should eq 'RUNNABLE' }
  its(:region)           { should eq region }
  its(:gce_zone)         { should eq "#{region}-c" }

  it { expect(settings).to include(expected_settings) }
  it { expect(location_preference).to include(kind: "sql#locationPreference", zone: "#{region}-c") }
  it { expect(maintenance_window).to include(kind: "sql#maintenanceWindow", day: 1, hour: 23, update_track: "canary") }

describe "MySQL pubic instance" do
    it "has just one assigned IP address" do
      expect(instance_ip_addresses.count).to eq(1)
    end

    it "has expected external IP address" do
      expect(instance_ip_addresses[0].item).to eq(
        {
          type: "PRIMARY",
          ip_address: "#{public_ip_address}"
        }
      )
    end
  end
end
