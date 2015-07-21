=begin
#<
Wrapper around upstream kibana recipe to install kibana
#>
=end
include_recipe "simple-kibana"

# !ruby/array:Chef::Node::ImmutableArray
# remove this line from the /opt/kibana/config/kibana.yml
# something wrong with the array / cb
ruby_block "copy libmysql.dll into ruby path" do
    block do
		text = File.read('kibana.yml')
		new_contents = text.gsub('!ruby/array:Chef::Node::ImmutableArray', "")
		# write changes 
		File.open('kibana.yml', "w") {|file| file.puts new_contents }
	end
end
# quick kibana restart
bash 'Kibana 4 Restart' do
  cwd '/opt'
  code <<-EOH
    service kibana restart
    EOH
end