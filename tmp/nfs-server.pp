class {
  'nfs::server':
    shared => "/tmp/exported",
    uid    => "root",
    gid    => "root"
}
