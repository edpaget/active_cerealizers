require 'active_cerealizer/serialized'

module ActiveCerealizer
  class Link
    include Serialized

    attr_reader :key, :relation, :model_class, :polymorphic
    
    DEFAULTS = {
      unless: nil,
      if: nil,
      include: true,
      required: false,
      permitted: true,
    }

    def initialize(relation, model_class, model_adapter, opts={}, &block)
      @relation = relation
      @model_class = model_class
      @model_adapter = model_adapter
      @key = opts.delete(:key) || relation
      @required = required
      @permitted = permitted 
      @block = block
    end

    def as_schema_property(schema_links, action)
      raise NotImplementedError
    end
    
    def serialize(serializer)
      serializer.serialized[:links] ||= {}
      serializer.serialized[:links][key] = fetch(serializer) if conditional?(serializer)
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
        @model_adapter.fetch(serializer.model, self) 
      end
    end

    def link_response((id, type, href))
      return id unless type 
      polymorphic_response(id, type, href)
    end

    def polymorphic_response(id, type, href)
      type = type.is_a?(Class) ? to_type_name(type) : type
      href ||= linked_serializer(type).url_for(id)
      {
        id: id,
        type: type,
        href: href
      }
    end
    
    def to_type_name(type)
      type.to_s
        .demodulize
        .underscore
        .pluralize
    end
    
    def linked_serializer(klass)
      ActiveCerealizer.resource_for_model(klass)
    end
  end
end
