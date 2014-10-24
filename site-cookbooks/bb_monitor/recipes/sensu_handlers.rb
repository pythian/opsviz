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
].each do |handler|
  cookbook_file ::File.join(node.sensu.directory, "handlers", handler) do
    source "sensu_handlers/#{handler}"
    mode 0755
  end
end

sensu_handler "graphite" do
  type "tcp"
  socket({
    :host => '127.0.0.1',
    :port => 2003
  })
  mutator "graphite"
end


if node[:bb_monitor][:sensu][:pagerduty_api]
  sensu_snippet "pagerduty" do
    content({
      :api_key =>  node[:bb_monitor][:sensu][:pagerduty_api]
    })
  end

  sensu_handler "pagerduty" do
    type "pipe"
    command "pagerduty.rb"
    severities ["ok", "critical", "warning"]
  end
end
