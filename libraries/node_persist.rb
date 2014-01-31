
require ::File.join(::File.dirname(__FILE__), 'chef_model') unless defined? TIREFOUND

class Chef::Node
  def persist(args={})
    return @persist unless @persist.nil?
    if !TIREFOUND
      Chef::Log.warn("tire lib wasn't found!")
      return @persist = args #TODO: turn this into an openstruct
    end
    raise Exception if args.empty? or !args.has_key? :id
    if Node.kind_of? Chef::Node
      Chef::Log.error("wrong kind of node!!!")
      raise Exception
    end
    Chef::Log.info("creating ES node record")
    model = Node.find args[:id]
    if model.nil? || model.new_record?
      model = Node.new(args)
      raise Exception, model.errors if !model.save
    else
      mdl = Mash.new(model.to_hash)
      modargs = args.reject{|k,v| mdl[k] == v}
      if !modargs.empty?
        raise Exception, model.errors if !model.update_attributes(modargs)
      end
    end
    @persist = model
  end
  def persist=(arg)
    persist(arg)
  end
end

