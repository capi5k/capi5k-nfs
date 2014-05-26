class {
    'nfs':
      nfshost  => "pastel-95.toulouse.grid5000.fr",
      shared   => "/tmp/exported",
      local    => "/tmp/local_mounted",
      options  => "rw,nfsvers=3,hard,intr,async,noatime,nodev,nosuid,auto,rsize=32768,wsize=32768"
}
