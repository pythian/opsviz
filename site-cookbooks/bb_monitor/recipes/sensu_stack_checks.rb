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

if node[:provider] != "vagrant"
  node[:opsworks][:layers].each do |key, value|
    value["elb-load-balancers"].each do |elb|
      sensu_check "metric-sensu-elb-#{elb[:name]}" do
        type "metric"
        command "elb-metrics.rb -r #{node[:aws_region]} -n #{elb[:name]} --scheme stats.#{node[:opsworks][:stack][:name].downcase.gsub(' ','_')}.#{key}.elb"
        handlers node[:bb_monitor][:sensu][:default_metric_handlers]
        subscribers ["dashboard"]
        interval 30
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

sensu_check "check-elasticsearch-diskspace" do
  command "check-data.rb -s #{node[:graphite][:host]}:8081 -t 'averageSeries(stats.#{node[:opsworks][:stack][:name].downcase}.elasticsearch.*.diskspace.xvdi.capacity)' -a 120 -w 70 -c 80"
  handlers ["remediator"]
  subscribers ["dashboard1"]
  interval 30
  additional(:remediation => { :elasticsearch_scale_up => { :occurrences => [1], :severities => [2] }} )
end

sensu_check "elasticsearch_scale_up" do
  command "scaleOpsworksLayer.rb -s #{node[:opsworks][:stack][:name]} -r #{node[:aws_region]} -l ElasticSearch -i 2 -m 5 -t #{node[:instance_type][:elasticsearch]} -z #{node[:network][:private_subnet0_id]},#{node[:network][:private_subnet1_id]},#{node[:network][:private_subnet2_id]}"
  handlers ["debug"]
  subscribers [ ]
  publish false
end

sensu_check "check-logstash-loadavg" do
  command "check-data.rb -s #{node[:graphite][:host]}:8081 -t 'averageSeries(stats.#{node[:opsworks][:stack][:name].downcase}.logstash.*.load.load_avg.one)' -a 120 -w 2 -c 4"
  handlers ["remediator"]
  subscribers ["dashboard1"]
  interval 30
  additional(:remediation => { :logstash_scale_up => { :occurrences => [10], :severities => [1] }} )
end

sensu_check "logstash_scale_up" do
  command "scaleOpsworksLayer.rb -s #{node[:opsworks][:stack][:name]} -r #{node[:aws_region]} -l Logstash -i 1 -m 5 -t #{node[:instance_type][:logstash]} -z #{node[:network][:private_subnet0_id]},#{node[:network][:private_subnet1_id]},#{node[:network][:private_subnet2_id]}"
  handlers ["debug" ]
  subscribers [ ]
  publish false
end

sensu_check "check-dashboard-loadavg" do
  command "check-data.rb -s #{node[:graphite][:host]}:8081 -t 'averageSeries(stats.#{node[:opsworks][:stack][:name].downcase}.dashboard.*.load.load_avg.one)' -a 120 -w 2 -c 4"
  handlers ["remediator"]
  subscribers ["dashboard1"]
  interval 30
  additional(:remediation => { :dashboard_scale_up => { :occurrences => [10], :severities => [1] }} )
end

sensu_check "dashboard_scale_up" do
  command "scaleOpsworksLayer.rb -s #{node[:opsworks][:stack][:name]} -r #{node[:aws_region]} -l Dashboard -i 1 -m 3 -t #{node[:instance_type][:dashboard]} -z #{node[:network][:private_subnet0_id]},#{node[:network][:private_subnet1_id]},#{node[:network][:private_subnet2_id]}"
  handlers ["debug"]
  subscribers [ ]
  publish false
end

sensu_check "check-es-heap" do
  command "check-es-heap.rb -h #{node[:bb_monitor][:logstash][:server][:elasticsearch_server]}"
  handlers node[:bb_monitor][:sensu][:default_check_handlers]
  subscribers ["dashboard"]
  interval 300
  additional(:occurrences => 2)
end

sensu_check "check-es-cluster-status" do
  command "check-es-cluster-status.rb -h #{node[:bb_monitor][:logstash][:server][:elasticsearch_server]}"
  handlers node[:bb_monitor][:sensu][:default_check_handlers]
  subscribers ["dashboard"]
  interval 300
  additional(:occurrences => 2)
end

sensu_check "check-es-file-descriptors" do
  command "check-es-file-descriptors.rb -h #{node[:bb_monitor][:logstash][:server][:elasticsearch_server]}"
  handlers node[:bb_monitor][:sensu][:default_check_handlers]
  subscribers ["dashboard"]
  interval 300
  additional(:occurrences => 2)
end

stack_name = node[:opsworks][:stack][:name].downcase.gsub(' ','_')
# Metrics
sensu_check "metric-cluster-elasticsearch" do
  type "metric"
  command "es-cluster-metrics.rb -h #{node[:bb_monitor][:logstash][:server][:elasticsearch_server]} -s stats.#{stack_name}.elasticsearch.cluster"
  handlers node[:bb_monitor][:sensu][:default_metric_handlers]
  subscribers ["dashboard"]
  interval 30
end

sensu_check "metric-node-elasticsearch" do
  type "metric"
  command "es-node-metrics.rb -h #{node[:bb_monitor][:logstash][:server][:elasticsearch_server]} -s stats.#{stack_name.downcase}.elasticsearch"
  handlers node[:bb_monitor][:sensu][:default_metric_handlers]
  subscribers ["dashboard"]
  interval 30
end
