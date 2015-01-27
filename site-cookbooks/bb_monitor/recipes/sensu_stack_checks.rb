=begin
#<
Adds sensu checks to monitor the opsviz stack
#>
=end

%w[
  fog
  unf
  right_aws
  array_stats
  rest-client
].each do |package|
  gem_package package do
    action :install
  end
end

#if node[:opsworks][:layers].kind_of?(Array)
if false
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
end

sensu_check "check-graphite-cache" do
  command "graphite.rb -h #{node[:graphite][:host]}:8081 -t carbon.agents.*.cache.size -a 1000,5000 -p 10minutes -g"
  handlers node[:bb_monitor][:sensu][:default_check_handlers]
  subscribers ["dashboard"]
  interval 300
  additional(:occurrences => 2)
end

sensu_check "check-es-heap" do
  command "check-es-heap.rb -h #{node[:kibana][:elasticsearch_server]}"
  handlers node[:bb_monitor][:sensu][:default_check_handlers]
  subscribers ["dashboard"]
  interval 300
  additional(:occurrences => 2)
end

sensu_check "check-es-cluster-status" do
  command "check-es-cluster-status.rb -h #{node[:kibana][:elasticsearch_server]}"
  handlers node[:bb_monitor][:sensu][:default_check_handlers]
  subscribers ["dashboard"]
  interval 300
  additional(:occurrences => 2)
end

sensu_check "check-es-file-descriptors" do
  command "check-es-file-descriptors.rb -h #{node[:kibana][:elasticsearch_server]}"
  handlers node[:bb_monitor][:sensu][:default_check_handlers]
  subscribers ["dashboard"]
  interval 300
  additional(:occurrences => 2)
end

# 4-Feb-15 08:28:57 damonp removing opsworks
#stack_name = node[:opsworks][:stack][:name].downcase.gsub(' ','_')
stack_name = "opsvis"
# Metrics
sensu_check "metric-cluster-elasticsearch" do
  type "metric"
  command "es-cluster-metrics.rb -h #{node[:kibana][:elasticsearch_server]} -s stats.#{stack_name}.elasticsearch.cluster"
  handlers node[:bb_monitor][:sensu][:default_metric_handlers]
  subscribers ["dashboard"]
  interval 60
end

sensu_check "metric-node-elasticsearch" do
  type "metric"
  command "es-node-metrics.rb -h #{node[:kibana][:elasticsearch_server]} -s stats.#{stack_name}.elasticsearch"
  handlers node[:bb_monitor][:sensu][:default_metric_handlers]
  subscribers ["dashboard"]
  interval 60
end
