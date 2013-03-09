include_recipe "postgresql::server"
chef_gem "pg" do
  options("-- --with-pg-config=/usr/pgsql-9.2/bin/pg_config")
end

package "icinga-idoutils-libdbi-pgsql" do 
  action :install
end

%w{icinga icinga_web}.each do |user| 
postgresql_database_user user do
    connection ({ :host => "127.0.0.1", :port => 5432, 
                  :username => 'postgres', 
                  :password => node['postgresql']['password']['postgres'] })
    action :create
  end
end

postgresql_database node[:icinga][:ido2db][:dbname] do
  connection ({ :host => "127.0.0.1", :port => 5432, 
                :username => 'postgres', 
                :password => node['postgresql']['password']['postgres'] })
  owner "icinga"
  encoding "UTF8"
  action :create
end

postgresql_database node[:icinga][:web_db][:dbname] do
  connection ({ :host => "127.0.0.1", :port => 5432, 
                :username => 'postgres', 
                :password => node['postgresql']['password']['postgres'] })
  owner "icinga_web"
  encoding "UTF8"
  action :create
end

execute "createlang" do
  command "createlang plpgsql icinga || :"
  user "postgres"
end

ruby_block "load_icinga_ddl" do 
  block do
    require 'pg'
  db = ::PGconn.new( 
                     :host => "127.0.0.1", 
                     :port => 5432, 
                     :user => 'postgres', 
                     :password => node['postgresql']['password']['postgres'],
                     :dbname => node[:icinga][:ido2db][:dbname]
                     )
    if db.query("select * from pg_tables where schemaname = 'public' AND tablename = 'icinga_configfiles'").num_tuples== 0
      db.query(IO.read("/usr/share/doc/icinga-idoutils-libdbi-pgsql-1.8.4/db/pgsql/pgsql.sql").gsub('SQL', 'sql'))
    end
  end
end
ruby_block "load_icinga_web_ddl" do 
  block do
    require 'pg'
  db = ::PGconn.new( 
                     :host => "127.0.0.1", 
                     :port => 5432, 
                     :user => 'postgres', 
                     :password => node['postgresql']['password']['postgres'],
                     :dbname => node[:icinga][:web_db][:dbname]
                     )
    if db.query("select * from pg_tables where schemaname = 'public' AND tablename = 'cronk'").num_tuples== 0
# db.query doesn't work since this script uses psql batch variables.
      %x{psql --username=postgres #{node[:icinga][:web_db][:dbname]} < /usr/share/icinga-web/etc/schema/pgsql.sql}
    end
  end
end

ruby_block "grant_permissions" do
  block do
    require 'pg'
    db = ::PGconn.new( 
                      :host => "127.0.0.1", 
                      :port => 5432, 
                      :user => 'postgres', 
                      :password => node['postgresql']['password']['postgres'],
                      :dbname => 'icinga'
                      )
    %w{icinga icinga_web}.each do |user|
      db.query "grant all on all tables in schema public to #{user}"
      db.query "grant all on all sequences in schema public to #{user}"
    end
  end
end
ruby_block "grant_permissions_web" do
  block do
    require 'pg'
    db = ::PGconn.new( 
                      :host => "127.0.0.1", 
                      :port => 5432, 
                      :user => 'postgres', 
                      :password => node['postgresql']['password']['postgres'],
                      :dbname =>  node[:icinga][:web_db][:dbname]
                      )
    
    db.query "grant all on all tables in schema public to #{node[:icinga][:web_db][:user]}"
    db.query "grant all on all sequences in schema public to #{node[:icinga][:web_db][:user]}"
  end
end

template "#{node[:icinga][:conf_dir]}/ido2db.cfg" do
  source "ido2db.cfg.erb"
  mode "0644"
  owner "root"
  group "root"
  notifies :restart, "service[ido2db]"

end

service "ido2db" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end
