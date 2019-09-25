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
authorized_network = attribute('authorized_network')

describe google_sql_database_instances(project: project_id).where(instance_name: /#{basename}/) do
  its(:count) { should eq 4 }
end

describe google_sql_database_instance(project: project_id, database: basename) do
  let(:expected_settings) {
    {
      activation_policy: "ALWAYS",
      availability_type: "REGIONAL",
      data_disk_size_gb: 10,
      data_disk_type: "PD_SSD",
      kind: "sql#settings",
      pricing_plan: "PER_USE",
      replication_type: "SYNCHRONOUS",
      storage_auto_resize: true,
      storage_auto_resize_limit: 0,
      tier: "db-custom-2-13312",
    }
  }
  let(:settings)                { subject.settings.item }
  let(:backup_configuration)    { settings[:backup_configuration] }
  let(:ip_configuration)        { settings[:ip_configuration] }
  let(:database_flags)          { settings[:database_flags] }
  let(:location_preference)     { settings[:location_preference] }
  let(:maintenance_window)      { settings[:maintenance_window] }
  let(:user_labels)             { settings[:user_labels] }

  its(:backend_type)     { should eq 'SECOND_GEN' }
  its(:database_version) { should eq 'POSTGRES_9_6' }
  its(:state)            { should eq 'RUNNABLE' }
  its(:region)           { should eq 'us-central1' }
  its(:gce_zone)         { should eq 'us-central1-c' }

  it { expect(settings).to include(expected_settings) }
  it { expect(backup_configuration).to include(enabled: true, kind: "sql#backupConfiguration", start_time: "20:55") }
  it { expect(ip_configuration).to include(authorized_networks: [{kind: 'sql#aclEntry', name: "#{project_id}-cidr", value: authorized_network}], ipv4_enabled: true, require_ssl: true) }
  it { expect(database_flags).to include(name: "autovacuum", value: "off") }
  it { expect(location_preference).to include(kind: "sql#locationPreference", zone: "us-central1-c") }
  it { expect(maintenance_window).to include(kind: "sql#maintenanceWindow", day: 7, hour: 12, update_track: "stable") }
  it { expect(user_labels).to include(foo: "bar") }
end

%i[a b c].each_with_index do |zone, index|
  name = "#{basename}-replica-test#{index}"
  describe google_sql_database_instance(project: project_id, database: name) do
    let(:expected_settings) {
      {
        activation_policy: "ALWAYS",
        data_disk_size_gb: 10,
        data_disk_type: "PD_HDD",
        kind: "sql#settings",
        pricing_plan: "PER_USE",
        replication_type: "SYNCHRONOUS",
        storage_auto_resize: true,
        storage_auto_resize_limit: 0,
        tier: "db-custom-2-13312",
      }
    }
    let(:settings)                { subject.settings.item }
    let(:ip_configuration)        { settings[:ip_configuration] }
    let(:database_flags)          { settings[:database_flags] }
    let(:location_preference)     { settings[:location_preference] }
    let(:maintenance_window)      { settings[:maintenance_window] }
    let(:user_labels)             { settings[:user_labels] }

    its(:backend_type)     { should eq 'SECOND_GEN' }
    its(:database_version) { should eq 'POSTGRES_9_6' }
    its(:state)            { should eq 'RUNNABLE' }
    its(:region)           { should eq 'us-central1' }
    its(:gce_zone)         { should eq "us-central1-#{zone}" }

    it { expect(settings).to include(expected_settings) }
    it { expect(ip_configuration).to include(authorized_networks: [{kind: 'sql#aclEntry', name: "#{project_id}-cidr", value: authorized_network}], ipv4_enabled: true, require_ssl: false) }
    it { expect(database_flags).to include(name: "autovacuum", value: "off") }
    it { expect(location_preference).to include(kind: "sql#locationPreference", zone: "us-central1-#{zone}") }
    it { expect(maintenance_window).to include(kind: "sql#maintenanceWindow", day: 1, hour: 22, update_track: "stable") }
    it { expect(user_labels).to include(bar: "baz") }
  end
end

describe google_sql_users(project: project_id, database: basename).where(user_name: /\Atftest/) do
  its(:count) { should be 3 }
  it { should exist }
end
