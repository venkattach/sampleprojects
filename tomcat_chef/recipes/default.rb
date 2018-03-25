#
# Cookbook:: aig_tomcat_test
# Recipe:: default
#
# maintainer:: Aig Cloud Team
# maintainer_email:: aigcloudautomations@aig.com
#
# Copyright:: 2018, Aig Cloud Team, All Rights Reserved.
raise ArgumentError, "ERROR: This cookbook is not supporting #{node['platform']} Operating System." if node['platform_family'] == 'windows'


# Selecting the package name for tomcat based on OS type.
tomcat7_pckg = case node['platform_family']
            when 'centos', 'rhel'
              'tomcat7'
            when 'ubuntu', 'debian'
              'tomcat7'
            end

# Installation of Apache Package
package "tomcat7" do
  action :install
end

# Start and enable apache service
service tomcat7_pckg do
  action [:start, :enable]
end