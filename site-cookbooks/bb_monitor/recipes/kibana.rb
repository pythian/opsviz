=begin
#<
Wrapper around upstream kibana recipe to install kibana
#>
=end
include_recipe "simple-kibana"

# !ruby/array:Chef::Node::ImmutableArray
# remove this line from the /opt/kibana/config/kibana.yml
# something wrong with the array / cb
ruby_block "Patch for SimpleKibana Issue" do
    block do
		text = File.read('/opt/kibana/config/kibana.yml')
		new_contents = text.gsub('!ruby/array:Chef::Node::ImmutableArray', "")
		# write changes 
		File.open('/opt/kibana/config/kibana.yml', "w") {|file| file.puts new_contents }
	end
end
