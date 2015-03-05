# When true node name and subscriptions will be determined from opsworks attributes
default[:bb_external][:opsworks] = false

default[:bb_external][:sensu][:keepalive_handler] = []
default[:bb_external][:sensu][:subscriptions] = ["all"]

default[:bb_external][:sensu][:rabbitmq][:user] = "sensu"
default[:bb_external][:sensu][:rabbitmq][:ssl] = true
default[:bb_external][:sensu][:rabbitmq][:port] = 5671

# Default setting for mysql user for sensu plugins
default[:bb_external][:sensu][:mysql][:user] = "sensu"

default[:bb_external][:logstash][:rabbitmq][:port] = 5671
default[:bb_external][:logstash][:rabbitmq][:ssl] = true
default[:bb_external][:logstash][:rabbitmq][:verify_ssl] = false
default[:bb_external][:logstash][:rabbitmq][:exchange] = "logstash"
default[:bb_external][:logstash][:rabbitmq][:exchange_type] = "direct"
default[:bb_external][:logstash][:rabbitmq][:user] = "logstash_external"
default[:bb_external][:logstash][:file_inputs] = {}
default[:bb_external][:logstash][:filters] = []
default[:bb_external][:logstash][:root] = false

# Forward attributes to sensu cookbook
normal[:sensu][:rabbitmq][:host] = node[:bb_external][:sensu][:rabbitmq][:server]
normal[:sensu][:rabbitmq][:password] = node[:bb_external][:sensu][:rabbitmq][:password]
normal[:sensu][:rabbitmq][:user] = node[:bb_external][:sensu][:rabbitmq][:user]

# Since we aren't use client side ssl certs we need to force sensu cookbook to use this specific settings
force_override[:sensu][:use_ssl] = false
force_override[:sensu][:rabbitmq][:port] = "#{node[:bb_external][:sensu][:rabbitmq][:port]}"
force_override[:sensu][:rabbitmq][:ssl] = "#{node[:bb_external][:sensu][:rabbitmq][:ssl]}"
