=begin
#>
Installs and configures graphite, carbon, and graphite-web. Carbon is configured to use AMQP
#<
=end

include_recipe 'python'

include_recipe "runit"

include_recipe "graphite::carbon"

graphite_storage 'default'

instances = node[:opsworks][:layers][:carboncache][:instances]
this_az = node[:opsworks][:instance][:availability_zone]
all_carboncache_instances = node[:opsworks][:layers][:carboncache][:instances]
carboncache_instances_in_this_az = all_carboncache_instances.select{ |name, attrs| attrs[:availability_zone] == this_az }
carboncache_nodes = carboncache_instances_in_this_az.map{ |name, attrs| "#{name}:2104:a, #{name}:2204:b" }

graphite_carbon_relay "fan" do
  config ({
            max_cache_size: "inf",
            max_updates_per_second: 500,
            max_creates_per_minute: 50,
            line_receiver_interface: "0.0.0.0",
            line_receiver_port: 2413,
            udp_receiver_port: 2413,
            pickle_receiver_interface: "0.0.0.0",
            pickle_receiver_port: 2414,
            relay_method: "consistent-hashing",
            destinations: [ carboncache_nodes ],
            enable_udp_listener: true,
            max_datapoints_per_message: 500,
            max_queue_size: 100000,
            use_flow_control: true
          })
end

graphite_service "relay:fan"
