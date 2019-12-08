require 'spec_helper'

describe 'vitrage::graph' do

  let :pre_condition do
    "class { 'vitrage': }"
  end

  shared_examples_for 'vitrage-graph' do

    context 'when enabled' do
      it { is_expected.to contain_class('vitrage::deps') }
      it { is_expected.to contain_class('vitrage::params') }

      it 'installs vitrage-graph package' do
        is_expected.to contain_package(platform_params[:graph_package_name]).with(
          :ensure => 'present',
          :tag    => ['openstack', 'vitrage-package']
        )
      end

      it 'configures vitrage-graph service' do
        is_expected.to contain_service('vitrage-graph').with(
          :ensure     => 'running',
          :name       => platform_params[:graph_service_name],
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
      it 'configures vitrage-graph service' do
        is_expected.to contain_service('vitrage-graph').with(
          :ensure     => 'stopped',
          :name       => platform_params[:graph_service_name],
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

      it 'configures vitrage-graph service' do
        is_expected.to contain_service('vitrage-graph').with(
          :ensure     => nil,
          :name       => platform_params[:graph_service_name],
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
          { :graph_package_name => 'vitrage-graph',
            :graph_service_name => 'vitrage-graph' }
        when 'RedHat'
          { :graph_package_name => 'openstack-vitrage-graph',
            :graph_service_name => 'openstack-vitrage-graph' }
        end
      end
      it_configures 'vitrage-graph'
    end
  end

end
