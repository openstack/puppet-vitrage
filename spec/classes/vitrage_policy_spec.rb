require 'spec_helper'

describe 'vitrage::policy' do

  shared_examples_for 'vitrage policies' do
    let :params do
      {
        :policy_path => '/etc/vitrage/policy.json',
        :policies    => {
          'context_is_admin' => {
            'key'   => 'context_is_admin',
            'value' => 'foo:bar'
          }
        }
      }
    end

    it 'set up the policies' do
      is_expected.to contain_openstacklib__policy__base('context_is_admin').with({
        :key        => 'context_is_admin',
        :value      => 'foo:bar',
        :file_user  => 'root',
        :file_group => 'vitrage',
      })
      is_expected.to contain_oslo__policy('vitrage_config').with(
        :policy_file => '/etc/vitrage/policy.json',
      )
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_configures 'vitrage policies'
    end
  end
end
