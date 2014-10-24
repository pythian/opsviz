%w[
  graphite.rb
].each do |extension|
  cookbook_file ::File.join(node.sensu.directory, "extensions", extension) do
    source "sensu_extensions/#{extension}"
    mode 0755
    notifies :restart, "sensu_service[sensu-server]"
  end
end

sensu_snippet "graphite" do
  content({:reverse => true, :replace => "."})
end