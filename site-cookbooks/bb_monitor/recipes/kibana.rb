=begin
#<
Wrapper around upstream kibana recipe to install kibana
#>
=end

include_recipe "simple-kibana"
# !ruby/array:Chef::Node::ImmutableArray
# remove this line from the /opt/kibana/config/kibana.yml
