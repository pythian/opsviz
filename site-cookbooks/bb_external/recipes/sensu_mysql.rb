# Add gem dependences for mysql plugins
%w[
  mysql2
  inifile
].each do |package|
  gem_package package do
    action :install
  end
end

log "MySQL sensu plugins" do
  level :info
  message "MySQL plugin execution"
end

%w(password).each do |attribute|
  unless node[:bb_external][:sensu][:mysql].has_key?(attribute)
    raise "Missing attribute bb_external.sensu.mysql.#{attribute}"
  end
end

# configure /opt/sensu/.my.cnf
# TODO: If using 5.6 we can utilize encrypted files, but plugins will have to be modified
template "/opt/sensu/.my.cnf" do
  source "my.cnf_sensu.erb"
  owner "sensu"
  group "sensu"
  mode "0400"
  variables( :mysql_user => node[:bb_external][:sensu][:mysql][:user], :mysql_password => node[:bb_external][:sensu][:mysql][:password] )
end
