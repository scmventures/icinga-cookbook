#
# Author:: Marius Ducea (marius@promethost.com)
# Cookbook Name:: icinga
# Recipe:: plugins_package
#
# Copyright 2010-2011, Promet Solutions
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

case node['platform'] 
when "debian", "ubuntu"
  %w{ nagios-plugins nagios-plugins-basic nagios-plugins-standard }.each do |pkg|
    package pkg
  end

  package "nagios-nrpe-plugin"
  
#might want to rethink this list since we need to look up and run yum install on every single one.

when "centos", "redhat", "fedora"
  %w{disk dummy file_age http nrpe load ping users procs swap ssh tcp}.each do |pkg|
    package "nagios-plugins-#{pkg}"
  end
end


