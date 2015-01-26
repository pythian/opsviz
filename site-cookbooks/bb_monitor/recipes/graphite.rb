include_recipe 'python'

include_recipe "runit"

include_recipe "graphite::carbon"
include_recipe "graphite::web"

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

graphite_web_config "#{base_dir}/webapp/graphite/local_settings.py" do
  config({
           secret_key: node['graphite']['password'],
           time_zone: "America/Chicago",
           conf_dir: "#{base_dir}/conf",
           storage_dir: "#{base_dir}/storage",
           databases: {
             default: {
               # keys need to be upcase here
               NAME: "#{base_dir}/storage/graphite.db",
               ENGINE: "django.db.backends.sqlite3",
               USER: node['graphite']['user'],
               PASSWORD: node['graphite']['password'],
               HOST: nil,
               PORT: nil
             }
           }
         })
  notifies :restart, 'service[graphite-web]', :delayed
end

directory "#{base_dir}/storage/log/webapp" do
  owner node['graphite']['user']
  group node['graphite']['group']
  recursive true
end

execute "python manage.py syncdb --noinput" do
  user node['graphite']['user']
  group node['graphite']['group']
  cwd "#{base_dir}/webapp/graphite"
  creates "#{base_dir}/storage/graphite.db"
end

runit_service 'graphite-web' do
  cookbook 'graphite'
  sv_timeout 60
  default_logger true
  retries 2
  retry_delay 10
end
