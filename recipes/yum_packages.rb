%w{icinga icinga-devel icinga-web icinga-doc php-pgsql}.each do |pkg|
  package pkg do 
    action :install
  end
end

#depends on pgdg...
package "check_postgres" 
