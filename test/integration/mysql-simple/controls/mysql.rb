# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

project_id = attribute('project_id')
basename   = attribute('name')

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
      tier: "db-n1-standard-1",
    }
  }
  let(:settings)                { subject.settings.item }
  let(:location_preference)     { settings[:location_preference] }
  let(:maintenance_window)      { settings[:maintenance_window] }

  its(:backend_type)     { should eq 'SECOND_GEN' }
  its(:database_version) { should eq 'MYSQL_5_7' }
  its(:state)            { should eq 'RUNNABLE' }
  its(:region)           { should eq 'us-central1' }
  its(:gce_zone)         { should eq 'us-central1-c' }

  it { expect(settings).to include(expected_settings) }
  it { expect(location_preference).to include(kind: "sql#locationPreference", zone: "us-central1-c") }
  it { expect(maintenance_window).to include(kind: "sql#maintenanceWindow", day: 1, hour: 23, update_track: "canary") }
end
