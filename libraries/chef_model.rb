
class ReadOnlyAttribute < Exception
end

begin
  require 'tire'
  require 'tire/model/dynamic_persistence'
  TIREFOUND = true
rescue LoadError => e
  TIREFOUND = false
end

class Node
  include Tire::Model::Persistence
  include Tire::Model::DynamicPersistence
  index_name "chef"

  validates_presence_of :id, :fqdn, :env, :region

  property :id
  property :fqdn
  property :name
  property :hostname
  property :env
  property :region
  property :roles, :default => [], :type => 'array'
  property :recipes, :default => [], :type => 'array'
  property :run_list, :default => [], :type => 'array'
  property :network, :default => Mash.new, :type => 'object'
  property :started, :default => Time.now, :type => 'date'

  mapping :analyzer => "keyword"
  #mapping :analyzer => "not_analyzed" wait, not_analyzed goes to index

  #alias :id :fqdn
  #alias :fqdn :id
  #alias :_fqdn= :fqdn= unless instance_methods.include? :_fqdn=

  #def fqdn=(*arg)
    #raise ReadOnlyAttribute unless @fqdn.nil?
    #_fqdn=(*arg)
  #end

end if TIREFOUND



# ex: short_search(:region => 'ord1', :deployment => 'prod', :roles => "base", :roles => "seed")
def short_search(args={})
  return unless TIREFOUND
  Node.search do
    query do
      boolean do
        args.each do |key,val|
          must { term key, val }
        end
      end
    end
  end
end

