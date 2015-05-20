=begin
#<
Installs sensu, uchiwa and it's dependencies
#>
=end

[Chef::Recipe, Chef::Resource].each { |l| l.send :include, ::OpsVizExtensions }

if node[:bb_monitor][:sensu][:redis_cluster_id]

  include_recipe "xml::ruby"

  chef_gem "fog" do
    action :install
  end

  chef_gem "fog-aws" do
    action :install
  end

  node[:sensu][:redis][:host] = get_elasticache_redis_endpoint(node[:bb_monitor][:sensu][:redis_cluster_id])
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
