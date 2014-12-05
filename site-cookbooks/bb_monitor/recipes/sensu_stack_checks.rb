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
      command "elb-metrics.rb -r #{node[:aws_region]} -n #{elb[:name]} --scheme stats.#{node[:opsworks][:stack][:name].downcase.gsub(' ','_')}.#{key}.elb"
      handlers node[:bb_monitor][:sensu][:default_metric_handlers]
      subscribers ["dashboard"]
      interval 150
    end

    sensu_check "check-sensu-elb-#{elb[:name]}" do
      command "check-elb-health.rb -r #{node[:aws_region]} -n #{elb[:name]} -v"
      handlers node[:bb_monitor][:sensu][:default_check_handlers]
      subscribers ["dashboard"]
      interval 150
      additional(:occurrences => 2)
    end

  end
end

sensu_check "check-graphite-cache" do
  command "graphite.rb -h #{node[:graphite][:host]}:8081 -t carbon.agents.*.cache.size -a 100,500 -p 10minutes -g"
  handlers node[:bb_monitor][:sensu][:default_check_handlers]
  subscribers ["dashboard"]
  interval 300
  additional(:occurrences => 2)
end
