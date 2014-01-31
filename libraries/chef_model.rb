
begin
  require 'tire'
  require 'tire/model/dynamic_persistence'
  TIREFOUND = true
rescue LoadError => e
  Chef::Log.warn("Error loading tire", e)
  TIREFOUND = false
end


class Node
  include Tire::Model::Persistence
  include Tire::Model::DynamicPersistence
  index_name "chef"

  validates_presence_of :id, :fqdn, :env, :region

  property :id, :type => 'string'
  property :fqdn, :type => 'string'
  property :name, :type => 'string'
  property :hostname, :type => 'string'
  property :env, :type => 'string'
  property :region, :type => 'string'
  property :roles, :default => [], :type => 'string', :index_name => 'role'
  property :recipes, :default => [], :type => 'string', :index_name => 'recipe'
  property :run_list, :default => [], :type => 'string', :index_name => 'run_item'
  property :network, :default => Mash.new, :type => 'object'
  property :started, :default => Time.now, :type => 'date'

  settings :analysis => {
    :analyzer => {
      :default => {
        :type => "keyword"
      }
    }
  } do

    Array(Chef::Config[:elasticsearch]).each do |key,val|
      Tire::Configuration.send(key.to_sym, *val) if Tire::Configuration.respond_to? key.to_sym
    end

    create_elasticsearch_index
  end

end if TIREFOUND

