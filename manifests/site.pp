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


# nodes definition

node basenode {
}

node 'srvb.zen' inherits basenode {
    notify{"Entering srvb.zen node": }
}

node 'dtpb.zen' inherits basenode {
    notify{"Entering dtpb.zen node": }
}
