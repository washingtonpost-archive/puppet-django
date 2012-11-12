define django::environment(
    $env_name,
    $requirements='requirements.txt',
    $upgrade=true,
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