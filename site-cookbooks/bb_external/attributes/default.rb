# When true node name and subscriptions will be determined from opsworks attributes
default[:bb_external][:sensu][:opsworks] = false

default[:bb_external][:sensu][:keepalive_handler] = []
default[:bb_external][:sensu][:subscriptions] = ["all"]

default[:bb_external][:sensu][:rabbitmq][:user] = "sensu"
default[:bb_external][:sensu][:rabbitmq][:ssl] = true
default[:bb_external][:sensu][:rabbitmq][:port] = 5671

%w(server password).each do |attribute|
  unless node[:bb_external][:sensu][:rabbitmq].has_key?(attribute)
    raise "Missing attribute bb_external.sensu.rabbitmq.#{attribute}"
  end
end

# Forward attributes to sensu cookbook
normal[:sensu][:rabbitmq][:host] = node[:bb_external][:sensu][:rabbitmq][:server]
normal[:sensu][:rabbitmq][:password] = node[:bb_external][:sensu][:rabbitmq][:password]
normal[:sensu][:rabbitmq][:user] = node[:bb_external][:sensu][:rabbitmq][:user]

# Since we aren't use client side ssl certs we need to force sensu cookbook to use this specific settings
force_override[:sensu][:use_ssl] = false
force_override[:sensu][:rabbitmq][:port] = "#{node[:bb_external][:sensu][:rabbitmq][:port]}"
force_override[:sensu][:rabbitmq][:ssl] = "#{node[:bb_external][:sensu][:rabbitmq][:ssl]}"
