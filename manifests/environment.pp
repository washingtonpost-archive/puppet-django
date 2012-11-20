define django::environment(
    $env_name,
    $requirements='requirements.txt',
    $upgrade=true,
    $pythonpath=[],
) {
    if $upgrade == true {
        $pip_upgrade = '-U'
    } else {
        $pip_upgrade = ''
    }
    # Create the virtualenv
    exec {"venv_init_${name}":
        command => "${django::params::init_venv_script} ${django::params::location}${env_name}",
        path => $path,
        user => "${django::params::user}",
        logoutput => true,
    }

    file {"add_to_path_${name}":
        ensure => present,
        path => "${django::params::location}${env_name}/lib/python2.7/site-packages/extra.pth",
        content => template('django/pythonpath.erb'),
        require => Exec["venv_init_${name}"],
    }

    # Install all of the python requirements
    exec {"install_${name}":
        command => "${django::params::location}${env_name}/bin/pip -v --log /tmp/pip.log install ${pip_upgrade} --use-mirrors -r ${requirements}",
        path => $path,
        logoutput => true,
        user => "${django::params::user}",
        cwd => '/tmp/',
        require => Exec["venv_init_${name}"],
    }

}
