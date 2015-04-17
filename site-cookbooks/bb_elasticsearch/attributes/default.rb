normal[:elasticsearch][:version] = '1.4.4'
normal[:elasticsearch][:download_url] = 'https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-1.4.4.tar.gz'
normal[:elasticsearch][:checksum] = '963415a9114ecf0b7dd1ae43a316e339534b8f31'

default[:elasticsearch][:http_auth] = false
default[:elasticsearch][:http_auth_plugin] = 'https://github.com/Asquera/elasticsearch-http-basic/releases/download/v1.4.0/elasticsearch-http-basic-1.4.0.jar'

if node[:elasticsearch][:http_auth] == true
  normal[:elasticsearch][:custom_config] = {}
  normal[:elasticsearch][:custom_config]["http.basic.enabled"] = true
  normal[:elasticsearch][:custom_config]["http.basic.user"] = node[:elasticsearch][:basic_auth][:user]
  normal[:elasticsearch][:custom_config]["http.basic.password"] = node[:elasticsearch][:basic_auth][:password]

  # TODO we need to add all ips from our opsworks stack, or better when we move to vpc the subnet
  normal[:elasticsearch][:custom_config]["http.basic.ipwhitelist"] = ["localhost", "127.0.0.1"]
end

normal[:elasticsearch][:custom_config]["indices.fielddata.cache.size"] = "40%"

normal[:java][:install_flavor] = 'openjdk'
normal[:java][:jdk_version] = '7'
