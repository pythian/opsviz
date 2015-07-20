=begin
#<
Wrapper around upstream kibana recipe to install kibana
#>
=end

node.force_override[:elasticsearch][:custom_config]["http.enabled"] = true
node.force_override[:elasticsearch][:custom_config]["node.data"] = false
node.force_override[:elasticsearch][:custom_config]["node.master"] = true

include_recipe 'bb_elasticsearch::default'

include_recipe "simple-kibana"
