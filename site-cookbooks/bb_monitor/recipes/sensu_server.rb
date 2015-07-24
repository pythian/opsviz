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

  node.override[:sensu][:redis][:host] = get_elasticache_redis_endpoint(node[:bb_monitor][:sensu][:redis_cluster_id])
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

cookbook_file "/tmp/download_from_s3.rb" do
    source "download_from_s3.rb"
    mode 0755
end

if node.normal[:remote_config_files][:sensu]
  node.normal[:remote_config_files][:sensu].each do |region, bucket, dest, source|
    bash "download config from s3" do
      code <<-EOF
        env -i /usr/local/bin/ruby /tmp/download_from_s3.rb -b #{bucket} -r #{region} -s #{source} -d #{dest}
      EOF
      notifies :restart, "service[sensu-server]"
      notifies :restart, "service[sensu-api]"
      notifies :restart, "service[sensu-client]"
    end
  end
end
