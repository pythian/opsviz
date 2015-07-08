=begin
#>
Installs and configures graphite, carbon, and graphite-web. Carbon is configured to use AMQP
#<
=end

include_recipe 'python'

include_recipe "runit"

include_recipe "graphite::carbon"

graphite_carbon_cache "a" do
  config ({
            cache_write_strategy: "sorted",
            max_cache_size: "inf",
            use_flow_control: true,
            whisper_fallocate_create: true,
            max_creates_per_minute: 3000,
            max_updates_per_second: 10000,
            line_receiver_interface: "0.0.0.0",
            line_receiver_port: 2103,
            pickle_receiver_interface: "0.0.0.0",
            pickle_receiver_port: 2104,
            use_insecure_unpickler: false,
            cache_query_interface: "0.0.0.0",
            cache_query_port: 7102,
            log_cache_hits: false,
            log_cache_queue_sorts: true,
            log_listener_connections: true,
            log_updates: false,
            enable_logrotation: true,
            whisper_autoflush: false
          })
end

graphite_carbon_cache "b" do
  config ({
            cache_write_strategy: "sorted",
            max_cache_size: "inf",
            use_flow_control: true,
            whisper_fallocate_create: true,
            max_creates_per_minute: 3000,
            max_updates_per_second: 10000,
            line_receiver_interface: "0.0.0.0",
            line_receiver_port: 2203,
            pickle_receiver_interface: "0.0.0.0",
            pickle_receiver_port: 2204,
            use_insecure_unpickler: false,
            cache_query_interface: "0.0.0.0",
            cache_query_port: 7202,
            log_cache_hits: false,
            log_cache_queue_sorts: true,
            log_listener_connections: true,
            log_updates: false,
            enable_logrotation: true,
            whisper_autoflush: false
          })
end


graphite_storage_schema "carbon" do
  config ({
      pattern: "^carbon\.",
      retentions: "60:90d"
    })
end

graphite_storage_schema "default" do
  config ({
            pattern: ".*",
            retentions: "30s:30d,5m:1y,1h:5y"
          })
end

graphite_service "cache:a"
graphite_service "cache:b"


