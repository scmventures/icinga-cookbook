package "icinga-web-module-pnp" do
  action :install
end

template "/etc/pnp4nagios/npcd.cfg" do
  source "npcd.cfg.erb"
  mode "0644"
  notifies :restart, "service[npcd]"
end
template "/etc/pnp4nagios/config.php" do
  source "config.php.erb"
  mode "0644"
  notifies :restart, "service[npcd]"
end

template "/etc/pnp4nagios/process_perfdata.cfg" do
  source "process_perfdata.cfg.erb"
  mode "0640"
  owner "root"
  group "icinga"
  notifies :restart, "service[npcd]"
end

directory "/var/lib/pnp4nagios" do
  owner node[:icinga][:user]
  group node[:icinga][:group]
  mode "0755"
end

service "npcd" do
  action [:enable, :start]
  supports :status => true, :restart => true, :reload => true
end
