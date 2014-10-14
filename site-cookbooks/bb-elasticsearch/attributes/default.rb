normal[:elasticsearch][:version] = '1.3.4'
normal[:elasticsearch][:download_url] = 'https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.3.4.tar.gz'
normal[:elasticsearch][:checksum] = '18af629c388b442bc8daa39754ea1f39a606acd7647fe042aed79ef014a7d330'

default[:elasticsearch][:http_auth] = false
default[:elasticsearch][:http_auth_plugin] = 'https://github.com/Asquera/elasticsearch-http-basic/releases/download/1.3.2/elasticsearch-http-basic-1.3.2.jar'

if node[:elasticsearch][:http_auth]
  normal[:elasticsearch][:custom_config] = {}
  normal[:elasticsearch][:custom_config]["http.basic.enabled"] = true
  normal[:elasticsearch][:custom_config]["http.basic.user"] = node[:elasticsearch][:basic_auth][:user]
  normal[:elasticsearch][:custom_config]["http.basic.password"] = node[:elasticsearch][:basic_auth][:password]
end

normal[:java][:install_flavor] = 'openjdk'
normal[:java][:jdk_version] = '7'