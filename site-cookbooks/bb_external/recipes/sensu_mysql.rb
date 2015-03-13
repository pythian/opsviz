# Add gem dependences for mysql plugins
# Versions are added because CentOS can't run latest version of
{
  "mysql2" => {:version=>"0.3.18"},
  "inifile" => {:version=>"2.0.2"}
}.each do |package, attributes|
  gem_package package do
    action :install
    version attributes[:version]
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
