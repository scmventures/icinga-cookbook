default['icinga']['version'] = "1.4.2"
default['icinga']['checksum'] = "506022493295bda95aa2514bfdc3196063ed936655bc60068f61543504b42aa6"
default['icinga']['prefix'] = "/usr/local/icinga"

default['icinga']['sysadmin_email'] = "root@localhost"
default['icinga']['sysadmin_sms_email'] = "root@localhost"

default['icinga']['user'] = "icinga"
default['icinga']['group'] = "icinga"

default['icinga']['server_role'] = "monitoring"
default['icinga']['notifications_enabled']   = 0
default['icinga']['check_external_commands'] = true
default['icinga']['default_contact_groups']  = %w(admins)
default['icinga']['sysadmin'] = "icinga"

default['icinga']['conf_dir'] = "/etc/icinga"
default['icinga']['config_dir'] = node['icinga']['conf_dir'] + "/conf.d"
default['icinga']['log_dir'] = "/var/log/icinga"
default['icinga']['cache_dir'] = "/var/spool/icinga"
default['icinga']['state_dir'] = "/var/spool/icinga"
default['icinga']['run_dir'] = node['icinga']['log_dir']
default['icinga']['docroot'] = "/usr/share/icinga"

default['icinga']['ido2db']['servertype'] = 'pgsql'
default['icinga']['ido2db']['host'] = 'localhost'
default['icinga']['ido2db']['port'] = '5432'
default['icinga']['ido2db']['dbname'] = 'icinga'
default['icinga']['ido2db']['prefix'] = 'icinga_'
default['icinga']['ido2db']['user'] = 'icinga'
default['icinga']['ido2db']['password'] = 'icinga'

default['icinga']['web_db']['servertype'] = 'pgsql'
default['icinga']['web_db']['host'] = 'localhost'
default['icinga']['web_db']['user'] = 'icinga_web'
default['icinga']['web_db']['dbname'] = 'icinga_web'

default['icinga_web']['ido_dbuser'] = 'icinga_web'
default['icinga_web']['conf_dir'] = "/etc/icinga-web"
default['icinga_web']['config_dir'] = node['icinga_web']['conf_dir'] + "/conf.d"

# This setting is effectively sets the minimum interval (in seconds) icinga can handle.
# Other interval settings provided in seconds will calculate their actual from this value, since icinga works in 'time units' rather than allowing definitions everywhere in seconds

default['icinga']['templates'] = Mash.new
default['icinga']['interval_length'] = 1

# Provide all interval values in seconds
default['icinga']['default_host']['check_interval']     = 15
default['icinga']['default_host']['retry_interval']     = 15
default['icinga']['default_host']['max_check_attempts'] = 1
default['icinga']['default_host']['notification_interval'] = 300

default['icinga']['default_service']['check_interval']     = 60
default['icinga']['default_service']['retry_interval']     = 15
default['icinga']['default_service']['max_check_attempts'] = 3
default['icinga']['default_service']['notification_interval'] = 1200
