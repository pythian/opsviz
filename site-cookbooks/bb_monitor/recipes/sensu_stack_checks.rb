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
  command "check-data.rb -s #{node[:graphite][:host]}:8081 -t 'averageSeries(stats.#{node[:opsworks][:stack][:name]}.elasticsearch.*.diskspace.xvdi.capacity)' -a 120 -w 70 -c 80"
  handlers ["remediator","debug"]
  subscribers ["dashboard"]
  interval 30
  additional(:remediation => { :scale_up => { :occurrences => [2], :severities => [1] }} , :scale_up => { :command => "touch /tmp/autoscaling", :publish => false, :handlers => ["debug"] } )
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

stack_name = node[:opsworks][:stack][:name].downcase.gsub(' ','_')
# Metrics
sensu_check "metric-cluster-elasticsearch" do
  type "metric"
  command "es-cluster-metrics.rb -h #{node[:kibana][:elasticsearch_server]} -s stats.#{stack_name}.elasticsearch.cluster"
  handlers node[:bb_monitor][:sensu][:default_metric_handlers]
  subscribers ["dashboard"]
  interval 30
end

sensu_check "metric-node-elasticsearch" do
  type "metric"
  command "es-node-metrics.rb -h #{node[:kibana][:elasticsearch_server]} -s stats.#{stack_name}.elasticsearch"
  handlers node[:bb_monitor][:sensu][:default_metric_handlers]
  subscribers ["dashboard"]
  interval 30
end
