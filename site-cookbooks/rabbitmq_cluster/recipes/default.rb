# Add all rabbitmq nodes to the hosts file with their short name.
instances = node[:opsworks][:layers][:rabbitmq][:instances]

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
  params ({"ha-mode"=>"all","ha-sync-mode"=>"automatic"})
  priority 1
  action :set
end

node['rabbitmq_cluster']['users'].each do |user|
  rabbitmq_user user['user'] do
    password user['password']
    action :add
  end

  rabbitmq_user user['user'] do
    vhost "/"
    permissions ".* .* .*"
    action :set_permissions
  end
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
include_recipe 'rabbitmq_cluster::monitor'

statsd_config = node["statsd"]["rabbitmq"]

rabbitmq_vhost statsd_config["vhost"] do
  action :add
end

rabbitmq_user statsd_config["user"] do
  password statsd_config["password"]
  action :add
end

rabbitmq_user statsd_config["user"] do
  vhost statsd_config["vhost"]
  permissions ".* .* .*"
  action :set_permissions
end
