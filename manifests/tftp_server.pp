# Manages a TFTP server for PXE boot


define tftp_server($disable = "no",
		$pxe_kernel_location,
		$kickstart_url,
		root_password_hash){

include glider_common

	$kickstart_file=regsubst($kickstart_url, "^.*/", "/var/www/html/glider/")

	$pxe_imgs = "/var/www/html/glider/$operatingsystem/$operatingsystemrelease/os/$architecture/images/pxeboot"

	package{["tftp-server", "syslinux", "xinetd", "httpd"]:
		ensure=> installed
	}

	service { ["xinetd", "httpd"]:
		ensure=> running,
		require => Package["xinetd", "httpd"]
	}


	file{"/tftpboot/vmlinuz":
		source => "$pxe_imgs/vmlinuz"
	}

	file{"/tftpboot/initrd.img":
		source => "$pxe_imgs/initrd.img"
	}

	file{["/tftpboot","/tftpboot/pxelinux.cfg","/var/www/html/glider"]:
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
		require => [Package["httpd"], File["/var/www/html/glider"]],
	}
}

