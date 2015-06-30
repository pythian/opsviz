template '/etc/logstash/conf.d/aws-billing.conf' do
  source 'aws-billing-logstash.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables({
    :elasticsearchserver => node['bb_monitor']['logstash']['server']['elasticsearch_server']
  })
  notifies :restart, "service[logstash]"
end

# es template
template '/tmp/aws-billing-es-template.json' do
  source 'aws-billing-es-template.json.erb'
  owner 'root'
  group 'root'
  mode '0644'
end
# create the index
bash "Add Elastic Index" do
	cwd '/tmp'
	code <<-EOH
	/usr/bin/curl -XPUT internal-opsviz-ly-ElasticS-1RX3IK7XSI64W-427689751.us-west-2.elb.amazonaws.com:9200/_template/aws_billing -d "`cat aws-billing-es-template.json`"
	EOH
	action :run
end