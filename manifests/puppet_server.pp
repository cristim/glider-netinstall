package{"puppet-server":
	ensure => installed,
	notify => Service["puppetmaster"]
}

service{puppetmaster:
	ensure => running,
	enable => true;
}

