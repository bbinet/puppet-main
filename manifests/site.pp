Exec {
    path => ["/bin", "/sbin", "/usr/bin", "/usr/sbin", "/usr/local/bin"],
}


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


class supervisor-nosier-conf {
    file {"/etc/supervisor/conf.d/nosier-bruno.conf":
        source => "puppet:///files/supervisor/conf.d/nosier-bruno.conf"
    }
    file {"/etc/supervisor/conf.d/nosier-clemence.conf":
        source => "puppet:///files/supervisor/conf.d/nosier-clemence.conf"
    }
    file {"/etc/supervisor/conf.d/nosier-films_perso.conf":
        source => "puppet:///files/supervisor/conf.d/nosier-films_perso.conf"
    }
    file {"/etc/supervisor/conf.d/nosier-photos.conf":
        source => "puppet:///files/supervisor/conf.d/nosier-photos.conf"
    }
    file {"/etc/supervisor/conf.d/nosier-videos.conf":
        source => "puppet:///files/supervisor/conf.d/nosier-videos.conf"
    }
    file {"/etc/supervisor/conf.d/nosier-websites.conf":
        source => "puppet:///files/supervisor/conf.d/nosier-websites.conf"
    }
}

# nodes definition

node basenode {
    include global-buildout
    include puppet-agent
}

node desktopnode inherits basenode {
    include supervisor-nosier-conf
}

node servernode inherits basenode {
}

node 'srvb.zen' inherits servernode {
    notify{"Entering srvb.zen node": }
}

node 'neo.zen' inherits desktopnode {
    notify{"Entering neo.zen node": }
}

node 'dtpb.zen' inherits desktopnode {
    notify{"Entering dtpb.zen node": }
}
