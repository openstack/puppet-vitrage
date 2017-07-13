require 'spec_helper'

describe 'vitrage::wsgi::apache' do

  shared_examples_for 'apache serving vitrage with mod_wsgi' do
    context 'with default parameters' do
      it { is_expected.to contain_class('vitrage::params') }
      it { is_expected.to contain_class('apache') }
      it { is_expected.to contain_class('apache::mod::wsgi') }
      it { is_expected.to contain_class('apache::mod::ssl') }
      it { is_expected.to contain_openstacklib__wsgi__apache('vitrage_wsgi').with(
        :bind_port           => 8999,
        :group               => 'vitrage',
        :path                => '/',
        :servername          => facts[:fqdn],
        :ssl                 => true,
        :threads             => facts[:os_workers],
        :user                => 'vitrage',
        :workers             => 1,
        :wsgi_daemon_process => 'vitrage',
        :wsgi_process_group  => 'vitrage',
        :wsgi_script_dir     => platform_params[:wsgi_script_path],
        :wsgi_script_file    => 'app',
        :wsgi_script_source  => platform_params[:wsgi_script_source],
      )}
    end

    describe 'when overriding parameters using different ports' do
      let :params do
        {
          :servername  => 'dummy.host',
          :bind_host   => '10.42.51.1',
          :port        => 12345,
          :ssl         => false,
          :workers     => 37,
        }
      end
      it { is_expected.to contain_class('vitrage::params') }
      it { is_expected.to contain_class('apache') }
      it { is_expected.to contain_class('apache::mod::wsgi') }
      it { is_expected.to_not contain_class('apache::mod::ssl') }
      it { is_expected.to contain_openstacklib__wsgi__apache('vitrage_wsgi').with(
        :bind_host                 => '10.42.51.1',
        :bind_port                 => 12345,
        :group                     => 'vitrage',
        :path                      => '/',
        :servername                => 'dummy.host',
        :ssl                       => false,
        :threads                   => facts[:os_workers],
        :user                      => 'vitrage',
        :workers                   => 37,
        :wsgi_daemon_process       => 'vitrage',
        :wsgi_process_group        => 'vitrage',
        :wsgi_script_dir           => platform_params[:wsgi_script_path],
        :wsgi_script_file          => 'app',
        :wsgi_script_source        => platform_params[:wsgi_script_source],
      )}
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts({
          :os_workers     => 8,
          :concat_basedir => '/var/lib/puppet/concat',
          :fqdn           => 'some.host.tld'
        }))
      end

      let(:platform_params) do
        case facts[:osfamily]
        when 'Debian'
          {
            :httpd_service_name => 'apache2',
            :httpd_ports_file   => '/etc/apache2/ports.conf',
            :wsgi_script_path   => '/usr/lib/cgi-bin/vitrage',
            :wsgi_script_source => '/usr/share/vitrage-common/app.wsgi'
          }
        when 'RedHat'
          {
            :httpd_service_name => 'httpd',
            :httpd_ports_file   => '/etc/httpd/conf/ports.conf',
            :wsgi_script_path   => '/var/www/cgi-bin/vitrage',
            :wsgi_script_source => '/usr/lib/python2.7/site-packages/vitrage/api/app.wsgi'
          }

        end
      end
      it_configures 'apache serving vitrage with mod_wsgi'
    end
  end

end
