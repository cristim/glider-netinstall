# Manages a TFTP server for PXE boot

include common_base

define tftp_server($disable = "no",
		$pxe_kernel_location,
		$kickstart_url,
		root_password_hash){

	$kickstart_file=regsubst($kickstart_url, "^.*/", "/var/www/html/glider/")

	package{["tftp-server", "syslinux", "xinetd", "httpd"]:
		ensure=> installed
	}

	service { ["xinetd", "httpd"]:
		ensure=> running,
		require => Package["xinetd", "httpd"]
	}


	download_file{["vmlinuz","initrd.img"]:
		site => $pxe_kernel_location,
		local_path => "/tftpboot",
		user => "root",
	}

	file{["/tftpboot","/tftpboot/pxelinux.cfg"]:
		ensure => directory;
	}

	file{"/tftpboot/pxelinux.cfg/default":
		content => template("glider-netinstall/pxe.erb")
	}

	file{"/tftpboot/pxelinux.0":
		source => "/usr/lib/syslinux/pxelinux.0",
		       require => Package["syslinux"]
	}

	file{"/etc/xinetd.d/tftp":
		content => template("glider-netinstall/xinetd_tftp.erb"),
			notify => Service["xinetd"]
	}
	file{"$kickstart_file":
		content => template("glider-netinstall/kickstart.erb"),
		require => Package["httpd"]
	}

}

