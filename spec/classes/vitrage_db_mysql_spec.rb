require 'spec_helper'

describe 'vitrage::db::mysql' do

  let :pre_condition do
    [
      'include mysql::server',
      'include vitrage::db::sync'
    ]
  end

  shared_examples_for 'vitrage::db::mysql' do
    context 'with only required params' do
      let :params do
        {
          'password' => 'vitragepass',
        }
      end

      it { should contain_class('vitrage::deps') }

      it { is_expected.to contain_openstacklib__db__mysql('vitrage').with(
        :user     => 'vitrage',
        :password => 'vitragepass',
        :dbname   => 'vitrage',
        :host     => '127.0.0.1',
        :charset  => 'utf8',
        :collate  => 'utf8_general_ci',
      )}
    end

    context "overriding allowed_hosts param to array" do
      let :params do
        {
          :password      => 'vitragepass',
          :allowed_hosts => ['127.0.0.1','%'],
        }
      end

      it { is_expected.to contain_openstacklib__db__mysql('vitrage').with(
        :user          => 'vitrage',
        :password      => 'vitragepass',
        :dbname        => 'vitrage',
        :host          => '127.0.0.1',
        :charset       => 'utf8',
        :collate       => 'utf8_general_ci',
        :allowed_hosts => ['127.0.0.1','%'],
      )}

    end

    context "overriding allowed_hosts param to string" do
      let :params do
        {
          :password      => 'vitragepass',
          :allowed_hosts => '192.168.1.1',
        }
      end

      it { is_expected.to contain_openstacklib__db__mysql('vitrage').with(
        :user          => 'vitrage',
        :password      => 'vitragepass',
        :dbname        => 'vitrage',
        :host          => '127.0.0.1',
        :charset       => 'utf8',
        :collate       => 'utf8_general_ci',
        :allowed_hosts => '192.168.1.1',
      )}

    end

    context "overriding allowed_hosts equal to host param" do
      let :params do
        {
          :password      => 'vitragepass',
          :allowed_hosts => '127.0.0.1',
        }
      end

      it { is_expected.to contain_openstacklib__db__mysql('vitrage').with(
        :user          => 'vitrage',
        :password      => 'vitragepass',
        :dbname        => 'vitrage',
        :host          => '127.0.0.1',
        :charset       => 'utf8',
        :collate       => 'utf8_general_ci',
        :allowed_hosts => '127.0.0.1',
      )}

    end
  end

  on_supported_os({
    :supported_os  => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_configures 'vitrage::db::mysql'
    end
  end

end
