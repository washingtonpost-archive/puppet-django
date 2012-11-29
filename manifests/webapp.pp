# Master Puppet manifest a django box running on Ubuntu Precise (12.04)


# Usage:

# Call the webapp method and pass the correct parameters in order for it to install

# django::webapp {'VIRTUAL_ENV_NAME':
#     requirements => 'LOCATION_OF_REQUIREMENTS_FILE (INSIDE REPO)',
#     source => 'GIT_REPO',
#     code_path => 'WHERE_CODE_LIVES',
# }



define django::webapp(
    $source,
    $requirements,
    $repo_name,
    $settings_module,
    $location,
    $vhost=undef,
    $pythonpath=[],
    $upgrade=false,
    $code_path="${django::params::location}",
) {
    # include the necessary libs
    include nginx, uwsgi, git

    # Build a uwsgi instance
    # All of the requirements here are needed for Django
    # An additional param, pythonpath, should probably be added.
    uwsgi::instance::basic {$name:
        params => {
            'chdir' => "\"${code_path}${repo_name}/\"",
            'home' => "\"${code_path}${name}\"",
            'env' => "\"DJANGO_SETTINGS_MODULE=${settings_module}\"",
            'module' => '"django.core.handlers.wsgi:WSGIHandler()"'
        }
    }

    # Create an nginx instance
    nginx::resource::location { $name:
        vhost => $vhost,
        proxy => "unix:/tmp/uwsgi.${name}.sock",
        uwsgi => true,
        location => "${location}/",
        uwsgi_params => ["SCRIPT_NAME ${location}"],
    }

    # Clone the code repo
    git::commands::clone { $name:
        repo_name => $repo_name,
        source => $source,
        path => $code_path,
        user => "${django::params::user}"
    }

    # Initialize the environment and install requirements
    django::environment { $name:
        env_name => $name,
        upgrade => $upgrade,
        requirements => "${code_path}${repo_name}/${requirements}",
        pythonpath => $pythonpath,
        # Include uwsgi (in order to notify the service that the requirements have finished installing)
        notify => Class['uwsgi::service'],

    }
}