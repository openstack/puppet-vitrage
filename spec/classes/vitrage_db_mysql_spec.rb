require 'spec_helper'

describe 'vitrage::db::mysql' do

  let :pre_condition do
    [
      'include mysql::server',
      'include vitrage::db::sync'
    ]
  end

  let :facts do
    @default_facts.merge({ :osfamily => 'Debian' })
  end

  let :params do
    {
      'password'      => 'fooboozoo_default_password',
    }
  end

  describe 'with only required params' do
    it { is_expected.to contain_openstacklib__db__mysql('vitrage').with(
      :user           => 'vitrage',
      :password_hash  => '*3DDF34A86854A312A8E2C65B506E21C91800D206',
      :dbname         => 'vitrage',
      :host           => '127.0.0.1',
      :charset        => 'utf8',
      :collate        => 'utf8_general_ci',
    )}
  end

  describe "overriding allowed_hosts param to array" do
    let :params do
      {
        :password       => 'fooboozoo_default_password',
        :allowed_hosts  => ['127.0.0.1','%'],
      }
    end

    it { is_expected.to contain_openstacklib__db__mysql('vitrage').with(
      :user           => 'vitrage',
      :password_hash  => '*3DDF34A86854A312A8E2C65B506E21C91800D206',
      :dbname         => 'vitrage',
      :host           => '127.0.0.1',
      :charset        => 'utf8',
      :collate        => 'utf8_general_ci',
      :allowed_hosts  => ['127.0.0.1','%'],
    )}

  end

  describe "overriding allowed_hosts param to string" do
    let :params do
      {
        :password       => 'fooboozoo_default_password',
        :allowed_hosts  => '192.168.1.1',
      }
    end

    it { is_expected.to contain_openstacklib__db__mysql('vitrage').with(
      :user           => 'vitrage',
      :password_hash  => '*3DDF34A86854A312A8E2C65B506E21C91800D206',
      :dbname         => 'vitrage',
      :host           => '127.0.0.1',
      :charset        => 'utf8',
      :collate        => 'utf8_general_ci',
      :allowed_hosts  => '192.168.1.1',
    )}

  end

  describe "overriding allowed_hosts equal to host param" do
    let :params do
      {
        :password      => 'fooboozoo_default_password',
        :allowed_hosts => '127.0.0.1',
      }
    end

    it { is_expected.to contain_openstacklib__db__mysql('vitrage').with(
      :user          => 'vitrage',
      :password_hash => '*3DDF34A86854A312A8E2C65B506E21C91800D206',
      :dbname        => 'vitrage',
      :host          => '127.0.0.1',
      :charset       => 'utf8',
      :collate       => 'utf8_general_ci',
      :allowed_hosts => '127.0.0.1',
    )}

  end

end
