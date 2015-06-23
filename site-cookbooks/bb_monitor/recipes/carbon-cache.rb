=begin
#>
Installs and configures graphite, carbon, and graphite-web. Carbon is configured to use AMQP
#<
=end

include_recipe 'python'

include_recipe "runit"

include_recipe "graphite::carbon"

graphite_carbon_cache "default" do
  config ({
            enable_logrotation: true,
            user: "graphite",
            max_cache_size: "inf",
            max_updates_per_second: 500,
            max_creates_per_minute: 50,
            line_receiver_interface: "0.0.0.0",
            line_receiver_port: 2003,
            udp_receiver_port: 2003,
            pickle_receiver_port: 2004,
            enable_udp_listener: true,
            cache_query_port: "7002",
            cache_write_strategy: "sorted",
            use_flow_control: true,
            log_updates: false,
            log_cache_hits: false,
            whisper_autoflush: false,
            enable_amqp: true,
            amqp_host: node[:bb_monitor][:sensu][:rabbitmq][:server],
            amqp_port: 5672,
            amqp_vhost: node["statsd"]["rabbitmq"]["vhost"],
            amqp_user: node["statsd"]["rabbitmq"]["user"],
            amqp_password: node["statsd"]["rabbitmq"]["password"],
            amqp_exchange: "statsd",
            amqp_metric_name_in_body: true
          })
end

graphite_storage_schema "default" do
  config ({
            pattern: ".*",
            retentions: "1m:30d,5m:1y,1h:5y"
          })
end

graphite_service "cache"

base_dir = "#{node['graphite']['base_dir']}"

execute "python manage.py syncdb --noinput" do
  user node['graphite']['user']
  group node['graphite']['group']
  cwd "#{base_dir}/webapp/graphite"
  creates "#{base_dir}/storage/graphite.db"
end

