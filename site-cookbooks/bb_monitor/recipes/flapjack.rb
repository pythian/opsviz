=begin
#<
Installs and configures flapjack
#>
=end

execute 'name' do
  command  <<-EOF
  echo "deb http://packages.flapjack.io/deb/v1 trusty main" | sudo tee /etc/apt/sources.list.d/flapjack.list
  gpg --keyserver keys.gnupg.net --recv-keys 803709B6
  gpg -a --export 803709B6 | sudo apt-key add -
  sudo apt-get update
  EOF
  action :run
  creates '/etc/apt/sources.list.d/flapjack.list'
end

package 'flapjack' do
 action :install
end

template '/etc/flapjack/flapjack_config.yaml' do
  source 'flapjack_config.yaml.erb'
  owner 'root'
  group 'root'
  mode '0744'
end
