
class common_base{
#XXX: Most of this stuff is already done in kickstart, maybe we should skip it here

	package {["ntp", "puppet", "openssh-server"]:
		ensure => installed
	}
	service {["ntpd", "puppet", "sshd"]:
		ensure => running,
		enable => true
	}
	package { "epel-release":
		provider => "rpm",
		source => "http://download.fedora.redhat.com/pub/epel/5/i386/epel-release-5-3.noarch.rpm",
		ensure => installed;
	}
}
define download_file(
		$site="",
		$local_path="", 
		$user="") {

	exec { "mkdir_for_$name":
		command => "mkdir -p $local_path",
		path => "/bin",
		creates => "$local_path",
		user => $user,
		notify => Exec[$name]
	}
	exec { $name:
		path => "/usr/bin",
		command => "rsync -a ${site}/${name} .",
		cwd => $local_path,
		refreshonly => true,
		timeout => "-1",
		user => $user
	}

}

