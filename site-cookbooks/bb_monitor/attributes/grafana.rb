#normal['grafana']['datasources'] = {
#  'graphite' => {
#    'type' => "'graphite'",
#    'url'  => 'window.location.protocol+"//"+window.location.hostname+":"+window.location.port+"/"',
#    'default' => true
#  },
#  'elasticsearch' => {
#    'type' => "'elasticsearch'",
#    'url'  => 'window.location.protocol+"//"+window.location.hostname+":"+window.location.port+"/elasticsearch"',
#    'index' => "'#{node['grafana']['grafana_index']}'",
#    'grafanaDB' => true
#  }
#}

# We don't want grana to install nginx for us, we'll do that
normal['grafana']['webserver'] = ''
normal['grafana']['version'] = '2.1.0-pre1'
