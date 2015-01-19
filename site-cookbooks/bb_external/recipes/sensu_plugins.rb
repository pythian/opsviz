%w[
  sensu-plugin
].each do |package|
  gem_package package do
    action :install
  end
end

%w[
  check-cpu.rb
  check-disk.rb
  check-elb-health.rb
  check-elb-nodes.rb
  check-http.rb
  check-load.rb
  check-ram.rb
  cpu-metrics.rb
  cpu-pcnt-usage-metrics.rb
  disk-metrics.rb
  elb-metrics.rb
  graphite.rb
  java-heap-graphite.sh
  load-metrics.rb
  memory-metrics.rb
  metrics-curl.rb
  metrics-splunk.rb
  rds-metrics.rb
  apache-graphite.rb
  check-rabbitmq-messages.rb
  check-rabbitmq-queue.rb
  rabbitmq-cluster-health.rb
  rabbitmq-overview-metrics.rb
  check-es-cluster-status.rb
  check-es-file-descriptors.rb
  check-es-heap.rb
  es-cluster-metrics.rb
  es-node-metrics.rb
].each do |plugin|
  cookbook_file ::File.join(node.sensu.directory, "plugins", plugin) do
    source "sensu_plugins/#{plugin}"
    mode 0755
  end
end
