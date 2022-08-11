require 'spec_helper'

describe 'vitrage::wsgi::apache' do

  shared_examples_for 'apache serving vitrage with mod_wsgi' do
    context 'with default parameters' do
      it { is_expected.to contain_class('vitrage::params') }
      it { is_expected.to contain_openstacklib__wsgi__apache('vitrage_wsgi').with(
        :bind_port                   => 8999,
        :group                       => 'vitrage',
        :path                        => '/',
        :servername                  => facts[:fqdn],
        :ssl                         => false,
        :threads                     => 1,
        :user                        => 'vitrage',
        :workers                     => facts[:os_workers],
        :wsgi_daemon_process         => 'vitrage',
        :wsgi_process_group          => 'vitrage',
        :wsgi_script_dir             => platform_params[:wsgi_script_path],
        :wsgi_script_file            => 'app',
        :wsgi_script_source          => platform_params[:wsgi_script_source],
        :headers                     => nil,
        :request_headers             => nil,
        :custom_wsgi_process_options => {},
        :access_log_file             => false,
        :access_log_format           => false,
      )}
    end

    describe 'when overriding parameters' do
      let :params do
        {
          :servername                  => 'dummy.host',
          :bind_host                   => '10.42.51.1',
          :port                        => 12345,
          :ssl                         => true,
          :wsgi_process_display_name   => 'vitrage',
          :workers                     => 37,
          :access_log_file             => '/var/log/httpd/access_log',
          :access_log_format           => 'some format',
          :error_log_file              => '/var/log/httpd/error_log',
          :custom_wsgi_process_options => {
            'python_path' => '/my/python/path',
          },
          :headers                     => ['set X-XSS-Protection "1; mode=block"'],
          :request_headers             => ['set Content-Type "application/json"'],
        }
      end
      it { is_expected.to contain_class('vitrage::params') }
      it { is_expected.to contain_openstacklib__wsgi__apache('vitrage_wsgi').with(
        :bind_host                   => '10.42.51.1',
        :bind_port                   => 12345,
        :group                       => 'vitrage',
        :path                        => '/',
        :servername                  => 'dummy.host',
        :ssl                         => true,
        :threads                     => 1,
        :user                        => 'vitrage',
        :workers                     => 37,
        :wsgi_daemon_process         => 'vitrage',
        :wsgi_process_display_name   => 'vitrage',
        :wsgi_process_group          => 'vitrage',
        :wsgi_script_dir             => platform_params[:wsgi_script_path],
        :wsgi_script_file            => 'app',
        :wsgi_script_source          => platform_params[:wsgi_script_source],
        :access_log_file             => '/var/log/httpd/access_log',
        :access_log_format           => 'some format',
        :error_log_file              => '/var/log/httpd/error_log',
        :headers                     => ['set X-XSS-Protection "1; mode=block"'],
        :request_headers             => ['set Content-Type "application/json"'],
        :custom_wsgi_process_options => {
          'python_path' => '/my/python/path',
        },
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
            :wsgi_script_path   => '/usr/lib/cgi-bin/vitrage',
            :wsgi_script_source => '/usr/share/vitrage-common/app.wsgi'
          }
        when 'RedHat'
          {
            :wsgi_script_path   => '/var/www/cgi-bin/vitrage',
            :wsgi_script_source => '/usr/lib/python3.9/site-packages/vitrage/api/app.wsgi'
          }
        end
      end
      it_configures 'apache serving vitrage with mod_wsgi'
    end
  end

end
