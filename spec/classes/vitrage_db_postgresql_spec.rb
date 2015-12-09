require 'spec_helper'

describe 'vitrage::db::postgresql' do

  let :req_params do
    { :password => 'pw' }
  end

  let :pre_condition do
    'include postgresql::server'
  end

  context 'on a RedHat osfamily' do
    let :facts do
      @default_facts.merge({
        :osfamily                 => 'RedHat',
        :operatingsystemrelease   => '7.0',
        :concat_basedir => '/var/lib/puppet/concat'
      })
    end

    context 'with only required parameters' do
      let :params do
        req_params
      end

      it { is_expected.to contain_postgresql__server__db('vitrage').with(
        :user     => 'vitrage',
        :password => 'md58e3c14dceaf5be55c5982764df87003a'
      )}
    end

  end

  context 'on a Debian osfamily' do
    let :facts do
      @default_facts.merge({
        :operatingsystemrelease => '7.8',
        :operatingsystem        => 'Debian',
        :osfamily               => 'Debian',
        :concat_basedir => '/var/lib/puppet/concat'
      })
    end

    context 'with only required parameters' do
      let :params do
        req_params
      end

      it { is_expected.to contain_postgresql__server__db('vitrage').with(
        :user     => 'vitrage',
        :password => 'md58e3c14dceaf5be55c5982764df87003a'
      )}
    end

  end

end
