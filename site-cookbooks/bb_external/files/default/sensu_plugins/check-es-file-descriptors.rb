#!/usr/bin/env ruby
#
# Checks ElasticSearch file descriptor status
# ===
#
# DESCRIPTION:
#   This plugin checks the ElasticSearch file descriptor usage, using its API.
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
# Author: S. Zachariah Sprackett <zac@sprackett.com>
#
# Released under the same terms as Sensu (the MIT license); see LICENSE
# for details.

require 'rubygems' if RUBY_VERSION < '1.9.0'
require 'sensu-plugin/check/cli'
require 'rest-client'
require 'json'

class ESClusterStatus < Sensu::Plugin::Check::CLI
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

  option :timeout,
  :description => 'Sets the connection timeout for REST client',
  :short => '-t SECS',
  :long => '--timeout SECS',
  :proc => proc {|a| a.to_i },
  :default => 30

  option :critical,
  :description => 'Critical percentage of FD usage',
  :short       => '-c PERCENTAGE',
  :proc        => proc { |a| a.to_i },
  :default     => 90

  option :warning,
  :description => 'Warning percentage of FD usage',
  :short       => '-w PERCENTAGE',
  :proc        => proc { |a| a.to_i },
  :default     => 80

  option :max_fd,
  :description => 'Maximum file descriptors',
  :short       => '-m MAXFD',
  :proc        => proc { |a| a.to_i },
  :default     => 64000

  def get_es_resource(resource)
    begin
      r = RestClient::Resource.new("http://#{config[:host]}:#{config[:port]}/#{resource}", :timeout => config[:timeout])
      JSON.parse(r.get)
    rescue Errno::ECONNREFUSED
      warning 'Connection refused'
    rescue RestClient::RequestTimeout
      warning 'Connection timed out'
    end
  end

  def get_fds
    stats = get_es_resource('_nodes/stats?process=true')

    fds = {}
    stats['nodes'].values.each do |node|
      begin
        fds[node['name']] = node['process']['open_file_descriptors'].to_i
      rescue
        warning 'Failed to obtain heap used in percent'
      end
    end

    fds
  end

  def run
    fds = get_fds
    p fds
    m = ""

    c, w = false
    fds.each do |name, nfds|
      used_percent = ((nfds.to_f / config[:max_fd].to_f) * 100).to_i

      if used_percent >= config[:critical]
        c = true
        m += "\nfd usage on #{name} #{used_percent}% exceeds #{config[:critical]}% (#{nfds}/#{config[:max_fd]})"
      elsif used_percent >= config[:warning]
        w = true
        m += "\nfd usage on #{name} #{used_percent}% exceeds #{config[:warning]}% (#{nfds}/#{config[:max_fd]})"
      else
        m += "\nfd usage on #{name} at #{used_percent}% (#{nfds}/#{config[:max_fd]})"
      end
    end

    message m
    critical if c
    warning if w
    ok unless c || w

  end
end
