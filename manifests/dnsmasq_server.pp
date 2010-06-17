define dnsmasq_server (
       $config_file 	   = "/etc/dnsmasq.conf",
       $ip,
       $subnet,
       $netmask,
       $dhcp_gw,
       $dhcp_nameservers,
       $dhcp_hostsfile,
       $domain,
       $dhcp_boot,
       $tftp_ip,
       $tftp_root
	)
{
  file {  "$config_file":
  content => template("glider-netinstall/dnsmasq.conf.erb"),
  notify => Service[dnsmasq]
 }
 package { dnsmasq:
   ensure => installed,
   notify => Service[dnsmasq]
 }
 service { dnsmasq:
   ensure => running,
   hasrestart => true,
   hasstatus => true,
   subscribe => File["$config_file"]
 }
}
              
