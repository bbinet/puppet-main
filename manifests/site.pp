Exec {
    path => ["/bin", "/sbin", "/usr/bin", "/usr/sbin", "/usr/local/bin"],
}


include buildout
class global-buildout {
    buildout::venv { "/usr/local/buildout-main":
        source => "puppet:///files/zc.buildout/buildout-main.cfg"
    }
}

class puppet-agent {
    cron { "puppet":
        command => "/usr/sbin/puppetd --test --logdest syslog 2>&1 >>/dev/null",
        user => root,
        minute => fqdn_rand(59)
    }
}


# nodes definition

node basenode {
    include global-buildout
    include puppet-agent
}

node 'srvb.zen' inherits basenode {
    notify{"Entering srvb.zen node": }
}

node 'neo.zen' inherits basenode {
    notify{"Entering neo.zen node": }
}

node 'dtpb.zen' inherits basenode {
    notify{"Entering dtpb.zen node": }
}
