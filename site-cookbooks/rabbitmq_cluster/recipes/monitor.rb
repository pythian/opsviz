=begin
#<
Adds users required for monitoring RabbitMQ
#>
=end

rabbitmq_user "sensu_monitor" do
  password node["sensu"]["rabbitmq"]["password"]
  action :add
end

rabbitmq_user "sensu_monitor" do
    tag "monitoring"
    action :set_tags
end

gem_package 'carrot-top' do
    action :install
end

gem_package 'rest_client' do
    action :install
end
