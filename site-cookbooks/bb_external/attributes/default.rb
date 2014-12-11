# When true node name and subscriptions will be determined from opsworks attributes
default[:bb_external][:sensu][:opsworks] = false

default[:bb_external][:sensu][:keepalive_handler] = []
default[:bb_external][:sensu][:subscriptions] = ["all"]

default[:bb_external][:sensu][:rabbitmq][:user] = "sensu"
default[:bb_external][:sensu][:rabbitmq][:ssl] = true
default[:bb_external][:sensu][:rabbitmq][:port] = 5671

default[:bb_external][:logstash][:agent][:outputs][:rabbitmq][:port] = 5671
default[:bb_external][:logstash][:agent][:outputs][:rabbitmq][:ssl] = true
default[:bb_external][:logstash][:agent][:outputs][:rabbitmq][:verify_ssl] = false
default[:bb_external][:logstash][:agent][:outputs][:rabbitmq][:exchange] = "logstash"
default[:bb_external][:logstash][:agent][:outputs][:rabbitmq][:exchange_type] = "direct"

# Forward attributes to sensu cookbook
normal[:sensu][:rabbitmq][:host] = node[:bb_external][:sensu][:rabbitmq][:server]
normal[:sensu][:rabbitmq][:password] = node[:bb_external][:sensu][:rabbitmq][:password]
normal[:sensu][:rabbitmq][:user] = node[:bb_external][:sensu][:rabbitmq][:user]

# Forward attributes to logstash cookbook
normal[:logstash] = node[:bb_external][:logstash].to_hash

# Since we aren't use client side ssl certs we need to force sensu cookbook to use this specific settings
force_override[:sensu][:use_ssl] = false
force_override[:sensu][:rabbitmq][:port] = "#{node[:bb_external][:sensu][:rabbitmq][:port]}"
force_override[:sensu][:rabbitmq][:ssl] = "#{node[:bb_external][:sensu][:rabbitmq][:ssl]}"
