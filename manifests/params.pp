class django::params {
    $init_venv_script='/usr/local/bin/virtualenv'
    $init_venv_script_path='/usr/local/bin/'
    $path=["/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin/"]
    $location="/opt/python/"
    $log='/var/log/django/'
    $user="ubuntu"
    $group="ubuntu"
    $python_c_packages=['python-dev', 'libxml2-dev', 'libxslt-dev', 'postgresql', 'postgresql-server-dev-9.1']
    $extra_c_packages=[]
}
