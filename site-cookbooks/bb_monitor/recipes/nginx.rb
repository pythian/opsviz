include_recipe 'nginx'

begin
  doorman_enabled = node["doorman"]["enabled"].eql? "true"
  Chef::Log.debug("node[\"doorman\"][\"enabled\"] is #{node['doorman']['enabled']}.  Configuring doorman.")
  Chef::Log.info("doorman_enabled is #{doorman_enabled}.  Configuring doorman.")
  include_recipe 'bb_monitor::doorman' if doorman_enabled
rescue
  Chef::Log.info("Couldn't find node[\"doorman\"][\"enabled\"].  Not configuring doorman.")
end

file "/etc/nginx/sites-enabled/default" do
  action :delete
end

basedir = "/var/www/"

['dashboard','dashboard/css','dashboard/fonts','dashboard/js'].each do |webdir|
  directory basedir + webdir do
    owner 'root'
    group 'root'
    mode '0755'
    action :create
  end
end

['dashboard/css/bootstrap-theme.css',
'dashboard/css/bootstrap-theme.css.map',
'dashboard/css/bootstrap-theme.min.css',
'dashboard/css/bootstrap.css',
'dashboard/css/bootstrap.css.map',
'dashboard/css/bootstrap.min.css',
'dashboard/fonts/glyphicons-halflings-regular.eot',
'dashboard/fonts/glyphicons-halflings-regular.svg',
'dashboard/fonts/glyphicons-halflings-regular.ttf',
'dashboard/fonts/glyphicons-halflings-regular.woff',
'dashboard/fonts/glyphicons-halflings-regular.woff2',
'dashboard/index.html',
'dashboard/js/bootstrap.js',
'dashboard/js/bootstrap.min.js',
'dashboard/js/npm.js'].each do |webfile|
    cookbook_file webfile do 
      source webfile 
      owner 'root'
      group 'root'
      mode '0644'
      path basedir + webfile
      action :create
    end
end

template "/etc/nginx/sites-available/dashboard" do
  source "nginx/dashboard.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, "service[nginx]"
end

link "/etc/nginx/sites-enabled/dashboard" do
  to "/etc/nginx/sites-available/dashboard"
  notifies :restart, "runit_service[nginx]"
end
