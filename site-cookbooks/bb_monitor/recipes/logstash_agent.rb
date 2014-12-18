include_recipe "logstash::default"

template '/etc/init/logstash.conf' do
  source 'logstash.init.conf.erb'
  cookbook 'bb_external'
  owner 'root'
  group 'root'
  mode '0755'
  variables( :root => node[:bb_monitor][:logstash][:root] )
  notifies :restart, "service[logstash]"
end
