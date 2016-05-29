require 'spec_helper'

describe 'vitrage::client' do

  shared_examples_for 'vitrage client' do

    it { is_expected.to contain_class('vitrage::params') }

    it 'installs vitrage client package' do
      is_expected.to contain_package('python-vitrageclient').with(
        :ensure => 'present',
        :name   => 'python-vitrageclient',
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

      it_configures 'vitrage client'
    end
  end

end
