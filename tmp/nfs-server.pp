class {
  'nfs::server':
    shared  => "/tmp/exported2",
    uid     => "root",
    gid     => "root",
    options => "*(rw,sync,no_subtree_check)"
}
