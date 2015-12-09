#
# Unit tests for vitrage::keystone::auth
#

require 'spec_helper'

describe 'vitrage::keystone::auth' do

  let :facts do
    @default_facts.merge({ :osfamily => 'Debian' })
  end

  describe 'with default class parameters' do
    let :params do
      { :password => 'vitrage_password',
        :tenant   => 'foobar' }
    end

    it { is_expected.to contain_keystone_user('vitrage').with(
      :ensure   => 'present',
      :password => 'vitrage_password',
    ) }

    it { is_expected.to contain_keystone_user_role('vitrage@foobar').with(
      :ensure  => 'present',
      :roles   => ['admin']
    )}

    it { is_expected.to contain_keystone_service('vitrage').with(
      :ensure      => 'present',
      :type        => 'root_cause_analysis_engine',
      :description => 'vitrage Root Cause Analysis engine Service'
    ) }

    it { is_expected.to contain_keystone_endpoint('RegionOne/vitrage').with(
      :ensure       => 'present',
      :public_url   => 'http://127.0.0.1:8999/v1',
      :admin_url    => 'http://127.0.0.1:8999/v1',
      :internal_url => 'http://127.0.0.1:8999/v1',
    ) }
  end

  describe 'when overriding URL parameters' do
    let :params do
      { :password     => 'vitrage_password',
        :public_url   => 'https://10.10.10.10:80',
        :internal_url => 'http://10.10.10.11:81',
        :admin_url    => 'http://10.10.10.12:81', }
    end

    it { is_expected.to contain_keystone_endpoint('RegionOne/vitrage').with(
      :ensure       => 'present',
      :public_url   => 'https://10.10.10.10:80',
      :internal_url => 'http://10.10.10.11:81',
      :admin_url    => 'http://10.10.10.12:81',
    ) }
  end

  describe 'when overriding auth name' do
    let :params do
      { :password => 'foo',
        :auth_name => 'vitragey' }
    end

    it { is_expected.to contain_keystone_user('vitragey') }
    it { is_expected.to contain_keystone_user_role('vitragey@services') }
    it { is_expected.to contain_keystone_service('vitragey') }
    it { is_expected.to contain_keystone_endpoint('RegionOne/vitragey') }
  end

  describe 'when overriding service name' do
    let :params do
      { :service_name => 'vitrage_service',
        :auth_name    => 'vitrage',
        :password     => 'vitrage_password' }
    end

    it { is_expected.to contain_keystone_user('vitrage') }
    it { is_expected.to contain_keystone_user_role('vitrage@services') }
    it { is_expected.to contain_keystone_service('vitrage_service') }
    it { is_expected.to contain_keystone_endpoint('RegionOne/vitrage_service') }
  end

  describe 'when disabling user configuration' do

    let :params do
      {
        :password       => 'vitrage_password',
        :configure_user => false
      }
    end

    it { is_expected.not_to contain_keystone_user('vitrage') }
    it { is_expected.to contain_keystone_user_role('vitrage@services') }
    it { is_expected.to contain_keystone_service('vitrage').with(
      :ensure      => 'present',
      :type        => 'root_cause_analysis_engine',
      :description => 'vitrage Root Cause Analysis engine Service'
    ) }

  end

  describe 'when disabling user and user role configuration' do

    let :params do
      {
        :password            => 'vitrage_password',
        :configure_user      => false,
        :configure_user_role => false
      }
    end

    it { is_expected.not_to contain_keystone_user('vitrage') }
    it { is_expected.not_to contain_keystone_user_role('vitrage@services') }
    it { is_expected.to contain_keystone_service('vitrage').with(
      :ensure      => 'present',
      :type        => 'root_cause_analysis_engine',
      :description => 'vitrage Root Cause Analysis engine Service'
    ) }

  end

end
