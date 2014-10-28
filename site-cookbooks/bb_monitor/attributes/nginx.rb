default['nginx']['source']['modules']  = %w(
  nginx::http_ssl_module
  nginx::http_gzip_static_module
  nginx::ngx_lua_module
)
