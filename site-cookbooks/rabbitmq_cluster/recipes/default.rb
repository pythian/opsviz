=begin
#<
Recipe to to cluster RabbitMQ servers from within an opsworks layer
#>
=end

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

