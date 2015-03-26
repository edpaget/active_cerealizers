require 'active_cerealizer/serialized'

module ActiveCerealizer
  class Link
    include Serialized

    attr_reader :key, :relation
    
    def initialize(relation, adapter, opts={})
      @relation = relation
      @adapter = adapter
      @block = opts[:block]
      @permitted = opts[:permitted]
      @required = opts[:required]
      @key = opts[:key] || relation
      @if = opts[:if]
      @unless = opts[:unless]
    end

    def as_schema_property(schema_links, action)
      raise NotImplementedError
    end
    
    def serialize(serializer)
      serializer.serialized[:links] ||= {}
      serializer.serialized[:links][key] = fetch(serializer) if conditional?(serializer)
    end

    def polymorphic?
      false
    end
      
    private

    def can_include?
      !!@include
    end

    def fetch(serializer)
      if @block
        @block.call(serializer.model, serializer.context)
      elsif serializer.respond_to?(relation)
        serializer.send(relation)
      else
        @adapter.fetch(serializer.model, self) 
      end
    end

    def link_response(id)
      id.to_s
    end
   
    def linked_serializer(klass)
      ActiveCerealizer.resource_for_model(klass)
    end
  end
end
