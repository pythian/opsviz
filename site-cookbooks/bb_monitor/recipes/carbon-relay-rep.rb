=begin
#>
Installs and configures graphite, carbon, and graphite-web. Carbon is configured to use AMQP
#<
=end

include_recipe 'python'

include_recipe "runit"

include_recipe "graphite::carbon"

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
            relay_method: consistent-hashing,
            replication_factor: 2,
            destinations: [ "thisnode:2414:fan", "theothernode:2414:fan" ],
            enable_udp_listener: true,
            max_datapoints_per_message: 500,
            max_queue_size: 100000
            use_flow_control: true,
          })
end

graphite_service "relay:rep"
