require 'spec_helper'

describe 'vitrage::client' do

  shared_examples_for 'vitrage client' do

    it { is_expected.to contain_class('vitrage::deps') }
    it { is_expected.to contain_class('vitrage::params') }

    it 'installs vitrage client package' do
      is_expected.to contain_package('python-vitrageclient').with(
        :ensure => 'present',
        :name   => platform_params[:client_package_name],
        :tag    => 'openstack',
      )
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      let(:platform_params) do
        case facts[:os]['family']
        when 'Debian'
          { :client_package_name => 'python3-vitrageclient' }
        when 'RedHat'
          { :client_package_name => 'python3-vitrageclient' }
        end
      end

      it_configures 'vitrage client'
    end
  end

end
