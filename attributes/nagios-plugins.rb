if node[:platform_family] == 'rhel' && node[:kernel][:machine] == 'x86_64'
  default['icinga']['plugin_dir'] = "/usr/lib64/nagios/plugins"
else
  default['icinga']['plugin_dir'] = "/usr/lib/nagios/plugins"
end
