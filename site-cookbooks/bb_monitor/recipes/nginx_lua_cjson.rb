%w(liblua5.1-0-dev liblua50-dev liblualib50-dev).each do |package|
  package package do
   action :install
  end
end

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

package 'cmake' do
 action :install
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

link '/usr/local/lib/lua/5.1/cjson.so' do
  to '/usr/lib/x86_64-linux-gnu/lua/5.1/cjson.so'
end
