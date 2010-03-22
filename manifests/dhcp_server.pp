# Manages a DHCP server for PXE boot 

# The nodes must be previously defined in $static_nodes_file.

define dhcp_server($config_file="/etc/dhcpd.conf",
		$main_options=["ddns-update-style none", "use-host-decl-names on"],
		$ip,
		$subnet, 
		$netmask, 
		$gw, 
		$dns, 
		$tftp, 
		$static_nodes_file){
		
	package {dhcp:
		ensure => installed,
		notify => Service[dhcpd]
	}
	service{dhcpd:
		ensure => running,
		subscribe => File["$config_file"]
	}
	file {$config_file:
		content => template("glider-netinstall/dhcpd.conf.erb"),
		notify  => Service[dhcpd]
	}
}
