require 'spec_helper'

describe 'vitrage::collector' do

  let :pre_condition do
    "class { '::vitrage': }"
  end

  shared_examples_for 'vitrage-collector' do

    context 'when enabled' do
      it { is_expected.to contain_class('vitrage::deps') }
      it { is_expected.to contain_class('vitrage::params') }

      it 'installs vitrage-collector package' do
        is_expected.to contain_package(platform_params[:collector_package_name]).with(
            :ensure => 'present',
            :tag    => ['openstack', 'vitrage-package']
        )
      end

      it 'configures vitrage-collector service' do
        is_expected.to contain_service('vitrage-collector').with(
            :ensure     => 'running',
            :name       => platform_params[:collector_service_name],
            :enable     => true,
            :hasstatus  => true,
            :hasrestart => true,
            :tag        => 'vitrage-service',
        )
      end

    end

    context 'when disabled' do
      let :params do
        { :enabled => false }
      end

      it { is_expected.to compile }
      it 'configures vitrage-collector service' do
        is_expected.to contain_service('vitrage-collector').with(
            :ensure     => 'stopped',
            :name       => platform_params[:collector_service_name],
            :enable     => false,
            :hasstatus  => true,
            :hasrestart => true,
            :tag        => 'vitrage-service',
        )
      end
    end

    context 'when service management is disabled' do
      let :params do
        { :enabled        => false,
          :manage_service => false }
      end

      it 'configures vitrage-collector service' do
        is_expected.to contain_service('vitrage-collector').with(
            :ensure     => nil,
            :name       => platform_params[:collector_service_name],
            :enable     => false,
            :hasstatus  => true,
            :hasrestart => true,
            :tag        => 'vitrage-service',
        )
      end
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
        case facts[:osfamily]
          when 'Debian'
            { :collector_package_name => 'vitrage-collector',
              :collector_service_name => 'vitrage-collector' }
          when 'RedHat'
            { :collector_package_name => 'openstack-vitrage-collector',
              :collector_service_name => 'openstack-vitrage-collector' }
        end
      end
      it_configures 'vitrage-collector'
    end
  end

end
