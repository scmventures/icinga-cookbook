include_recipe "yum::repoforge"
include_recipe "postgresql::server"
chef_gem "pg" do
  options("-- --with-pg-config=/usr/pgsql-9.2/bin/pg_config")
end
require 'pg'

package "icinga-idoutils-libdbi-pgsql" do 
  action :install
end
  
postgresql_database_user "icinga" do
  connection ({ :host => "127.0.0.1", :port => 5432, 
                :username => 'postgres', 
                :password => node['postgresql']['password']['postgres'] })
  action :create
end

postgresql_database "icinga" do
  connection ({ :host => "127.0.0.1", :port => 5432, 
                :username => 'postgres', 
                :password => node['postgresql']['password']['postgres'] })
  owner "icinga"
  encoding "UTF8"
  action :create
end

execute "createlang" do
  command "createlang plpgsql icinga || :"
  user "postgres"
end

ruby_block "load_ddl" do 
  block do
  db = ::PGconn.new( 
                     :host => "127.0.0.1", 
                     :port => 5432, 
                     :user => 'postgres', 
                     :password => node['postgresql']['password']['postgres'],
                     :dbname => 'icinga'
                     )
    if db.query("select * from pg_tables where schemaname = 'public' AND tablename = 'icinga_configfiles'").num_tuples== 0
      db.query(IO.read("/usr/share/doc/icinga-idoutils-libdbi-pgsql-1.7.2/db/pgsql/pgsql.sql").gsub('SQL', 'sql'))
    end
  end
end
