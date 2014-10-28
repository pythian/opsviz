cookbook_file "/tmp/lua-cjson-2.1.0.tar.gz" do
  source "lua-cjson-2.1.0.tar.gz"
  action :create_if_missing
end

execute 'untar lua cjson' do
  command 'tar zxf lua-cjson-2.1.0.tar.gz'
  action :run
  cwd '/tmp'
end

directory '/tmp/lua-cjson-2.1.0/build' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

execute 'make lua-cjson-2' do
  command 'cmake ..'
  action :run
  cwd '/tmp/lua-cjson-2.1.0/build'
end

execute 'install lua-cjson-2' do
  command 'make install'
  action :run
  cwd '/tmp/lua-cjson-2.1.0/build'
end
