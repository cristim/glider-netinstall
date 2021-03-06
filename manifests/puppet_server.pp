class puppet_server{
	package{"puppet-server":
		ensure => installed,
		notify => Service["puppetmaster"],
	}

	service{puppetmaster:
		ensure => running,
		enable => true,
        subscribe => File["/etc/puppet/puppet.conf"],
	}
}
