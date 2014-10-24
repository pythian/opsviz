#!/usr/bin/env ruby

require 'rubygems' if RUBY_VERSION < '1.9.0'
require 'csv'
require 'uri'
require 'sensu-plugin/metric/cli'

class CurlMetrics < Sensu::Plugin::Metric::CLI::Graphite

  option :scheme,
    :description => "Metric naming scheme, text to prepend to metric",
    :short => "-s SCHEME",
    :long => "--scheme SCHEME",
    :required => true,
    :default => "splunk"

  option :auth,
    :description => "Splunk auth user:pass",
    :short => "-a AUTH",
    :long => "--auth AUTH",
    :required => true

  option :splunk_location,
    :description => "Splunk cli location",
    :short => "-l LOCATION",
    :long => "--location LOCATION",
    :required => true,
    :default => "/opt/splunk/bin/splunk"

  option :query,
    :description => "Splunk query",
    :short => "-q QUERY",
    :long => "--query QUERY",
    :required => true

  option :name_field,
    :description => "Splunk name field",
    :short => "-n NAME",
    :long => "--name NAME",
    :required => true

  option :value_field,
    :description => "Splunk value field",
    :short => "-v VALUE",
    :long => "--v VALUE",
    :required => true


  def run
    cmd = "#{config[:splunk_location]} search \"#{config[:query]}\" -output csv -auth #{config[:auth]}"

    splunk_output = `#{cmd}`

    CSV.parse(splunk_output, :headers => true) do |row|
      names =Array.new
      config[:name_field].split(',').each do |name_field|
        names.push URI::encode(row[name_field].tr(' .:','_'))
      end
      output "#{config[:scheme]}.#{names.join('.')}", "#{row[config[:value_field]]}"
    end

    ok
  end

end