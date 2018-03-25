# #
# Profile:: opt_tomcat7
# Test:: opt_tomcat7
#
# maintainer:: opt
# maintainer_email:: opt@chef.com
#
# Copyright:: 2017, Aig Cloud Team, All Rights Reserved.

title 'opt_tomcat7 for Rhel, centos & Ubuntu'

if os.rhel?
  control 'Install package tomcat7' do
    impact 1.0
    title 'atomcat7 install'
    desc 'ensure tomcat7 package has been installed'
    describe package('tomcat7') do
      it { should be_installed }
    end
  end
  control 'tomcat7 service' do
    impact 0.3
    title 'tomcat7 should be configured and running'
    describe service(tomcat7.service) do
      it { should be_enabled }
      it { should be_running }
    end
  end
end

if os.ubuntu?
  control 'Install package tomcat7' do
    impact 1.0
    title 'tomcat7 install'
    desc 'ensure tomcat7 package has been installed'
    describe package('apache2') do
      it { should be_installed }
    end
  end
  control 'tomcat7 service' do
    impact 0.3
    title 'atomcat7 should be configured and running'
    describe service(tomcat7.service) do
      it { should be_enabled }
      it { should be_running }
    end
  end
end

