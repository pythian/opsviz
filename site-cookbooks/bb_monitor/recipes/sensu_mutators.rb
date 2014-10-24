%w[
  graphite.rb
].each do |mutator|
  cookbook_file "/etc/sensu/mutators/#{mutator}" do
    source "sensu_mutators/#{mutator}"
    mode 0755
  end
end

sensu_mutator "graphite" do
  command "/etc/sensu/mutators/graphite.rb -r"
  action :delete
end