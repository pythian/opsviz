default[:kibana][:user] = 'admin'
default[:kibana][:password] = 'changeme'

normal[:kibana][:config][:cookbook] = 'bb_monitor'

#nginx
# install nginx from source so we get a high enough version for websockets
normal['nginx']['install_method'] = 'source'

##Sensu
normal[:sensu][:use_ssl] = false
normal[:sensu][:rabbitmq][:host] = node[:bb_monitor][:sensu][:rabbitmq][:server]
normal[:sensu][:rabbitmq][:password] = node[:bb_monitor][:sensu][:rabbitmq][:password]
normal[:sensu][:redis][:host] = node[:bb_monitor][:sensu][:server_url]
normal[:sensu][:api][:host] = node[:bb_monitor][:sensu][:server_url]
normal[:sensu][:log_level] = "warn"

default[:bb_monitor][:sensu][:rds_identifiers] = []
default[:bb_monitor][:sensu][:pagerduty_api] = ""
default[:bb_monitor][:sensu][:pagerduty_warn] = true

default[:bb_monitor][:sensu][:default_check_handlers] = []

# Define custom checks via custom json. See Readme for more info
default[:bb_monitor][:sensu][:custom_checks] = {}

unless node[:bb_monitor][:sensu][:pagerduty_api].empty?
  default[:bb_monitor][:sensu][:default_check_handlers] = ["pagerduty"] + node[:bb_monitor][:sensu][:default_check_handlers]
end

default[:bb_monitor][:sensu][:default_metric_handlers] = ["graphite"]

default[:bb_monitor][:sensu][:subscriptions] = ["all"] + node[:opsworks][:instance][:layers]

# Disable sensu dashboard user/pass since we have nginx in front
normal['uchiwa']['settings']['user'] = ''
normal['uchiwa']['settings']['pass'] = ''
