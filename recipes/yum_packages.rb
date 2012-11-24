include_recipe "yum::repoforge"

%w{icinga icinga-gui icinga-doc}.each do |pkg|
  package pkg do 
    action :install
  end
end

