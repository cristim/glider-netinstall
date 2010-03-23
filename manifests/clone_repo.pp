define clone_repo($repo_base_url, $local_path="/var/www/html/glider/$operatingsystem/$operatingsystemrelease/os/$architecture/$operatingsystem"){
	get_rpms{"rpm":
		base_url => $repo_base_url,
		local_path => $local_path
	}
}

define get_rpms($base_url, $local_path){
	$url="$base_url/$operatingsystemrelease/os/$architecture/$operatingsystem"

	download_file{"*.rpm":
		site => "$url",
		local_path => "$local_path",
		user => "root", #XXX maybe we should use apache's user?
		notify => Exec["createrepo ."]
	}
	
	package{createrepo:
		ensure => installed
	}

	exec{"createrepo .":
		path => "/usr/bin",
		cwd => $local_path,
		creates => "$local_path/repodata",
		timeout => "-1",
		user => "root",
		require => Package["createrepo"]
	}

}
