#!/usr/bin/env ruby
#
# Checks ElasticSearch heap usage
# ===
#
# DESCRIPTION:
#   This plugin checks ElasticSearch's Java heap usage using its API.
#
# OUTPUT:
#   plain-text
#
# PLATFORMS:
#   all
#
# DEPENDENCIES:
#   sensu-plugin Ruby gem
#   rest-client Ruby gem
#
# Copyright 2012 Sonian, Inc <chefs@sonian.net>
#
# Released under the same terms as Sensu (the MIT license); see LICENSE
# for details.

require 'rubygems' if RUBY_VERSION < '1.9.0'
require 'sensu-plugin/check/cli'
require 'rest-client'
require 'json'

class ESHeap < Sensu::Plugin::Check::CLI

  option :host,
  :description => 'Elasticsearch host',
  :short => '-h HOST',
  :long => '--host HOST',
  :default => 'localhost'

  option :port,
  :description => 'Elasticsearch port',
  :short => '-p PORT',
  :long => '--port PORT',
  :proc => proc {|a| a.to_i },
  :default => 9200

  option :warn,
  :short => '-w N',
  :long => '--warn N',
  :description => 'Heap used in percent WARNING threshold',
  :proc => proc {|a| a.to_i },
  :default => 80

  option :timeout,
  :description => 'Sets the connection timeout for REST client',
  :short => '-t SECS',
  :long => '--timeout SECS',
  :proc => proc {|a| a.to_i },
  :default => 30

  option :crit,
  :short => '-c N',
  :long => '--crit N',
  :description => 'Heap used in percent CRITICAL threshold',
  :proc => proc {|a| a.to_i },
  :default => 95

  def get_es_version
    info = get_es_resource('/')
    info['version']['number']
  end

  def get_es_resource(resource)
    begin
      r = RestClient::Resource.new("http://#{config[:host]}:#{config[:port]}/#{resource}", :timeout => config[:timeout])
      JSON.parse(r.get)
    rescue Errno::ECONNREFUSED
      warning 'Connection refused'
    rescue RestClient::RequestTimeout
      warning 'Connection timed out'
    rescue JSON::ParserError
      warning 'Elasticsearch API returned invalid JSON'
    end
  end

  def get_heap_used
    if Gem::Version.new(get_es_version) >= Gem::Version.new('1.0.0')
      stats = get_es_resource('_nodes/stats?jvm=true')

      percents = {}
      stats['nodes'].values.each do |node|
        begin
          percents[node['name']] = node['jvm']['mem']['heap_used_percent']
        rescue
          warning 'Failed to obtain heap used in percent'
        end
      end

      percents
    end
  end

  def run
    heap_used = get_heap_used
    message heap_used

    c, w = false
    heap_used.each do |name, percent|
      if percent >= config[:crit]
        c = true
      elsif percent >= config[:warn]
        w = true
      end
    end

    critical if c
    warning if w
    ok unless c || w

  end

end
