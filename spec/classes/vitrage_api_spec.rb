require 'spec_helper'

describe 'vitrage::api' do

  let :pre_condition do
    "class { 'vitrage': }
     class { 'vitrage::keystone::authtoken':
       password => 'a_big_secret',
     }"
  end

  let :params do
    { :enabled           => true,
      :package_ensure    => 'latest',
      :port              => '8999',
      :host              => '0.0.0.0',
    }
  end

  shared_examples_for 'vitrage-api' do

    it { is_expected.to contain_class('vitrage::deps') }
    it { is_expected.to contain_class('vitrage::params') }
    it { is_expected.to contain_class('vitrage::policy') }

    it 'installs vitrage-api package' do
      is_expected.to contain_package('vitrage-api').with(
        :ensure => 'latest',
        :name   => platform_params[:api_package_name],
        :tag    => ['openstack', 'vitrage-package'],
      )
    end

    it 'configures api' do
      is_expected.to contain_vitrage_config('api/host').with_value( params[:host] )
      is_expected.to contain_vitrage_config('api/port').with_value( params[:port] )
      is_expected.to contain_oslo__middleware('vitrage_config').with(
        :enable_proxy_headers_parsing => '<SERVICE DEFAULT>',
        :max_request_body_size        => '<SERVICE DEFAULT>',
      )
    end

    [{:enabled => true}, {:enabled => false}].each do |param_hash|
      context "when service should be #{param_hash[:enabled] ? 'enabled' : 'disabled'}" do
        before do
          params.merge!(param_hash)
        end

        it 'configures vitrage-api service' do
          is_expected.to contain_service('vitrage-api').with(
            :ensure     => params[:enabled] ? 'running' : 'stopped',
            :name       => platform_params[:api_service_name],
            :enable     => params[:enabled],
            :hasstatus  => true,
            :hasrestart => true,
            :tag        => 'vitrage-service',
          )
        end
        it { is_expected.to contain_service('vitrage-api').that_subscribes_to('Anchor[vitrage::service::begin]')}
        it { is_expected.to contain_service('vitrage-api').that_notifies('Anchor[vitrage::service::end]')}
      end
    end

    context 'with enable_proxy_headers_parsing' do
      before do
        params.merge!({:enable_proxy_headers_parsing => true })
      end

      it { is_expected.to contain_oslo__middleware('vitrage_config').with(
        :enable_proxy_headers_parsing => true,
      )}
    end

    context 'with max_request_body_size' do
      before do
        params.merge!({:max_request_body_size => 102400 })
      end

      it { is_expected.to contain_oslo__middleware('vitrage_config').with(
        :max_request_body_size => 102400,
      )}
    end

    context 'with disabled service managing' do
      before do
        params.merge!({
          :manage_service => false,
        })
      end

      it 'does not configure vitrage-api service' do
        is_expected.to_not contain_service('vitrage-api')
      end
    end

    context 'when running vitrage-api in wsgi' do
      before do
        params.merge!({ :service_name   => 'httpd' })
      end

      let :pre_condition do
        "include apache
         class { 'vitrage': }
         class { 'vitrage::keystone::authtoken':
           password => 'a_big_secret',
         }"
      end

      it 'configures vitrage-api service with Apache' do
        is_expected.to contain_service('vitrage-api').with(
          :ensure     => 'stopped',
          :name       => platform_params[:api_service_name],
          :enable     => false,
          :tag        => 'vitrage-service',
        )
      end
    end

    context 'when service_name is not valid' do
      before do
        params.merge!({ :service_name   => 'foobar' })
      end

      let :pre_condition do
        "include apache
         class { 'vitrage': }
         class { 'vitrage::keystone::authtoken':
           password => 'a_big_secret',
         }"
      end

      it_raises 'a Puppet::Error', /Invalid service_name/
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts({
          :fqdn           => 'some.host.tld',
          :concat_basedir => '/var/lib/puppet/concat'
        }))
      end

      let(:platform_params) do
        case facts[:osfamily]
        when 'Debian'
          { :api_package_name => 'vitrage-api',
            :api_service_name => 'vitrage-api' }
        when 'RedHat'
          { :api_package_name => 'openstack-vitrage-api',
            :api_service_name => 'openstack-vitrage-api' }
        end
      end
      it_configures 'vitrage-api'
    end
  end

end
