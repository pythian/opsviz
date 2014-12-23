execute 'name' do
  command  <<-EOF
  sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 8406B0E3803709B6
  echo 'deb http://packages.flapjack.io/deb precise main' | sudo tee  /etc/apt/sources.list.d/flapjack.list
  sudo apt-get update
  EOF
  action :run
  creates '/etc/apt/sources.list.d/flapjack.list'
end

package 'flapjack' do
 action :install
end
