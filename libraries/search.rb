
require ::File.join(::File.dirname(__FILE__), 'chef_model') unless defined? TIREFOUND

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

