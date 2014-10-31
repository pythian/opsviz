# Add all rabbitmq nodes to the hosts file with their short name.
instances = node[:opsworks][:layers][:rabbitmq][:instances]

instances.each do |name, attrs|
  hostsfile_entry attrs['private_ip'] do
    hostname  name
    unique    true
  end
end

rabbit_nodes = instances.map{ |name, attrs| "rabbit@#{name}" }
node.set['rabbitmq']['cluster_disk_nodes'] = rabbit_nodes

#include_recipe 'rabbitmq'
include_recipe 'rabbitmq::mgmt_console'

execute "chown -R rabbitmq:rabbitmq /var/lib/rabbitmq"

rabbitmq_user "guest" do
  action :delete
end

rabbitmq_policy "ha-all" do
  pattern "^(?!amq\\.).*"
  params ({"ha-mode"=>"all"})
  priority 1
  action :set
end

rabbitmq_user node['rabbitmq_cluster']['user'] do
  password node['rabbitmq_cluster']['password']
  action :add
end

rabbitmq_user node['rabbitmq_cluster']['user'] do
  vhost "/"
  permissions ".* .* .*"
  action :set_permissions
end

include_recipe 'sensu'
sensu_config = node["sensu"]["rabbitmq"].to_hash

rabbitmq_vhost sensu_config["vhost"] do
  action :add
end

rabbitmq_user sensu_config["user"] do
  password sensu_config["password"]
  action :add
end

rabbitmq_user sensu_config["user"] do
  vhost sensu_config["vhost"]
  permissions ".* .* .*"
  action :set_permissions
end
