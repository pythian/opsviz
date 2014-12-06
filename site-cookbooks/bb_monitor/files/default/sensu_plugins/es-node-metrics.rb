#!/usr/bin/env ruby
#
# ElasticSearch Metrics Plugin
# ===
#
# This plugin uses the ES API to collect metrics, producing a JSON
# document which is outputted to STDOUT. An exit status of 0 indicates
# the plugin has successfully collected and produced.
#
# Copyright 2011 Sonian, Inc <chefs@sonian.net>
#
# Released under the same terms as Sensu (the MIT license); see LICENSE
# for details.

require 'rubygems' if RUBY_VERSION < '1.9.0'
require 'sensu-plugin/metric/cli'
require 'rest-client'
require 'json'

class ESMetrics < Sensu::Plugin::Metric::CLI::Graphite

  option :scheme,
  :description => "Metric naming scheme, text to prepend to queue_name.metric",
  :short => "-s SCHEME",
  :long => "--scheme SCHEME",
  :default => "#{Socket.gethostname}.elasticsearch"

  option :host,
  :description => "Elasticsearch server host.",
  :short => "-h HOST",
  :long => "--host HOST",
  :default => "localhost"

  option :port,
  :description => 'Elasticsearch port',
  :short => '-p PORT',
  :long => '--port PORT',
  :proc => proc {|a| a.to_i },
  :default => 9200

  def run
    stats = RestClient::Resource.new "http://#{config[:host]}:#{config[:port]}/_nodes/stats", :timeout => 30
    stats = JSON.parse(stats.get)

    timestamp = Time.now.to_i

    metrics = {}
    node = stats['nodes'].values.each do |node|
      name = node["name"].split('.').first

      metrics[name] = {}
      metrics[name]['os.load_average'] = node['os']['load_average'][0]
      metrics[name]['os.mem.free_in_bytes'] = node['os']['mem']['free_in_bytes']

      metrics[name]['process.mem.resident_in_bytes'] = node['process']['mem']['resident_in_bytes']

      node['jvm']['mem'].each do |key, value|
        metrics[name]["jvm.mem.#{key}"] = value if value.is_a? Numeric
      end

      node['indices'].each do |key, values|
        values.each do |key2, value|
          metrics[name]["indices.#{key}.#{key2}"] = value
        end
      end

      node['fs']['total'].each do |key, value|
        metrics[name]["fs.total.#{key}"] = value
      end

      %w(transport http fielddata_breaker).each do |key|
        node[key].each do |key2, value|
          metrics[name]["#{key}.#{key2}"] = value if value.is_a? Numeric
        end
      end

    end

    metrics.each do |node, nmetrics|
      nmetrics.each do |k, v|
        output([config[:scheme], node, k].join("."), v, timestamp)
      end
    end

    ok
  end

end
