=begin
#>
Installs and configures graphite, carbon, and graphite-web. Carbon is configured to use AMQP
#<
=end

include_recipe 'python'

include_recipe "runit"

include_recipe "graphite::web"

base_dir = "#{node['graphite']['base_dir']}"

instances = node[:opsworks][:layers][:carboncache][:instances]
graphiteweb_nodes = instances.map{ |name, attrs| "#{name}:80" }

graphite_web_config "#{base_dir}/webapp/graphite/local_settings.py" do
  config({
           secret_key: node['graphite']['password'],
           time_zone: "America/Chicago",
           conf_dir: "#{base_dir}/conf",
           storage_dir: "#{base_dir}/storage",
           databases: {
             default: {
               # keys need to be upcase here
               NAME: "#{base_dir}/storage/graphite.db",
               ENGINE: "django.db.backends.sqlite3",
               USER: node['graphite']['user'],
               PASSWORD: node['graphite']['password'],
               HOST: nil,
               PORT: nil
             }
           },
           cluster_servers: [ graphiteweb_nodes ],
           carbonlink_hosts: [ "127.0.0.1:7102:a", "127.0.0.1:7202:a" ]
         })
  notifies :restart, 'service[graphite-web]', :delayed
end

directory "#{base_dir}/storage/log/webapp" do
  owner node['graphite']['user']
  group node['graphite']['group']
  recursive true
end

execute "python manage.py syncdb --noinput" do
  user node['graphite']['user']
  group node['graphite']['group']
  cwd "#{base_dir}/webapp/graphite"
  creates "#{base_dir}/storage/graphite.db"
end

runit_service 'graphite-web' do
  cookbook 'graphite'
  sv_timeout 60
  default_logger true
  retries 2
  retry_delay 10
end
