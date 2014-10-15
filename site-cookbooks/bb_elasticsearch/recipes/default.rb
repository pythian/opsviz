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

if node[:elasticsearch][:http_auth]
  install_plugin 'http-basic', 'url' => node[:elasticsearch][:http_auth_plugin]
end
