=begin
#<
Installs elasticsearch with the http-basic authentication plugin
#>
=end
#
# Cookbook Name:: bb-elasticsearch
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

# Installs and configures elasticsearch and java with elasticsearch-http-basic plugin

include_recipe 'java'
include_recipe 'elasticsearch'
include_recipe 'elasticsearch::aws'

if node[:elasticsearch][:http_auth] == true
  install_plugin 'http-basic', 'url' => node[:elasticsearch][:http_auth_plugin]
end

install_plugin 'elasticsearch/marvel/latest'
