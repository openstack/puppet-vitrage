require 'spec_helper'

describe 'vitrage::wsgi::apache' do

  shared_examples_for 'apache serving vitrage with mod_wsgi' do
    it { is_expected.to contain_service('httpd').with_name(platform_parameters[:httpd_service_name]) }
    it { is_expected.to contain_class('vitrage::params') }
    it { is_expected.to contain_class('apache') }
    it { is_expected.to contain_class('apache::mod::wsgi') }

    describe 'with default parameters' do

      it { is_expected.to contain_file("#{platform_parameters[:wsgi_script_path]}").with(
        'ensure'  => 'directory',
        'owner'   => 'vitrage',
        'group'   => 'vitrage',
        'require' => 'Package[httpd]'
      )}


      it { is_expected.to contain_file('vitrage_wsgi').with(
        'ensure'  => 'file',
        'path'    => "#{platform_parameters[:wsgi_script_path]}/app",
        'source'  => platform_parameters[:wsgi_script_source],
        'owner'   => 'vitrage',
        'group'   => 'vitrage',
        'mode'    => '0644'
      )}
      it { is_expected.to contain_file('vitrage_wsgi').that_requires("File[#{platform_parameters[:wsgi_script_path]}]") }

      it { is_expected.to contain_apache__vhost('vitrage_wsgi').with(
        'servername'                  => 'some.host.tld',
        'ip'                          => nil,
        'port'                        => '8999',
        'docroot'                     => "#{platform_parameters[:wsgi_script_path]}",
        'docroot_owner'               => 'vitrage',
        'docroot_group'               => 'vitrage',
        'ssl'                         => 'true',
        'wsgi_daemon_process'         => 'vitrage',
        'wsgi_process_group'          => 'vitrage',
        'wsgi_script_aliases'         => { '/' => "#{platform_parameters[:wsgi_script_path]}/app" },
        'require'                     => 'File[vitrage_wsgi]'
      )}
      it { is_expected.to contain_concat("#{platform_parameters[:httpd_ports_file]}") }
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

      it { is_expected.to contain_apache__vhost('vitrage_wsgi').with(
        'servername'                  => 'dummy.host',
        'ip'                          => '10.42.51.1',
        'port'                        => '12345',
        'docroot'                     => "#{platform_parameters[:wsgi_script_path]}",
        'docroot_owner'               => 'vitrage',
        'docroot_group'               => 'vitrage',
        'ssl'                         => 'false',
        'wsgi_daemon_process'         => 'vitrage',
        'wsgi_process_group'          => 'vitrage',
        'wsgi_script_aliases'         => { '/' => "#{platform_parameters[:wsgi_script_path]}/app" },
        'require'                     => 'File[vitrage_wsgi]'
      )}

      it { is_expected.to contain_concat("#{platform_parameters[:httpd_ports_file]}") }
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

      let(:platform_parameters) do
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
