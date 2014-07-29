def role_nfs_server
  $myxp.get_deployed_nodes('capi5k-init').first 
end

def role_nfs_slave
  $myxp.get_deployed_nodes('capi5k-init')
end

def nfs_exported
    "/tmp/exported2"
end

def nfs_local_mounted
    "/tmp/local_mounted2"
end

def uid
  "root"
end

def gid
  "root"
end


def nfs_mount_options
  "rw,nfsvers=3,hard,intr,sync,noatime,nodev,nosuid,auto,rsize=32768,wsize=32768"
end

def nfs_export_options
  "*(rw,sync,no_subtree_check)"
end

