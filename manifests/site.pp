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
        hour => 15,
        minute => fqdn_rand(59),
    }
}

class unison-conf {
    file {"/root/.unison/bruno.prf":
        source => "puppet:///files/unison/bruno.prf"
    }
    file {"/root/.unison/clemence.prf":
        source => "puppet:///files/unison/clemence.prf"
    }
    file {"/root/.unison/films_perso.prf":
        source => "puppet:///files/unison/films_perso.prf"
    }
    file {"/root/.unison/photos.prf":
        source => "puppet:///files/unison/photos.prf"
    }
    file {"/root/.unison/videos.prf":
        source => "puppet:///files/unison/videos.prf"
    }
    file {"/root/.unison/websites.prf":
        source => "puppet:///files/unison/websites.prf"
    }
    file {"/root/.unison/common":
        source => "puppet:///files/unison/common"
    }
}


class supervisor-nosier-conf {
    file {"/etc/supervisor/conf.d/nosier-bruno.conf":
        source => "puppet:///files/supervisor/conf.d/nosier-bruno.conf",
        ensure => absent,
    }
    file {"/etc/supervisor/conf.d/nosier-clemence.conf":
        source => "puppet:///files/supervisor/conf.d/nosier-clemence.conf",
        ensure => absent,
    }
    file {"/etc/supervisor/conf.d/nosier-films_perso.conf":
        source => "puppet:///files/supervisor/conf.d/nosier-films_perso.conf",
        ensure => absent,
    }
    file {"/etc/supervisor/conf.d/nosier-photos.conf":
        source => "puppet:///files/supervisor/conf.d/nosier-photos.conf",
        ensure => absent,
    }
    file {"/etc/supervisor/conf.d/nosier-videos.conf":
        source => "puppet:///files/supervisor/conf.d/nosier-videos.conf",
        ensure => absent,
    }
    file {"/etc/supervisor/conf.d/nosier-websites.conf":
        source => "puppet:///files/supervisor/conf.d/nosier-websites.conf",
        ensure => absent,
    }
}


class unison-cron {
    file {"/usr/local/bin/unison-cron.sh":
        source => "puppet:///files/unison/bin/unison-cron.sh",
        mode => 755,
    }

    $first_minute = fqdn_rand(29)
    $second_minute = fqdn_rand(29) + 30

    cron {"unison-bruno":
        command => "/usr/local/bin/unison-cron.sh bruno 2>&1 >>/dev/null",
        user => root,
        minute => $first_minute,
    }
    cron {"unison-clemence":
        command => "/usr/local/bin/unison-cron.sh clemence 2>&1 >>/dev/null",
        user => root,
        minute => $second_minute,
    }
    cron {"unison-films_perso":
        command => "/usr/local/bin/unison-cron.sh films_perso 2>&1 >>/dev/null",
        user => root,
        hour => 12,
        minute => fqdn_rand(59)
    }
    cron {"unison-photos":
        command => "/usr/local/bin/unison-cron.sh photos 2>&1 >>/dev/null",
        user => root,
        hour => 11,
        minute => fqdn_rand(59)
    }
    cron {"unison-videos":
        command => "/usr/local/bin/unison-cron.sh videos 2>&1 >>/dev/null",
        user => root,
        hour => 10,
        minute => fqdn_rand(59)
    }
    cron {"unison-websites":
        command => "/usr/local/bin/unison-cron.sh websites 2>&1 >>/dev/null",
        user => root,
        minute => fqdn_rand(59),
        hour => 9,
    }
}

# nodes definition

node basenode {
    include global-buildout
    include puppet-agent
}

node desktopnode inherits basenode {
    include unison-conf
    include supervisor-nosier-conf
    include unison-cron
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
