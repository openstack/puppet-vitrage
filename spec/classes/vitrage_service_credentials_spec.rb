require 'spec_helper'

describe 'vitrage::service_credentials' do

  let :params do
    {
      :auth_url => 'http://localhost:5000',
      :password => 'password',
    }
  end

  shared_examples_for 'vitrage::service_credentials' do

    it 'configures authentication' do
      is_expected.to contain_vitrage_config('service_credentials/auth_url').with_value('http://localhost:5000')
      is_expected.to contain_vitrage_config('service_credentials/region_name').with_value('RegionOne')
      is_expected.to contain_vitrage_config('service_credentials/project_domain_name').with_value('Default')
      is_expected.to contain_vitrage_config('service_credentials/user_domain_name').with_value('Default')
      is_expected.to contain_vitrage_config('service_credentials/auth_type').with_value('password')
      is_expected.to contain_vitrage_config('service_credentials/username').with_value('vitrage')
      is_expected.to contain_vitrage_config('service_credentials/password').with_value('password').with_secret(true)
      is_expected.to contain_vitrage_config('service_credentials/project_name').with_value('services')
      is_expected.to contain_vitrage_config('service_credentials/cacert').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_vitrage_config('service_credentials/system_scope').with_value('<SERVICE DEFAULT>')
    end

    context 'when overriding parameters' do
      before do
        params.merge!(
          :cacert      => '/tmp/dummy.pem',
          :interface   => 'internalURL',
        )
      end
      it { is_expected.to contain_vitrage_config('service_credentials/cacert').with_value(params[:cacert]) }
      it { is_expected.to contain_vitrage_config('service_credentials/interface').with_value(params[:interface]) }
    end

    context 'when system_scope is set' do
      before do
        params.merge!(
          :system_scope => 'all'
        )
      end
      it 'configures system-scoped credential' do
        is_expected.to contain_vitrage_config('service_credentials/project_domain_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_vitrage_config('service_credentials/project_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_vitrage_config('service_credentials/system_scope').with_value('all')
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

      it_configures 'vitrage::service_credentials'
    end
  end

end
