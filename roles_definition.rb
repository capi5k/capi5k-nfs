role :nfs_server do
  role_nfs_server
end

role :nfs_slave do
  role_nfs_slave
end

def host
  server =role_nfs_server
  if server.respond_to?('first')
    server.first
  else
    server
  end
end


