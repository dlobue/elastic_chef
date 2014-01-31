
package "build-essential" do
  action :nothing
end.run_action(:install)

chef_gem "activerecord" do
  action :install
end

chef_gem "tire" do
  action :install
end

chef_gem "tire-contrib" do
  action :install
end

