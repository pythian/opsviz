#!/usr/bin/env ruby
#
# Sensu Flowdock (https://www.flowdock.com/api/chat) notifier
# This handler sends event information to the Flowdock Push API: Chat.
# The handler pushes event output to chat:
# This setting is required in flowdock.json
#   auth_token  :  The flowdock api token (flow_api_token)
#
# Dependencies
# -----------
# - flowdock
#
#
# Author Ramez Hanna <rhanna@informatiq.org>

# Released under the same terms as Sensu (the MIT license); see LICENSE
# for details

require 'rubygems' if RUBY_VERSION < '1.9.0'
require 'sensu-handler'
require 'flowdock'
require 'json'

class FlowdockNotifier < Sensu::Handler

  def handle
    token = settings['flowdock']['auth_token']
    flowdock_source = settings['flowdock']['source']
    flowdock_url = settings['flowdock']['url']

    data = "Sensu event #{@event['check']['name']} #{@event['action']}d:\n\t#{@event['check']['output']}"
    if ["create", "resolve"].include? @event['action']

      case @event['check']['status']
      when 0
        level = "OK"
      when 1
        level = "WARNING"
      when 2
        level = "CRITICAL"
      else
        level = "UNKNOWN"
      end

      flow = Flowdock::Flow.new(:api_token => token, :source => flowdock_source, :from => {:name => "Sensu", :address => "tludwig+sensu@blackbirdit.com"})

      # send message to Team Inbox
      flow.push_to_team_inbox(:subject => data,
        :content => "<h2>#{@event['check']['output']}</h2><p><pre>#{JSON.pretty_generate(@event)}</pre></p>",
        :tags => ["sensu", "#{flowdock_source}", "#{@event['client']['name']}", "#{@event['action']}", "#{level}"], :link => flowdock_url)

    else
      puts "Skipping flowdock notification for non create or resolve event"
    end
  end

end