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

      it 'configures rabbit' do
        is_expected.to contain_vitrage_config('DEFAULT/transport_url').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_vitrage_config('DEFAULT/rpc_response_timeout').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_vitrage_config('DEFAULT/control_exchange').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_vitrage_config('oslo_messaging_rabbit/heartbeat_timeout_threshold').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_vitrage_config('oslo_messaging_rabbit/heartbeat_rate').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_vitrage_config('oslo_messaging_rabbit/heartbeat_in_pthread').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_vitrage_config('oslo_messaging_rabbit/kombu_compression').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_vitrage_config('oslo_messaging_rabbit/kombu_failover_strategy').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_vitrage_config('oslo_messaging_notifications/transport_url').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_vitrage_config('oslo_messaging_notifications/driver').with_value('<SERVICE DEFAULT>')
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
          :rabbit_ha_queues                   => 'undef',
          :rabbit_heartbeat_timeout_threshold => '60',
          :rabbit_heartbeat_rate              => '10',
          :rabbit_heartbeat_in_pthread        => true,
          :kombu_compression                  => 'gzip',
          :kombu_failover_strategy            => 'shuffle',
          :package_ensure                     => '2012.1.1-15.el6',
          :notification_transport_url         => 'rabbit://rabbit_user:password@localhost:5673',
          :notification_driver                => 'messaging',
          :notification_topics                => 'openstack',
          :types                              => 'nova.host,nova.instance,nova.zone,cinder.volume,neutron.port,neutron.network,doctor',
          :snapshots_interval                 => '120',
        }
      end

      it 'configures rabbit' do
        is_expected.to contain_vitrage_config('DEFAULT/transport_url').with_value('rabbit://rabbit_user:password@localhost:5673')
        is_expected.to contain_vitrage_config('DEFAULT/rpc_response_timeout').with_value('120')
        is_expected.to contain_vitrage_config('DEFAULT/control_exchange').with_value('vitrage')
        is_expected.to contain_vitrage_config('oslo_messaging_rabbit/heartbeat_timeout_threshold').with_value('60')
        is_expected.to contain_vitrage_config('oslo_messaging_rabbit/heartbeat_rate').with_value('10')
        is_expected.to contain_vitrage_config('oslo_messaging_rabbit/heartbeat_in_pthread').with_value(true)
        is_expected.to contain_vitrage_config('oslo_messaging_rabbit/kombu_compression').with_value('gzip')
        is_expected.to contain_vitrage_config('oslo_messaging_rabbit/kombu_failover_strategy').with_value('shuffle')
      end

      it 'configures various things' do
        is_expected.to contain_vitrage_config('oslo_messaging_notifications/transport_url').with_value('rabbit://rabbit_user:password@localhost:5673')
        is_expected.to contain_vitrage_config('oslo_messaging_notifications/driver').with_value('messaging')
        is_expected.to contain_vitrage_config('oslo_messaging_notifications/topics').with_value('openstack')
        is_expected.to contain_vitrage_config('datasources/types').with_value('nova.host,nova.instance,nova.zone,cinder.volume,neutron.port,neutron.network,doctor')
        is_expected.to contain_vitrage_config('datasources/snapshots_interval').with_value('120')
      end

      context 'with multiple notification_driver' do
        before { params.merge!( :notification_driver => ['messaging', 'messagingv2']) }

        it { is_expected.to contain_vitrage_config('oslo_messaging_notifications/driver').with_value(
          ['messaging', 'messagingv2']
        ) }
      end

    end

    context 'with kombu_reconnect_delay set to 5.0' do
      let :params do
        { :kombu_reconnect_delay => '5.0' }
      end

      it 'configures rabbit' do
        is_expected.to contain_vitrage_config('oslo_messaging_rabbit/kombu_reconnect_delay').with_value('5.0')
      end
    end

    context 'with rabbit_ha_queues set to true' do
      let :params do
        { :rabbit_ha_queues => 'true' }
      end

      it 'configures rabbit' do
        is_expected.to contain_vitrage_config('oslo_messaging_rabbit/rabbit_ha_queues').with_value(true)
      end
    end

    context 'with rabbit_ha_queues set to false' do
      let :params do
        { :rabbit_ha_queues => 'false' }
      end

      it 'configures rabbit' do
        is_expected.to contain_vitrage_config('oslo_messaging_rabbit/rabbit_ha_queues').with_value(false)
      end
    end

    context 'with amqp_durable_queues parameter' do
      let :params do
        { :amqp_durable_queues => 'true' }
      end

      it 'configures rabbit' do
        is_expected.to contain_vitrage_config('oslo_messaging_rabbit/rabbit_ha_queues').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_vitrage_config('oslo_messaging_rabbit/amqp_durable_queues').with_value(true)
        is_expected.to contain_oslo__messaging__rabbit('vitrage_config').with(
          :rabbit_use_ssl     => '<SERVICE DEFAULT>',
        )
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

    context 'with default amqp parameters' do
      it 'configures amqp' do
        is_expected.to contain_vitrage_config('oslo_messaging_amqp/server_request_prefix').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_vitrage_config('oslo_messaging_amqp/broadcast_prefix').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_vitrage_config('oslo_messaging_amqp/group_request_prefix').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_vitrage_config('oslo_messaging_amqp/container_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_vitrage_config('oslo_messaging_amqp/idle_timeout').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_vitrage_config('oslo_messaging_amqp/trace').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_vitrage_config('oslo_messaging_amqp/ssl_ca_file').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_vitrage_config('oslo_messaging_amqp/ssl_cert_file').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_vitrage_config('oslo_messaging_amqp/ssl_key_file').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_vitrage_config('oslo_messaging_amqp/ssl_key_password').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_vitrage_config('oslo_messaging_amqp/allow_insecure_clients').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_vitrage_config('oslo_messaging_amqp/sasl_mechanisms').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_vitrage_config('oslo_messaging_amqp/sasl_config_dir').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_vitrage_config('oslo_messaging_amqp/sasl_config_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_vitrage_config('oslo_messaging_amqp/username').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_vitrage_config('oslo_messaging_amqp/password').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'with overridden amqp parameters' do
      let :params do
        { :default_transport_url => 'amqp://amqp_user:password@localhost:5672',
          :rpc_response_timeout  => '240',
          :control_exchange      => 'openstack',
          :amqp_idle_timeout     => '60',
          :amqp_trace            => true,
          :amqp_ssl_ca_file      => '/etc/ca.cert',
          :amqp_ssl_cert_file    => '/etc/certfile',
          :amqp_ssl_key_file     => '/etc/key',
          :amqp_username         => 'amqp_user',
          :amqp_password         => 'password',
        }
      end

      it 'configures amqp' do
        is_expected.to contain_vitrage_config('DEFAULT/transport_url').with_value('amqp://amqp_user:password@localhost:5672')
        is_expected.to contain_vitrage_config('DEFAULT/rpc_response_timeout').with_value('240')
        is_expected.to contain_vitrage_config('DEFAULT/control_exchange').with_value('openstack')
        is_expected.to contain_vitrage_config('oslo_messaging_amqp/idle_timeout').with_value('60')
        is_expected.to contain_vitrage_config('oslo_messaging_amqp/trace').with_value('true')
        is_expected.to contain_vitrage_config('oslo_messaging_amqp/ssl_ca_file').with_value('/etc/ca.cert')
        is_expected.to contain_vitrage_config('oslo_messaging_amqp/ssl_cert_file').with_value('/etc/certfile')
        is_expected.to contain_vitrage_config('oslo_messaging_amqp/ssl_key_file').with_value('/etc/key')
        is_expected.to contain_vitrage_config('oslo_messaging_amqp/username').with_value('amqp_user')
        is_expected.to contain_vitrage_config('oslo_messaging_amqp/password').with_value('password')
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
          { :vitrage_common_package => 'vitrage-common' }
        when 'RedHat'
          { :vitrage_common_package => 'openstack-vitrage-common' }
        end
      end
      it_behaves_like 'vitrage'
    end
  end


end
