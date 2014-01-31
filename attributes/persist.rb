
node.persist(
  :id => fqdn,
  :fqdn => fqdn,
  :name => name,
  :hostname => hostname,
  :env => environment,
  :region => rackspace.region,
  :roles => roles,
  :recipes => recipes,
  :run_list => run_list.map(&:to_s),
  :network => rackspace.attribute?(:cloud_networks) ? rackspace.cloud_networks : cloud
)

