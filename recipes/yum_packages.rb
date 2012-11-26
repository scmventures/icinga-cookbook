include_recipe "yum::repoforge"

%w{icinga icinga-web icinga-doc php-pgsql}.each do |pkg|
  package pkg do 
    action :install
  end
end

#depends on pgdg...
package "check_postgres" 
