#!/usr/bin/env ruby
#
# check AWS AMI ID Number
#
if not File.exist?("/etc/aws/ami.txt")
	puts 'WARNING - AMI ID File Not Found'
	exit 1
elsif File.zero?("/etc/aws/ami.txt")
	puts 'WARNING - AMI ID File Empty'
  	exit 1
else
	data = File.read("/etc/aws/ami.txt")
	puts "OK - #{data}"
	exit 0
end