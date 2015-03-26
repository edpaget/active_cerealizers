module ActiveCerealizer
  class ResourceDSL
    attr_reader :opts, :klass, :relation, :adapter
    
    def initialize(relation, adapter, klass, opts={})
      @relation = relation
      @adapter = adapter
      @klass = klass
      @opts = opts
    end

    def run(&block)
      instance_exec(self, &block) if block_given?
      self
    end

    def fetch(&block)
      opts[:block] = block
    end

    def serialize_when(symbol=nil, &block)
      opts[:if] = symbol || block
    end
    
    def serialize_when_not(symbol=nil, &block)
      opts[:unless] = symbol || block
    end

    def key(key)
      opts[:key] = key
    end

    def required(*actions)
      opts[:required] = actions
    end

    def permitted(*actions)
      opts[:permitted] = actions
    end
    
    def build
      klass.new(relation, adapter, opts)
    end
  end
end
