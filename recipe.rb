set :nfs_path, "#{recipes_path}/capi5k-nfs"

load "#{nfs_path}/roles.rb"
load "#{nfs_path}/roles_definition.rb"
load "#{nfs_path}/output.rb"

namespace :nfs do

  desc 'Deploy NFS on nodes'
  task :default do
    modules::install
    server
    client
  end

  desc 'Configure NFS server'
  task :server do
    template_server
    transfer_server
    apply_server
  end

  desc 'Configure NFS clients'
  task :client do
    template_client
    transfer_client
    apply_client
  end


  namespace :modules do
    task :install, :roles => [:nfs_server, :nfs_slave] do
      set :user, "root"   
      run "mkdir -p /etc/puppet/modules"
      upload("#{nfs_path}/module","/etc/puppet/modules/nfs", :via => :scp, :recursive => true)
      run "http_proxy='http://proxy:3128' https_proxy='http://proxy:3128' puppet module install --force puppetlabs/stdlib"
   end

    task :uninstall, :roles => [:nfs_server, :nfs_slave] do
      set :user, "root"
      run "http_proxy='http://proxy:3128' https_proxy='http://proxy:3128' puppet module uninstall --force puppetlabs/stdlib"
      run "rm -rf /etc/puppet/modules/nfs"
   end
  end

  task :template_server do
    template = File.read("#{nfs_path}/templates/nfs-server.erb")
    renderer = ERB.new(template)
    @shared = "#{nfs_exported}" 
    @uid = "#{uid}"
    @gid = "#{gid}"
    @options = "#{nfs_export_options}"
    generate = renderer.result(binding)
    myFile = File.open("#{nfs_path}/tmp/nfs-server.pp", "w")
    myFile.write(generate)
    myFile.close
  end

  task :transfer_server, :roles => [:nfs_server] do
    set :user, "#{g5k_user}"
    upload("#{nfs_path}/tmp/nfs-server.pp","/tmp/nfs-server.pp", :via => :scp)
  end

  task :apply_server, :roles => [:nfs_server] do
    set :user, "root"
    run "http_proxy='http://proxy:3128' https_proxy='http://proxy:3128' puppet apply /tmp/nfs-server.pp  -d "
  end


  task :template_client do
    template = File.read("#{nfs_path}/templates/nfs-client.erb")
    renderer = ERB.new(template)
    @nfshost = "#{host}"
    @shared = "#{nfs_exported}"
    @local  = "#{nfs_local_mounted}"
    @options = "#{nfs_mount_options}"

    generate = renderer.result(binding)
    myFile = File.open("#{nfs_path}/tmp/nfs-client.pp", "w")
    myFile.write(generate)
    myFile.close
  end

  task :transfer_client, :roles => [:nfs_slave] do
    set :user, "root"
    upload("#{nfs_path}/tmp/nfs-client.pp","/tmp/nfs-client.pp")
  end

  task :apply_client, :roles => [:nfs_slave] do
    set :user, "root"
    run "puppet apply /tmp/nfs-client.pp"
  end

end
