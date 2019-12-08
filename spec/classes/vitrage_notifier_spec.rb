require 'spec_helper'

describe 'vitrage::notifier' do

  let :pre_condition do
    "class { 'vitrage': }"
  end

  shared_examples_for 'vitrage-notifier' do

    context 'when enabled' do
      it { is_expected.to contain_class('vitrage::deps') }
      it { is_expected.to contain_class('vitrage::params') }

      it 'installs vitrage-notifier package' do
        is_expected.to contain_package(platform_params[:notifier_package_name]).with(
            :ensure => 'present',
            :tag    => ['openstack', 'vitrage-package']
        )
      end

      it 'configure notifier default params' do
        is_expected.to contain_vitrage_config('DEFAULT/notifiers').with_value('<SERVICE DEFAULT>')
      end

      it 'configures vitrage-notifier service' do
        is_expected.to contain_service('vitrage-notifier').with(
            :ensure     => 'running',
            :name       => platform_params[:notifier_service_name],
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
      it 'configures vitrage-notifier service' do
        is_expected.to contain_service('vitrage-notifier').with(
            :ensure     => 'stopped',
            :name       => platform_params[:notifier_service_name],
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

      it 'configures vitrage-notifier service' do
        is_expected.to contain_service('vitrage-notifier').with(
            :ensure     => nil,
            :name       => platform_params[:notifier_service_name],
            :enable     => false,
            :hasstatus  => true,
            :hasrestart => true,
            :tag        => 'vitrage-service',
        )
      end
    end

    context 'when configuring notifiers' do
      let :params do
        { :notifiers => ['mistral', 'nova'] }
      end

      it { is_expected.to compile }
      it 'configure notifier params' do
        is_expected.to contain_vitrage_config('DEFAULT/notifiers').with_value('mistral,nova')
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
            { :notifier_package_name => 'vitrage-notifier',
              :notifier_service_name => 'vitrage-notifier' }
          when 'RedHat'
            { :notifier_package_name => 'openstack-vitrage-notifier',
              :notifier_service_name => 'openstack-vitrage-notifier' }
        end
      end
      it_configures 'vitrage-notifier'
    end
  end

end
