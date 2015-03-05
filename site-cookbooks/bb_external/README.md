# bb_external Cookbook

Wrapper recipes for installing logstash and sensu clients on machines that are external to the OpViz stack

## Attributes

|Key|Type|Description|Default|
|---|----|-----------|-------|
|[:bb_external][:opsworks]|Boolean|whether or not layer names should be used for sensu subscriptions and file input groups|false
|[:bb_external][:sensu][:rabbitmq][:server]|String|The public facing rabbitmq endpoint|**required**
|[:bb_external][:sensu][:rabbitmq][:password]|String|The password for rabbitmq's sensu user|**required**
|[:bb_external][:sensu][:rabbitmq][:user]|String|The rabbitmq user to use|sensu
|[:bb_external][:sensu][:subscriptions]|Array|The subscriptions the client belongs to |['all']
|[:bb_external][:sensu][:mysql][:user]|String|The mysql user to use|sensu
|[:bb_external][:sensu][:mysql][:password]|String|The mysql password to use|**required if subscriptions include 'mysql'**
|[:bb_external][:logstash][:root]|Boolean|Whether or not to run logstash as root|false
|[:bb_external][:logstash][:rabbitmq][:host]|String|The public facing rabbitmq endpoint|**required**
|[:bb_external][:logstash][:rabbitmq][:password]|String|The password for rabbitmq's logstash user|**required**
|default[:bb_external][:logstash][:rabbitmq][:user]|String|The user for rabbitmq to use | logstash_external
|default[:bb_external][:logstash][:rabbitmq][:exchange]|String|The rabbitmq exchange to use | logstash
|default[:bb_external][:logstash][:rabbitmq][:exchange_type]|String|The rabbitmq exchange type to use | direct
|[:bb_external][:logstash][:file_inputs][...]|JSON|A Key value pair of a collection of file_inputs. See below for more info| {} |
|[:bb_external][:logstash][:filters]|Array|Any array of Filter configs see logstash documentation for specifics| [] |

### Custom JSON example

```json
"bb_external": {
  "opsworks": true,
  "sensu": {
    "rabbitmq": {
      "server": "<rabbitmq endpoint>",
      "password": "<rabbitmq sensu password>"
    }
  },
  "logstash": {
    "root": true,
    "rabbitmq": {
      "host": "<rabbitmq endpoint>",
      "password": "<rabbitmq logstash password>"
    },
    "file_inputs": {
      "blog": [
        {
          "type": "apache",
          "path": "/var/log/apache2/*.log",
          "pattern": "%{COMBINEDAPACHELOG}"
        }
      ]
    },
    "filters": [
      {
        "anonymize": {
          "type": "sensitivie_log",
          "add_field": { "foo_%{somefield}": "Hello world, from %{host}" }
        }
      }
    ]
  }
}
}
```


#### File Inputs
At `[:bb_external][:logstash][:file_inputs]` is a place where multiple file inputs can be defined within groups.

The client will start listening forwarding any files that are defined within a group that matches the machines host name.
In addition if OpsWorks is in place then each client will also match any group whose name is the same as the machines layer name.

See [logstash documentation](http://logstash.net/docs/1.4.2/inputs/file) for specific configuration options

If a pattern exists, then a grok filter with a matching type will automatically be created

The example JSON will produce this agent.conf

```
input {
  file {
    'path' => '/var/log/apache2/*.log'
    'type' => 'apache'
  }
}
filter {
  grok {
    'pattern' => '%{COMBINEDAPACHELOG}'
    'type' => 'apache'
  }
}
```

## Usage

### Berksfile
The easiest way to start using this cookbook is to add it to your own Berksfile as so

```
cookbook 'bb_external', git: 'https://github.com/pythian/opsviz.git', rel: 'site-cookbooks/bb_external'
cookbook 'logstash', git: 'https://github.com/foxycoder/chef-logstash.git'
```

We currently aren't using the official logstash cookbooks so we need to add the specific logstash repo we are using.

### Installing Clients

Include `bb_external::logstash_agent` and/or `bb_external::sensu_client` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[bb_external::logstash_agent]",
    "recipe[bb_external::sensu_client]"
  ]
}
```
