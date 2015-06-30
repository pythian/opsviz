ruby_block "Add AWS Billing Filters for Logstash" do 
	block do
		code[] = ""
		code << "input {"
		code << "  tcp {"
		code << "    port => 5140"
		code << "    codec => \"line\""
		code << "  }"
		code << "}"
		code << ""
		code << "filter {"
		code << "  json {"
		code << "    source => \"message\""
		code << "  }"
		code << ""
		code << "  mutate {"
		code << "    add_field => { \"index\" => \"logstash-%{+YYYY.MM.dd}\" }"
		code << "  }"
		code << ""
		code << "  if [type] == \"aws_billing_hourly\" or [type] == \"aws_billing_monthly\" {"
		code << "    if [type] == \"aws_billing_hourly\" {"
		code << "      date {"
		code << "        match => [ \"UsageStartDate\", \"ISO8601\" ]"
		code << "      }"
		code << "    }"
		code << "    if [type] == \"aws_billing_monthly\" {"
		code << "      date {"
		code << "        match => [ \"BillingPeriodStartDate\", \"ISO8601\" ]"
		code << "      }"
		code << "    }"
		code << "    mutate {"
		code << "      replace => [ \"index\", \"aws-billing-%{+YYYY.MM}\"]"
		code << "      remove_field => [ \"message\" ]"
		code << "    }"
		code << "  }"
		code << ""
		code << "}"
		code << ""
		code << "output {"
		code << "  elasticsearch {"
		code << "    embedded => true"
		code << "    index => \"%{index}\""
		code << "  }"
		code << "}"
		code.join("\n")
		File.open("/etc/logstash/conf.d/server.conf", "r").each_line do |line|
		  if line =~ /output/
		     puts code
		  end
		  puts "#{line}"
		end		
	end
	action: run
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
	action: run
end