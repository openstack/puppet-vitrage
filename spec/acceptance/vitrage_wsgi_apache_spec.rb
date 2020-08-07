require 'spec_helper_acceptance'

describe 'basic vitrage' do

  context 'default parameters' do

    it 'should work with no errors' do
      pp= <<-EOS
      include openstack_integration
      include openstack_integration::repos
      include openstack_integration::apache
      include openstack_integration::rabbitmq
      include openstack_integration::mysql
      include openstack_integration::keystone

      case $::osfamily {
        'Debian': {
          warning('Vitrage is not yet packaged on Ubuntu systems.')
        }
        'RedHat': {
          package { 'python-setproctitle':
            ensure => present,
          }
          package { 'python2-cotyledon':
            ensure => present,
          }
          include openstack_integration::vitrage
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
