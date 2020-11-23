require 'spec_helper'

describe 'vitrage::db::sync' do

  shared_examples_for 'vitrage-dbsync' do

    it { is_expected.to contain_class('vitrage::deps') }

    it 'runs vitrage-manage db sync' do
      is_expected.to contain_exec('vitrage-db-sync').with(
        :command     => 'vitrage-dbsync ',
        :user        => 'vitrage',
        :path        => '/usr/bin',
        :refreshonly => 'true',
        :try_sleep   => 5,
        :tries       => 10,
        :timeout     => 300,
        :logoutput   => 'on_failure',
        :subscribe   => ['Anchor[vitrage::install::end]',
                         'Anchor[vitrage::config::end]',
                         'Anchor[vitrage::dbsync::begin]'],
        :notify      => 'Anchor[vitrage::dbsync::end]',
        :tag         => 'openstack-db',
      )
    end

    describe "overriding extra_params" do
      let :params do
        {
          :extra_params    => '--config-file /etc/vitrage/vitrage.conf',
          :db_sync_timeout => 750,
        }
      end

      it {
        is_expected.to contain_exec('vitrage-db-sync').with(
          :command     => 'vitrage-dbsync --config-file /etc/vitrage/vitrage.conf',
          :user        => 'vitrage',
          :path        => '/usr/bin',
          :refreshonly => 'true',
          :try_sleep   => 5,
          :tries       => 10,
          :timeout     => 750,
          :logoutput   => 'on_failure',
          :subscribe   => ['Anchor[vitrage::install::end]',
                         'Anchor[vitrage::config::end]',
                         'Anchor[vitrage::dbsync::begin]'],
          :notify      => 'Anchor[vitrage::dbsync::end]',
          :tag         => 'openstack-db',
        )
      }
    end

  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts({
          :os_workers     => 8,
          :concat_basedir => '/var/lib/puppet/concat'
        }))
      end

      it_configures 'vitrage-dbsync'
    end
  end

end
