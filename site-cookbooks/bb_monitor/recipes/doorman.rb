include_recipe 'nodejs'

git '/opt/doorman' do
  repository 'https://github.com/movableink/doorman.git'
  action :sync
end

execute 'install doorman dependencies' do
  command 'npm install'
  cwd '/opt/doorman'
  retries 5
  retry_delay 10
  action :run
end

template '/opt/doorman/conf.js' do
  source 'doorman/conf.js.erb'
  owner 'root'
  group 'root'
  mode '0744'
end

runit_service "doorman" do
  default_logger true
end
