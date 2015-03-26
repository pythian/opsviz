=begin
#<
Adds standard host-based checks and metrics to sensu for all nodes to be subscibbed to
#>
=end

include_recipe "bb_monitor::sensu_stack_checks"
include_recipe "bb_monitor::sensu_custom_checks"

# All Checks
sensu_check "check-disk_free" do
  command "check-disk.rb"
  handlers node[:bb_monitor][:sensu][:default_check_handlers]
  subscribers ["all"]
  interval 300
end

sensu_check "check-memory_free" do
  command "check-ram.rb"
  handlers node[:bb_monitor][:sensu][:default_check_handlers]
  subscribers ["all"]
  interval 60
  additional(:occurrences => 5)
end

sensu_check "check-load" do
  command "check-load.rb -p -w 8,5,2 -c 16,12,10"
  handlers node[:bb_monitor][:sensu][:default_check_handlers]
  subscribers ["all"]
  interval 60
  additional(:flapping => true)
end


## Metrics
sensu_check "metric-load" do
  type "metric"
  command "load-metrics.rb -p --scheme stats.:::name:::.load"
  handlers node[:bb_monitor][:sensu][:default_metric_handlers]
  subscribers ["all"]
  interval 60
end

sensu_check "metric-cpu" do
  type "metric"
  command "cpu-metrics.rb --scheme stats.:::name:::.cpu"
  handlers node[:bb_monitor][:sensu][:default_metric_handlers]
  subscribers ["all"]
  interval 37
end

sensu_check "metric-cpu_pcnt" do
  type "metric"
  command "cpu-pcnt-usage-metrics.rb --scheme stats.:::name:::.cpu-pcnt"
  handlers node[:bb_monitor][:sensu][:default_metric_handlers]
  subscribers ["all"]
  interval 37
end

sensu_check "metric-disk" do
  type "metric"
  command "disk-metrics.rb --scheme stats.:::name:::.disk"
  handlers node[:bb_monitor][:sensu][:default_metric_handlers]
  subscribers ["all"]
  interval 60
end

sensu_check "metric-memory" do
  type "metric"
  command "memory-metrics.rb --scheme stats.:::name:::.memory"
  handlers node[:bb_monitor][:sensu][:default_metric_handlers]
  subscribers ["all"]
  interval 60
end

sensu_check "metrics-net" do
  type "metric"
  command "metrics-net.rb --scheme stats.:::name:::.net"
  handlers node[:bb_monitor][:sensu][:default_metric_handlers]
  subscribers ["all"]
  interval 60
end

include_recipe "sensu"

sensu_check "rabbitmq-messages" do
  command "check-rabbitmq-messages.rb --user sensu_monitor --password \"#{node["sensu"]["rabbitmq"]["password"]}\" -w 600 -c 900"
  handlers node[:bb_monitor][:sensu][:default_check_handlers]
  subscribers ["rabbitmq"]
  interval 60
  additional(:occurrences => 2)
end

sensu_check "rabbitmq-cluster-health" do
  command "rabbitmq-cluster-health.rb --user sensu_monitor --password \"#{node["sensu"]["rabbitmq"]["password"]}\""
  handlers node[:bb_monitor][:sensu][:default_check_handlers]
  subscribers ["rabbitmq"]
  interval 60
end

sensu_check "rabbitmq-overview" do
  type "metric"
  command "rabbitmq-overview-metrics.rb --user sensu_monitor --password \"#{node["sensu"]["rabbitmq"]["password"]}\" --scheme stats.:::name:::"
  handlers node[:bb_monitor][:sensu][:default_metric_handlers]
  subscribers ["rabbitmq"]
  interval 60
end
