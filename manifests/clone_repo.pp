#XXX it would be nicer to use apache's user instead of root?

define clone_repo($repo_base_url, $local_path="/var/www/html/glider/$operatingsystem/$operatingsystemrelease/os"){
	
	$url="$repo_base_url/$operatingsystemrelease/os"

	download_file{"$architecture":
		site => "$url",
		local_path => "$local_path",
		user => "root", 
		notify => Exec["createrepo ."],
		before => File["/tftpboot/vmlinuz","/tftpboot/initrd.img"]
	}
	
	package{createrepo:
		ensure => installed
	}

	exec{"createrepo .":
		path => "/usr/bin",
		cwd => "$local_path/$architecture/$operatingsystem",
		refreshonly => true,
		timeout => "-1",
		user => "root",
		require => Package["createrepo"]
	}

}
