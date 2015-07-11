=begin
#>
Installs and configures graphite, carbon, and graphite-web. Carbon is configured to use AMQP
#<
=end

include_recipe 'python'

include_recipe "runit"

include_recipe "graphite::carbon"

graphite_storage 'default'

instances = node[:opsworks][:layers][:carbonrelay][:instances]
carbonrelay_nodes = instances.map{ |name, attrs| "#{name}:2414:fan" }

node.default['graphite']['relay_rules'] = [
  {
    'name' => 'default',
    'default' => true,
    'destinations' => [ carbonrelay_nodes ]
  }
]

template "#{node['graphite']['base_dir']}/conf/relay-rules.conf" do
  source 'relay-rules.conf.erb'
  owner node['graphite']['user_account']
  group node['graphite']['group_account']
  variables(:relay_rules => node['graphite']['relay_rules'])
  notifies :restart, 'graphite_service[relay:rep]', :delayed
end

graphite_carbon_relay "rep" do
  config ({
            max_cache_size: "inf",
            max_updates_per_second: 500,
            max_creates_per_minute: 50,
            line_receiver_interface: "0.0.0.0",
            line_receiver_port: 2003,
            udp_receiver_port: 2003,
            pickle_receiver_interface: "0.0.0.0",
            pickle_receiver_port: 2004,
            replication_factor: 2,
            destinations: [ carbonrelay_nodes ],
            enable_udp_listener: true,
            max_datapoints_per_message: 500,
            max_queue_size: 100000,
            use_flow_control: true,
            enable_amqp: true,
            amqp_host: node[:bb_monitor][:sensu][:rabbitmq][:server],
            amqp_port: 5672,
            amqp_vhost: node["statsd"]["rabbitmq"]["vhost"],
            amqp_user: node["statsd"]["rabbitmq"]["user"],
            amqp_password: node["statsd"]["rabbitmq"]["password"],
            amqp_exchange: "statsd",
            amqp_metric_name_in_body: true
          })
  notifies :restart, 'graphite_service[relay:rep]', :delayed
end

graphite_service "relay:rep"
