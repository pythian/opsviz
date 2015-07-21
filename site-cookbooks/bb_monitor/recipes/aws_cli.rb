include_recipe "awscli::default"
# add a default config
directory '/root/.aws' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end
# create the config file
template '/root/.aws/config' do
	source 'aws-cli-config.erb'
	owner 'root'
	group 'root'
	mode '0600'
	variables(
		:awsRegion => node[:opsworks][:instance][:region],
		:outputType => 'text'
		)
end
# add the shell script
template '/opt/aws_get_ami.sh' do
  source 'aws_get_ami.sh.erb'
  owner 'root'
  group 'root'
  mode '0777'
  variables( :instanceId => node[:opsworks][:instance][:aws_instance_id] )
end
# run the shell script
bash 'AMI Image put on Disk for Sensu Client' do
  cwd '/opt'
  code <<-EOH
    ./aws_get_ami.sh
    EOH
end