normal['nginx']['source']['modules']  = %w(
  nginx::http_ssl_module
  nginx::http_gzip_static_module
  nginx::ngx_lua_module
)

normal['nginx']['lua']['version']  = '0.9.12'
normal['nginx']['lua']['checksum'] = 'e85c1924ca4670d5708b58efcd6e77793c43f243317a9850a112964067f63150'
