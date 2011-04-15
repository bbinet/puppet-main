Exec {
    path => ["/bin", "/sbin", "/usr/bin", "/usr/sbin", "/usr/local/bin"],
}


# nodes definition

node basenode {
}

node 'srvb.zen' inherits basenode {
    notify{"Entering srvb.zen node": }
}

node 'dtpb.zen' inherits basenode {
    notify{"Entering dtpb.zen node": }
}
