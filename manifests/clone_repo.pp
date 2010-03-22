define clone_repo($repo_base_url, $local_path="/var/www/html/glider/$operatingsystem/$operatingsystemrelease/os/$architecture/$operatingsystem"){
	get_rpms{"rpm":
		base_url => $repo_base_url,
		local_path => $local_path
	}
}

define get_rpms($base_url, $local_path){
	$url="$base_url/$operatingsystemrelease/os/$architecture/$operatingsystem"
	exec { "get-rpms":
		command => "mkdir -p \"$local_path\" ;wget -P $local_path -c $url/*.rpm && touch $local_path/all_good",
		creates => "$local_path/all_good",
		path => "/usr/bin"
	}

}
