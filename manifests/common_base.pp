
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
                $cwd="", 
                $creates="",
                $require="",
                $user="") {

        exec { $name:
                path => "/usr/bin",
                command => "wget ${site}/${name}",
                cwd => $cwd,
                creates => "${cwd}/${name}",
                require => $require,
                user => $user,
        }



}

