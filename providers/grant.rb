include Opscode::MySQL

action :create do
  mysql_manage_grants(:create, new_resource)
  new_resource.updated_by_last_action(true)
end

action :delete do
  mysql_manage_grants(:delete, new_resource)
  new_resource.updated_by_last_action(true)
end
