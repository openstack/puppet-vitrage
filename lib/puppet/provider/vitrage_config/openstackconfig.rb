Puppet::Type.type(:vitrage_config).provide(
  :openstackconfig,
  :parent => Puppet::Type.type(:openstack_config).provider(:ruby)
) do

  def self.file_path
    '/etc/vitrage/vitrage.conf'
  end

end
