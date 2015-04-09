include_recipe 'gentoo'

gentoo_package_mask 'dev-db/mysql'


packages = %w( dev-db/mariadb virtual/mysql )

packages.each do |package|
  gentoo_package_keywords package do
    keywords '~amd64'
  end
end

if node.run_list?('recipe[mysql::server]')
  gentoo_package_manage 'dev-db/mariadb' do
    data 'minimal'
    action :delete
    type 'use'
    notifies :remove, 'package[dev-db/mariadb]', :immediately
  end
else
  gentoo_package_use 'dev-db/mariadb' do
    use 'minimal'
  end
end

package 'dev-db/mariadb' do
  version '5.5.42'
end

template '/root/.my.cnf' do
  source 'root/dotmy.cnf.erb'
  owner 'root'
  group 'root'
  mode '0600'
  variables(
      :password => node['mysql']['password']['root'],
      :host => node['mysql']['host'],
      :encoding => 'utf8'
  )
end

chef_gem 'mysql' do
  action :install
  compile_time false
end

