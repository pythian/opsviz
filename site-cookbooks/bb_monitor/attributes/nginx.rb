normal['nginx']['install_method'] = 'source'
normal['nginx']['source']['modules'] = %w(
  nginx::http_ssl_module
  nginx::http_gzip_static_module
  nginx::http_realip_module
)
