#!/usr/bin/env /usr/local/bin/ruby

require 'aws-sdk'
require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: test.rb [options]"

  opts.on('-b', '--bucket BUCKETNAME', 'Bucket name') { |v| options[:bucket] = v }
  opts.on('-r', '--region REGION', 'region') { |v| options[:region] = v }
  opts.on('-s', '--source SOURCE', 'Source file') { |v| options[:source] = v }
  opts.on('-d', '--destination DESTINATION', 'destination file') { |v| options[:dest] = v }

end.parse!

#raise OptionParser::MissingArgument if options[:bucket].nil?
#raise OptionParser::MissingArgument if options[:region].nil?
#raise OptionParser::MissingArgument if options[:source].nil?
#raise OptionParser::MissingArgument if options[:dest].nil?


s3 = Aws::S3::Client.new(
  region: options[:region]
)
resp = s3.get_object( response_target: options[:dest], bucket: options[:bucket], key: options[:source] )
