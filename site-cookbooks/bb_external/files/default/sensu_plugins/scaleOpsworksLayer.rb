#!/usr/bin/env ruby

require 'aws-sdk'
require 'optparse'


options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: test.rb [options]"

  opts.on('-s', '--stackname STACKNAME', 'Source stackname') { |v| options[:source_stackname] = v }
  opts.on('-r', '--region REGION', 'Source region') { |v| options[:source_region] = v }
  opts.on('-l', '--layername LAYERNAME', 'Source layername') { |v| options[:source_layername] = v }
  opts.on('-i', '--instancecount INSTANCECOUNT', 'Source instancecount') { |v| options[:source_instancecount] = v }
  opts.on('-m', '--maxinstancecount MAXINSTANCECOUNT', 'Source maxinstancecount') { |v| options[:source_maxinstancecount] = v }
  opts.on('-t', '--instancetype INSTANCETYPE', 'Source instancetype') { |v| options[:source_instancetype] = v }
  opts.on('-x', '--accesskey ACCESSKEY', 'Source accesskey') { |v| options[:source_accesskey] = v }
  opts.on('-y', '--accesskey SECRETKEY', 'Source secretkey') { |v| options[:source_secretkey] = v }
  opts.on('-z', '--subnetids SUBNETIDS', Array, 'Source subnetids') { |v| options[:source_subnetids] = v }

end.parse!

raise OptionParser::MissingArgument if options[:source_stackname].nil?
raise OptionParser::MissingArgument if options[:source_region].nil?
raise OptionParser::MissingArgument if options[:source_layername].nil?
raise OptionParser::MissingArgument if options[:source_instancecount].nil?
raise OptionParser::MissingArgument if options[:source_maxinstancecount].nil?
raise OptionParser::MissingArgument if options[:source_instancetype].nil?

puts options[:source_accesskey]
puts options[:source_secretkey]

unless options[:source_accesskey].nil? & options[:source_secretkey].nil?
  Aws.config.update({
    region: options[:source_region],
    credentials: Aws::Credentials.new(options[:source_accesskey], options[:source_secretkey]),
  })
end

opsworks = Aws::OpsWorks::Client.new(region: options[:source_region] )
stack = opsworks.describe_stacks.stacks.select { |a| a.name == options[:source_stackname] }
stack_id = stack[0][0]

layers = opsworks.describe_layers({
  stack_id: stack_id,
})

layer = layers.layers.select { |a| a.name == options[:source_layername] }
layer_id = layer[0][1]

instances = opsworks.describe_instances({
  layer_id: layer_id,
})
currentinstancecount = instances.instances.count
numberofsubnets = options[:source_subnetids].count

arraycount = Array.new

m = options[:source_maxinstancecount].to_i
if currentinstancecount >= m then
  exit
end

$i = 0 
n = options[:source_instancecount].to_i

while $i < n do

  $j = 0
  while $j < numberofsubnets do
    instances = opsworks.describe_instances({
      layer_id: layer_id,
    })
    instances_in_subnet = instances.instances.select { |attrs| attrs['subnet_id'] == options[:source_subnetids][$j] }
    arraycount[$j] = instances_in_subnet.count
    $j +=1
  end
  arraymin = arraycount.index(arraycount.min)

  newinstance1 = opsworks.create_instance({
    stack_id: stack_id,
    layer_ids: [ layer_id ],
    instance_type: options[:source_instancetype],
    subnet_id: options[:source_subnetids][arraymin]
  })

  #opsworks.start_instance({
  #  instance_id: newinstance1[0]
  #})

  $i +=1

end
