require 'spec_helper'

describe 'vitrage::api' do

  let :pre_condition do
    "class { 'vitrage': }"
  end

  let :params do
    { :enabled           => true,
      :manage_service    => true,
      :keystone_password => 'vitrage-passw0rd',
      :keystone_tenant   => 'services',
      :keystone_user     => 'vitrage',
      :package_ensure    => 'latest',
      :port              => '8999',
      :host              => '0.0.0.0',
    }
  end

  shared_examples_for 'vitrage-api' do

    context 'without required parameter keystone_password' do
      before { params.delete(:keystone_password) }
      it { expect { is_expected.to raise_error(Puppet::Error) } }
    end

    it { is_expected.to contain_class('vitrage::params') }
    it { is_expected.to contain_class('vitrage::policy') }

    it 'installs vitrage-api package' do
      is_expected.to contain_package('vitrage-api').with(
        :ensure => 'latest',
        :name   => platform_params[:api_package_name],
        :tag    => ['openstack', 'vitrage-package'],
      )
    end

    it 'configures keystone authentication middleware' do
      is_expected.to contain_vitrage_config('keystone_authtoken/admin_tenant_name').with_value( params[:keystone_tenant] )
      is_expected.to contain_vitrage_config('keystone_authtoken/admin_user').with_value( params[:keystone_user] )
      is_expected.to contain_vitrage_config('keystone_authtoken/admin_password').with_value( params[:keystone_password] )
      is_expected.to contain_vitrage_config('keystone_authtoken/admin_password').with_value( params[:keystone_password] ).with_secret(true)
      is_expected.to contain_vitrage_config('api/host').with_value( params[:host] )
      is_expected.to contain_vitrage_config('api/port').with_value( params[:port] )
    end

    [{:enabled => true}, {:enabled => false}].each do |param_hash|
      context "when service should be #{param_hash[:enabled] ? 'enabled' : 'disabled'}" do
        before do
          params.merge!(param_hash)
        end

        it 'configures vitrage-api service' do
          is_expected.to contain_service('vitrage-api').with(
            :ensure     => (params[:manage_service] && params[:enabled]) ? 'running' : 'stopped',
            :name       => platform_params[:api_service_name],
            :enable     => params[:enabled],
            :hasstatus  => true,
            :hasrestart => true,
            :tag        => 'vitrage-service',
          )
        end
      end
    end

    context 'with disabled service managing' do
      before do
        params.merge!({
          :manage_service => false,
          :enabled        => false })
      end

      it 'configures vitrage-api service' do
        is_expected.to contain_service('vitrage-api').with(
          :ensure     => nil,
          :name       => platform_params[:api_service_name],
          :enable     => false,
          :hasstatus  => true,
          :hasrestart => true,
          :tag        => 'vitrage-service',
        )
      end
    end

    context 'when running vitrage-api in wsgi' do
      before do
        params.merge!({ :service_name   => 'httpd' })
      end

      let :pre_condition do
        "include ::apache
         class { 'vitrage': }"
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
        "include ::apache
         class { 'vitrage': }"
      end

      it_raises 'a Puppet::Error', /Invalid service_name/
    end

    context "with custom keystone identity_uri and auth_uri" do
      before do
        params.merge!({
          :keystone_identity_uri => 'https://foo.bar:35357/',
          :keystone_auth_uri => 'https://foo.bar:5000/v2.0/',
        })
      end
      it 'configures identity_uri and auth_uri but deprecates old auth settings' do
        is_expected.to contain_vitrage_config('keystone_authtoken/identity_uri').with_value("https://foo.bar:35357/");
        is_expected.to contain_vitrage_config('keystone_authtoken/auth_uri').with_value("https://foo.bar:5000/v2.0/");
      end
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts({
          :fqdn           => 'some.host.tld',
          :processorcount => 2,
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
