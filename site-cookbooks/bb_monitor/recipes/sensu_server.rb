=begin
#<
Installs sensu, uchiwa and it's dependencies
#>
=end

[Chef::Recipe, Chef::Resource].each { |l| l.send :include, ::OpsVizExtensions }

if node[:sensu][:redis_cluster_id]
  chef_gem "fog-aws"
  node[:sensu][:redis][:host] = get_elasticache_redis_endpoint(node[:sensu][:redis_cluster_id])
else
  include_recipe "sensu::redis"
end

include_recipe "sensu::default"

include_recipe "bb_monitor::sensu_mutators"
include_recipe "bb_monitor::sensu_handlers"
include_recipe "bb_monitor::sensu_checks"
include_recipe "bb_monitor::sensu_extensions"


include_recipe "sensu::server_service"
include_recipe "sensu::api_service"

include_recipe "bb_monitor::sensu_client"
include_recipe "uchiwa"
