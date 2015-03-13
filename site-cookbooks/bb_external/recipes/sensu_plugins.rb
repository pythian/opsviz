%w[
  sensu-plugin
  aws-sdk
].each do |package|
  gem_package package do
    action :install
  end
end

%w[
  apache-graphite.rb
  check-cpu.rb
  check-disk.rb
  check-elb-health.rb
  check-elb-nodes.rb
  check-http.rb
  check-load.rb
  check_mongodb.py
  check-rabbitmq-messages.rb
  check-rabbitmq-queue.rb
  check-ram.rb
  check-rds.rb
  check-rds-events.rb
  check-snmp.rb
  cpu-metrics.rb
  cpu-pcnt-usage-metrics.rb
  disk-metrics.rb
  elb-metrics.rb
  es-cluster-metrics.rb
  es-node-metrics.rb
  graphite.rb
  java-heap-graphite.sh
  load-metrics.rb
  memory-metrics.rb
  metrics-curl.rb
  metrics-splunk.rb
  mongodb-metrics.rb
  nginx-metrics.rb
  rabbitmq-cluster-health.rb
  rabbitmq-overview-metrics.rb
  rds-metrics.rb
  snmp-metrics.rb
  snmp-if-metrics.rb
  check-es-cluster-status.rb
  check-es-file-descriptors.rb
  check-es-heap.rb
  es-cluster-metrics.rb
  es-node-metrics.rb
  mysql-graphite.rb
].each do |plugin|
  cookbook_file ::File.join(node.sensu.directory, "plugins", plugin) do
    source "sensu_plugins/#{plugin}"
    mode 0755
  end
end

# needed by some community aws plugins
gem_package 'aws-sdk' do
  action :install
end

# Add mysql dependencies if check is subscribing to 'mysql' in [:bb_external][:sensu][:subscriptions]
include_recipe "bb_external::sensu_mysql" if node[:bb_external][:sensu][:subscriptions].include? 'mysql'
