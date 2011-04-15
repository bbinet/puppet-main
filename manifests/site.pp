Exec {
    path => ["/bin", "/sbin", "/usr/bin", "/usr/sbin", "/usr/local/bin"],
}

define buildout($buildoutcfg, $ensure=present) {
    if $ensure == present {
        exec { "mkdir -p $name":
            unless => "test -d $name",
        }
        file { "$name/bootstrap.py":
            source => "puppet:///files/zc.buildout/bootstrap.py",
            require => Exec["mkdir -p $name"],
        }
        file { "$name/buildout.cfg":
            source => $buildoutcfg,
            require => Exec["mkdir -p $name"],
        }
        exec { "python bootstrap.py":
            cwd => $name,
            require => [File["$name/bootstrap.py"], File["$name/buildout.cfg"]],
            unless => "test -f $name/bin/buildout",
        }
        exec { "$name/bin/buildout":
            cwd => $name,
            require => Exec["python bootstrap.py"],
            subscribe => File["$name/buildout.cfg"],
            refreshonly => true,
        }
	} else {
		file { "$name":
			ensure => absent,
		}
	}
}


class global-buildout {
    buildout { "/usr/local/buildout-main":
        buildoutcfg => "puppet:///files/zc.buildout/buildout-main.cfg"
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

node 'dtpb.zen' inherits basenode {
    notify{"Entering dtpb.zen node": }
}
