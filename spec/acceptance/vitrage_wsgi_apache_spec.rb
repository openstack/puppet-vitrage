require 'spec_helper_acceptance'

describe 'basic vitrage' do

  context 'default parameters' do

    it 'should work with no errors' do
      pp= <<-EOS
      include ::openstack_integration
      include ::openstack_integration::repos
      include ::openstack_integration::rabbitmq
      include ::openstack_integration::mysql
      include ::openstack_integration::keystone

      rabbitmq_user { 'vitrage':
        admin    => true,
        password => 'an_even_bigger_secret',
        provider => 'rabbitmqctl',
        require  => Class['rabbitmq'],
      }

      rabbitmq_user_permissions { 'vitrage@/':
        configure_permission => '.*',
        write_permission     => '.*',
        read_permission      => '.*',
        provider             => 'rabbitmqctl',
        require              => Class['rabbitmq'],
      }

      case $::osfamily {
        'Debian': {
          warning('Vitrage is not yet packaged on Ubuntu systems.')
        }
        'RedHat': {

          class { '::vitrage':
            debug                 => true,
            default_transport_url => 'rabbit://vitrage:an_even_bigger_secret@127.0.0.1:5672',
          }
          class { '::vitrage::keystone::auth':
            password => 'a_big_secret',
          }
          class { '::vitrage::keystone::authtoken':
            password => 'a_big_secret',
          }
          class { '::vitrage::api':
            enabled      => true,
            service_name => 'httpd',
          }
          include ::apache
          class { '::vitrage::wsgi::apache':
            ssl => false,
          }
          class { '::vitrage::auth':
            auth_url      => 'http://127.0.0.1:5000/v2.0',
            auth_password => 'a_big_secret',
          }
          class { '::vitrage::client': }
          class { '::vitrage::notifier': }
          class { '::vitrage::graph': }
        }
        default: {
          fail("Unsupported osfamily (${::osfamily})")
        }
      }
      EOS


      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    if os[:family].casecmp('RedHat') == 0
      describe port(8999) do
        it { is_expected.to be_listening }
      end
    end


  end
end
