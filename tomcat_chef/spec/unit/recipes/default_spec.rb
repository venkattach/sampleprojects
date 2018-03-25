#
# Cookbook:: aig_apache
# Spec:: default_spec
#
# maintainer:: Aig Cloud Team
# maintainer_email:: aigcloudautomations@aig.com
#
# Copyright:: 2018, Aig Cloud Team, All Rights Reserved.
require 'spec_helper'

describe 'aig_tomcat_test::default' do
  context 'Validate supported installations' do
    platforms = {
      'redhat' => {
        'versions' => %w(6.8 7.3)
      },
      'centos' => {
        'versions' => %w(6.8 7.3.1611)
      },
      'ubuntu' => {
        'versions' => %w(14.04 16.04)
      }
    }
    platforms.each do |platform, components|
      components['versions'].each do |version|
        context "On #{platform} #{version}" do
          context 'When all attributes are default' do
            before do
              Fauxhai.mock(platform: platform, version: version)
            end
            let(:runner) do
              ChefSpec::SoloRunner.new(platform: platform, version: version, file_cache_path: '/tmp/cache')
            end
            let(:node) { runner.node }
            let(:chef_run) { runner.converge(described_recipe) }

            it 'converges successfully' do
              expect { chef_run }.to_not raise_error
              case node['platform_family']
              when 'centos'
                expect(chef_run).to install_package('tomcat7')
                expect(chef_run).to start_service('tomcat7')
                expect(chef_run).to enable_service('tomcat7')
              when 'ubuntu'
                expect(chef_run).to install_package('tomcat7')
                expect(chef_run).to start_service('tomcat7')
                expect(chef_run).to enable_service('tomcat7')
              end
            end
          end
        end
      end
    end
  end
  context 'Validate unsupported platforms' do
    platforms = {
      'windows' => {
        'versions' => %w(2012 2012r2)
      }
    }
    platforms.each do |platform, components|
      components['versions'].each do |version|
        context "On #{platform} #{version}" do
          context 'When all attributes are default' do
            before do
              Fauxhai.mock(platform: platform, version: version)
            end
            let(:chef_run) do
              ChefSpec::SoloRunner.new(platform: platform, version: version) do |node|
                # Node attributes
              end.converge(described_recipe)
            end

            it 'raises an Error' do
              expect { chef_run }.to raise_error(ArgumentError, "ERROR: This cookbook is not supporting #{platform} Operating System.")
            end
          end
        end
      end
    end
  end
end
