require 'spec_helper'

describe 'vitrage' do

  shared_examples 'vitrage' do

    context 'with default parameters' do
      let :params do
        { :purge_config => false  } 
      end

      it 'contains the deps class' do
        is_expected.to contain_class('vitrage::deps')
      end

      it 'installs packages' do
        is_expected.to contain_package('vitrage').with(
          :name   => platform_params[:vitrage_common_package],
          :ensure => 'present',
          :tag    => ['openstack', 'vitrage-package']
        )
      end

      it 'configures messaging' do
        is_expected.to contain_oslo__messaging__default('vitrage_config').with(
          :transport_url        => '<SERVICE DEFAULT>',
          :rpc_response_timeout => '<SERVICE DEFAULT>',
          :control_exchange     => '<SERVICE DEFAULT>'
        )
        is_expected.to contain_oslo__messaging__rabbit('vitrage_config').with(
          :rabbit_use_ssl                  => '<SERVICE DEFAULT>',
          :heartbeat_timeout_threshold     => '<SERVICE DEFAULT>',
          :heartbeat_rate                  => '<SERVICE DEFAULT>',
          :heartbeat_in_pthread            => nil,
          :kombu_reconnect_delay           => '<SERVICE DEFAULT>',
          :kombu_failover_strategy         => '<SERVICE DEFAULT>',
          :amqp_durable_queues             => '<SERVICE DEFAULT>',
          :kombu_compression               => '<SERVICE DEFAULT>',
          :kombu_ssl_ca_certs              => '<SERVICE DEFAULT>',
          :kombu_ssl_certfile              => '<SERVICE DEFAULT>',
          :kombu_ssl_keyfile               => '<SERVICE DEFAULT>',
          :kombu_ssl_version               => '<SERVICE DEFAULT>',
          :rabbit_ha_queues                => '<SERVICE DEFAULT>',
          :rabbit_retry_interval           => '<SERVICE DEFAULT>',
          :rabbit_quorum_queue             => '<SERVICE DEFAULT>',
          :rabbit_transient_quorum_queue   => '<SERVICE DEFAULT>',
          :rabbit_quorum_delivery_limit    => '<SERVICE DEFAULT>',
          :rabbit_quorum_max_memory_length => '<SERVICE DEFAULT>',
          :rabbit_quorum_max_memory_bytes  => '<SERVICE DEFAULT>',
          :enable_cancel_on_failover       => '<SERVICE DEFAULT>',
        )
        is_expected.to contain_oslo__messaging__notifications('vitrage_config').with(
          :transport_url => '<SERVICE DEFAULT>',
          :driver        => '<SERVICE DEFAULT>',
          :topics        => '<SERVICE DEFAULT>',
          :retry         => '<SERVICE DEFAULT>'
        )
      end

      it 'configures datasources' do
        is_expected.to contain_vitrage_config('datasources/types').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_vitrage_config('datasources/snapshots_interval').with_value('<SERVICE DEFAULT>')
      end

      it 'passes purge to resource' do
        is_expected.to contain_resources('vitrage_config').with({
          :purge => false
        })
      end

    end

    context 'with overridden parameters' do
      let :params do
        {
          :default_transport_url              => 'rabbit://rabbit_user:password@localhost:5673',
          :rpc_response_timeout               => '120',
          :control_exchange                   => 'vitrage',
          :rabbit_ha_queues                   => true,
          :rabbit_heartbeat_timeout_threshold => '60',
          :rabbit_heartbeat_rate              => '10',
          :rabbit_heartbeat_in_pthread        => true,
          :kombu_compression                  => 'gzip',
          :kombu_reconnect_delay              => '5.0',
          :kombu_failover_strategy            => 'shuffle',
          :amqp_durable_queues                => true,
          :package_ensure                     => '2012.1.1-15.el6',
          :notification_transport_url         => 'rabbit://rabbit_user:password@localhost:5673',
          :notification_driver                => 'messaging',
          :notification_topics                => 'openstack',
          :notification_retry                 => 10,
          :types                              => 'nova.host,nova.instance,nova.zone,cinder.volume,neutron.port,neutron.network,doctor',
          :snapshots_interval                 => '120',
        }
      end

      it 'configures messaging' do
        is_expected.to contain_oslo__messaging__default('vitrage_config').with(
          :transport_url        => 'rabbit://rabbit_user:password@localhost:5673',
          :rpc_response_timeout => '120',
          :control_exchange     => 'vitrage'
        )
        is_expected.to contain_oslo__messaging__rabbit('vitrage_config').with(
          :rabbit_use_ssl                  => '<SERVICE DEFAULT>',
          :heartbeat_timeout_threshold     => '60',
          :heartbeat_rate                  => '10',
          :heartbeat_in_pthread            => true,
          :kombu_reconnect_delay           => '5.0',
          :kombu_failover_strategy         => 'shuffle',
          :amqp_durable_queues             => true,
          :kombu_compression               => 'gzip',
          :kombu_ssl_ca_certs              => '<SERVICE DEFAULT>',
          :kombu_ssl_certfile              => '<SERVICE DEFAULT>',
          :kombu_ssl_keyfile               => '<SERVICE DEFAULT>',
          :kombu_ssl_version               => '<SERVICE DEFAULT>',
          :rabbit_ha_queues                => true,
          :rabbit_retry_interval           => '<SERVICE DEFAULT>',
          :rabbit_quorum_queue             => '<SERVICE DEFAULT>',
          :rabbit_transient_quorum_queue   => '<SERVICE DEFAULT>',
          :rabbit_quorum_delivery_limit    => '<SERVICE DEFAULT>',
          :rabbit_quorum_max_memory_length => '<SERVICE DEFAULT>',
          :rabbit_quorum_max_memory_bytes  => '<SERVICE DEFAULT>',
          :enable_cancel_on_failover       => '<SERVICE DEFAULT>',
        )
        is_expected.to contain_oslo__messaging__notifications('vitrage_config').with(
          :transport_url => 'rabbit://rabbit_user:password@localhost:5673',
          :driver        => 'messaging',
          :topics        => 'openstack',
          :retry         => 10,
        )
      end

      it 'configures datasources' do
        is_expected.to contain_vitrage_config('datasources/types').with_value('nova.host,nova.instance,nova.zone,cinder.volume,neutron.port,neutron.network,doctor')
        is_expected.to contain_vitrage_config('datasources/snapshots_interval').with_value('120')
      end
    end

    context 'with rabbit ssl enabled with kombu' do
      let :params do
        { :rabbit_use_ssl     => true,
          :kombu_ssl_ca_certs => '/etc/ca.cert',
          :kombu_ssl_certfile => '/etc/certfile',
          :kombu_ssl_keyfile  => '/etc/key',
          :kombu_ssl_version  => 'TLSv1', }
      end

      it 'configures rabbit' do
        is_expected.to contain_oslo__messaging__rabbit('vitrage_config').with(
          :rabbit_use_ssl     => true,
          :kombu_ssl_ca_certs => '/etc/ca.cert',
          :kombu_ssl_certfile => '/etc/certfile',
          :kombu_ssl_keyfile  => '/etc/key',
          :kombu_ssl_version  => 'TLSv1',
        )
      end
    end

    context 'with rabbit ssl enabled without kombu' do
      let :params do
        { :rabbit_use_ssl     => true, }
      end

      it 'configures rabbit' do
        is_expected.to contain_oslo__messaging__rabbit('vitrage_config').with(
          :rabbit_use_ssl     => true,
          :kombu_ssl_ca_certs => '<SERVICE DEFAULT>',
          :kombu_ssl_certfile => '<SERVICE DEFAULT>',
          :kombu_ssl_keyfile  => '<SERVICE DEFAULT>',
          :kombu_ssl_version  => '<SERVICE DEFAULT>',
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
        case facts[:os]['family']
        when 'Debian'
          { :vitrage_common_package => 'vitrage-common' }
        when 'RedHat'
          { :vitrage_common_package => 'openstack-vitrage-common' }
        end
      end
      it_behaves_like 'vitrage'
    end
  end


end
