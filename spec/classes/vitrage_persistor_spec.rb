require 'spec_helper'

describe 'vitrage::persistor' do

  let :pre_condition do
    "class { '::vitrage': }"
  end

  shared_examples_for 'vitrage-persistor' do

    context 'when enabled' do
      it { is_expected.to contain_class('vitrage::deps') }
      it { is_expected.to contain_class('vitrage::params') }

      it 'configures vitrage.conf' do
        is_expected.to contain_vitrage_config('persistor/persist_events').with_value('true')
      end

      it 'installs vitrage-persistor package' do
        is_expected.to contain_package(platform_params[:persistor_package_name]).with(
            :ensure => 'present',
            :tag    => ['openstack', 'vitrage-package']
        )
      end

      it 'configures vitrage-persistor service' do
        is_expected.to contain_service('vitrage-persistor').with(
            :ensure     => 'running',
            :name       => platform_params[:persistor_service_name],
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
      it 'configures vitrage-persistor service' do
        is_expected.to contain_service('vitrage-persistor').with(
            :ensure     => 'stopped',
            :name       => platform_params[:persistor_service_name],
            :enable     => false,
            :hasstatus  => true,
            :hasrestart => true,
            :tag        => 'vitrage-service',
        )
      end
      it 'configures vitrage.conf' do
        is_expected.to contain_vitrage_config('persistor/persist_events').with_value('false')
      end
    end

    context 'when service management is disabled' do
      let :params do
        { :enabled        => false,
          :manage_service => false }
      end

      it 'configures vitrage-persistor service' do
        is_expected.to contain_service('vitrage-persistor').with(
            :ensure     => nil,
            :name       => platform_params[:persistor_service_name],
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
            { :persistor_package_name => 'vitrage-persistor',
              :persistor_service_name => 'vitrage-persistor' }
          when 'RedHat'
            { :persistor_package_name => 'openstack-vitrage-persistor',
              :persistor_service_name => 'openstack-vitrage-persistor' }
        end
      end
      it_configures 'vitrage-persistor'
    end
  end

end
