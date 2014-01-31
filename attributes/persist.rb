
default.elastic_chef.server = "localhost:9200"

Tire.configure do
  url elastic_chef.server
end if TIREFOUND

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

