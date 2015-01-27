# Description

Installs/Configures bb-monitor

# Requirements

## Platform:

*No platforms defined*

## Cookbooks:

* kibana
* htpasswd
* graphite
* python
* runit
* grafana
* sensu
* uchiwa
* nodejs
* route53
* bb_external

# Attributes

* `node[:kibana][:user]` -  Defaults to `"admin"`.
* `node[:kibana][:password]` -  Defaults to `"changeme"`.
* `node[:bb_monitor][:sensu][:rds_identifiers]` -  Defaults to `"[ ... ]"`.
* `node[:bb_monitor][:sensu][:pagerduty_api]` -  Defaults to `""`.
* `node[:bb_monitor][:sensu][:pagerduty_warn]` -  Defaults to `"true"`.
* `node[:bb_monitor][:sensu][:default_check_handlers]` -  Defaults to `"[ ... ]"`.
* `node[:bb_monitor][:sensu][:custom_checks]` -  Defaults to `"{ ... }"`.
* `node[:bb_monitor][:sensu][:default_metric_handlers]` -  Defaults to `"[ ... ]"`.
* `node[:bb_monitor][:sensu][:subscriptions]` -  Defaults to `"[ ... ]"`.
* `node[:bb_monitor][:logstash][:root]` -  Defaults to `"true"`.
* `node[:bb_monitor][:logstash][:rabbitmq][:server]` -  Defaults to `""`.
* `node[:bb_monitor][:logstash][:rabbitmq][:password]` -  Defaults to `""`.
* `node[:bb_monitor][:logstash][:rabbitmq][:user]` -  Defaults to `"logstash_internal"`.
* `node[:bb_monitor][:logstash][:rabbitmq][:queue]` -  Defaults to `"incoming_logs"`.
* `node[:bb_monitor][:logstash][:rabbitmq][:exchange]` -  Defaults to `"logstash"`.
* `node[:bb_monitor][:logstash][:rabbitmq][:exchange_type]` -  Defaults to `"direct"`.
* `node[:bb_monitor][:logstash][:tags]` -  Defaults to `"[ ... ]"`.
* `node[:bb_monitor][:logstash][:server][:elasticsearch_server]` -  Defaults to `""`.
* `node[:bb_monitor][:logstash][:server][:threads]` -  Defaults to `"4"`.
* `node[:bb_monitor][:logstash][:server][:filters]` -  Defaults to `"[ ... ]"`.
* `node[:bb_monitor][:logstash][:server][:statsd_output]` -  Defaults to `"{ ... }"`.

# Recipes

* bb_monitor::default
* [bb_monitor::doorman](#bb_monitordoorman)
* [bb_monitor::flapjack](#bb_monitorflapjack)
* [bb_monitor::grafana](#bb_monitorgrafana)
* bb_monitor::graphite
* [bb_monitor::kibana](#bb_monitorkibana)
* [bb_monitor::logstash_agent](#bb_monitorlogstash_agent)
* [bb_monitor::logstash_server](#bb_monitorlogstash_server)
* bb_monitor::nginx
* [bb_monitor::nginx_lua_cjson](#bb_monitornginx_lua_cjson)
* [bb_monitor::route53](#bb_monitorroute53)
* [bb_monitor::sensu_checks](#bb_monitorsensu_checks)
* bb_monitor::sensu_client
* [bb_monitor::sensu_client_remove](#bb_monitorsensu_client_remove)
* [bb_monitor::sensu_custom_checks](#bb_monitorsensu_custom_checks)
* bb_monitor::sensu_extensions
* bb_monitor::sensu_handlers
* [bb_monitor::sensu_mutators](#bb_monitorsensu_mutators)
* [bb_monitor::sensu_server](#bb_monitorsensu_server)
* [bb_monitor::sensu_stack_checks](#bb_monitorsensu_stack_checks)

## bb_monitor::doorman

Configures and installs doorman

## bb_monitor::flapjack

Installs and configures flapjack

## bb_monitor::grafana

Wrapper around upstream grafana recipe to provide a custom default configuration

## bb_monitor::kibana

Wrapper around upstream kibana recipe to install kibana

## bb_monitor::logstash_agent

Wrapper around upstream logstash module to provide a custom logstash.conf

## bb_monitor::logstash_server

Adds attributes for logstash to prevent agent configuration

## bb_monitor::nginx_lua_cjson

Compiles lua cjson library

## bb_monitor::route53

Wrapper around the upstream route53 module for nodes to register their hostnames with route53

## bb_monitor::sensu_checks

Adds standard host-based checks and metrics to sensu for all nodes to be subscibbed to

## bb_monitor::sensu_client_remove

Removes a client from sensu by using a curl call to the sensu API

## bb_monitor::sensu_custom_checks

Allows the creation of custom checks via the node[:bb_monitor][:sensu][:custom_checks] attribute

## bb_monitor::sensu_mutators

Adds mutators to sensu metrics so that stack names are included in the metrics

## bb_monitor::sensu_server

Installs sensu, uchiwa and it's dependencies

## bb_monitor::sensu_stack_checks

Adds sensu checks to monitor the opsviz stack

# License and Maintainer

Maintainer:: YOUR_NAME (<YOUR_EMAIL>)

License:: All rights reserved
