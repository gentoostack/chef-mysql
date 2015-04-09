#
# Cookbook Name:: mariadb
# Recipe:: default
#
# Copyright 2015, Leonid Laboshin
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

include_recipe 'mysql::client'

unless node['gentoo']['use_flags'].include?('mysql')
  node.default['gentoo']['use_flags'].push 'mysql'
  generate_make_conf 'added mysql USE flag'
end

template '/etc/mysql/my.cnf' do
  source 'etc/mysql/my.cnf.erb'
  action :create
end

execute 'emerge --config dev-db/mariadb' do
  creates '/var/lib/mysql/mysql'
end

service 'mysql' do
  supports :status => true, :restart => true
  action [ :enable, :start ]
  subscribes :restart, 'package[dev-db/mariadb]'
  subscribes :restart, 'template[/etc/mysql/my.cnf]'
end

mysql_database 'test' do
  action :delete
end

