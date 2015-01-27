# Description

Installs/Configures bb-elasticsearch

# Requirements

## Platform:

*No platforms defined*

## Cookbooks:

* elasticsearch
* java

# Attributes

* `node[:elasticsearch][:http_auth]` -  Defaults to `"false"`.
* `node[:elasticsearch][:http_auth_plugin]` -  Defaults to `"https://github.com/Asquera/elasticsearch-http-basic/releases/download/v1.3.0-security-fix/elasticsearch-http-basic-1.3.0.jar"`.

# Recipes

* [bb_elasticsearch::default](#bb_elasticsearchdefault)
* [bb_elasticsearch::restart](#bb_elasticsearchrestart)

## bb_elasticsearch::default

Installs elasticsearch with the http-basic authentication plugin

## bb_elasticsearch::restart

Restarts elasticsearch

# License and Maintainer

Maintainer:: YOUR_NAME (<YOUR_EMAIL>)

License:: All rights reserved
