%w[
  flowdock
  redphone
].each do |package|
  gem_package package do
    action :install
  end
end

%w[
  flowdock.rb
  pagerduty.rb
  remediator.rb
].each do |handler|
  cookbook_file ::File.join(node.sensu.directory, "handlers", handler) do
    source "sensu_handlers/#{handler}"
    mode 0755
  end
end

sensu_handler "graphite" do
  type "tcp"
  socket({
    :host => node['carbonrelay']['host'],
    :port => 2003
  })
  mutator "graphite"
end

sensu_handler "remediator" do
  type "pipe"
  command "/etc/sensu/handlers/remediator.rb"
  severities([
    :ok,
    :warning,
    :critical,
    :unknown
  ])
end

unless node[:bb_monitor][:sensu][:pagerduty_api].empty?
  sensu_snippet "pagerduty" do
    content({
      :api_key =>  node[:bb_monitor][:sensu][:pagerduty_api]
    })
  end

  pd_severities = ["ok", "critical"]
  pd_severities << "warning" if node[:bb_monitor][:sensu][:pagerduty_warn]

  sensu_handler "pagerduty" do
    type "pipe"
    command "pagerduty.rb"
    severities pd_severities
  end
end
