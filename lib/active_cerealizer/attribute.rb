require 'active_cerealizer/serialized'

module ActiveCerealizer
  class Attribute
    include Serialized
    
    attr_reader :field, :model_class, :type, :adapter

    alias :key :field

    def initialize(field, adapter, opts={})
      @field = field
      @adapter = adapter
      @model_class = opts[:model_class]
      @block = opts[:block]
      @schema = opts[:schema]
      @type = opts[:type] || adapter.field_type(model_class, field)
      @permitted = opts[:permitted]
      @required = opts[:required]
      @if = opts[:if]
      @unless = opts[:unless]
    end

    def as_schema_property(schema, action)
      schema_type = type.is_a?(Array) ? :array : type
      proc = if @schema
               @schema
             elsif type.is_a?(Array)
               proc { items type: type.first }
             end
      schema.add(schema_type, field, required: required?(action), &proc)
    end
    
    def serialize(serializer)
      serializer.serialized[key] = fetch(serializer) if conditional?(serializer)
    end

    private
    
    def fetch(serializer)
      if @block
        @block.call(serializer.model, serializer.context)
      elsif serializer.respond_to?(field)
        serializer.send(field)
      else
        serializer.model.send(field.to_s)
      end
    end
  end
end
