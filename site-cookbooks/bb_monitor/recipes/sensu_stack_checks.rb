%w[
  fog
  unf
  right_aws
  array_stats
].each do |package|
  gem_package package do
    action :install
  end
end

# TODO: we need the access key or ec2 roles setup to get this to work
# node[:opsworks][:layers].each do |key, value|
#   value["elb-load-balancers"].each do |elb|
#     sensu_check "metric-sensu-elb-#{elb[:name]}" do
#       type "metric"
#       command "elb-metrics.rb -a \"#{node[:s3][:access_key]}\" -k \"#{node[:s3][:secret_key]}\" -n #{elb[:name]} --scheme stats.#{node[:opsworks][:stack][:name].downcase}.#{key}.elb"
#       handlers node[:bb_monitor][:sensu][:default_metric_handlers]
#       subscribers ["sensu"]
#       interval 150
#     end
#
#     sensu_check "check-sensu-elb-#{elb[:name]}" do
#       command "check-elb-health.rb -a \"#{node[:s3][:access_key]}\" -s \"#{node[:s3][:secret_key]}\" -n #{elb[:name]} -v"
#       handlers node[:bb_monitor][:sensu][:default_check_handlers]
#       subscribers ["sensu"]
#       interval 150
#       additional(:occurrences => 2)
#     end
#
#   end
# end
