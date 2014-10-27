%w[
  fog
  unf
  right_aws
  array_stats
].each do |package|
  gem_package package do
    action :install
  end
end

node[:opsworks][:layers].each do |key, value|
  value["elb-load-balancers"].each do |elb|
    sensu_check "metric-sensu-elb-#{elb[:name]}" do
      type "metric"
      command "elb-metrics.rb -n #{elb[:name]} --scheme stats.#{node[:opsworks][:stack][:name].downcase.gsub(' ','_')}.#{key}.elb"
      handlers node[:bb_monitor][:sensu][:default_metric_handlers]
      subscribers ["dashboard"]
      interval 150
    end

    sensu_check "check-sensu-elb-#{elb[:name]}" do
      command "check-elb-health.rb -n #{elb[:name]} -v"
      handlers node[:bb_monitor][:sensu][:default_check_handlers]
      subscribers ["dashboard"]
      interval 150
      additional(:occurrences => 2)
    end

  end
end
