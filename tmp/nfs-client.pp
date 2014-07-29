class {
    'nfs':
      nfshost  => "pastel-92.toulouse.grid5000.fr",
      shared   => "/tmp/exported2",
      local    => "/tmp/local_mounted2",
      options  => "rw,nfsvers=3,hard,intr,sync,noatime,nodev,nosuid,auto,rsize=32768,wsize=32768"
}
