directory '/opt/aws-billing' do
  owner 'root'
  group 'root'
  mode '0777'
  action :create
end

directory '/opt/aws-billing/processing' do
  owner 'root'
  group 'root'
  mode '0777'
  action :create
end

template '/opt/aws-billing/aws-billing.go' do
  source 'aws-billing.go.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

template '/opt/aws-billing/aws-accounts-file.csv' do
  source 'aws-accounts-file.csv.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

bash "Build aws-billing Go Script" do
	cwd '/opt/aws-billing'
	code <<-EOH
	/usr/bin/go build aws-billing.go
	EOH
	action :run
end

cron "aws-billing processing CronTab" do
  minute '*'
  hour '*'
  day '*'
  month '*'
  command '/opt/aws-billing/aws-billing-process.sh > /dev/null 2>&1		'
  action :create
end