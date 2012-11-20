class django::package inherits django::params {
    # Required to install pip
    exec { "update_aptitude":
        command => "/usr/bin/apt-get update --fix-missing",
    }

    package{'python-setuptools':
        ensure => present,
        require => Exec['update_aptitude']
    }

    # Required for normal package installation and virtualenv
    package{'python-pip':
        ensure=> present,
        require => Package['python-setuptools']
    }

    # C packages for python libs
    package{$python_c_packages:
        ensure=> present,
        require => Exec['update_aptitude']
    }

    # Extra C packages
    package{$extra_c_packages:
        ensure=> present,
        require => Exec['update_aptitude']
    }

    file { $log:
        ensure => directory,
        owner => $user,
        group => $group,
        mode => 647,
    }

    # Install virtualenv/virtualenvwrapper
    exec {'virtualenv':
        command => 'pip install virtualenv virtualenvwrapper',
        path => $path,
        require => Package['python-pip'],
    }
}
