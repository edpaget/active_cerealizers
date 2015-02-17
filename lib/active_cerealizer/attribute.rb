require 'active_cerealizer/serialized'

module ActiveCerealizer
  class Attribute
    include Serialized
    
    attr_reader :field, :model_class, :type

    alias :key :field

    DEFAULTS = {
      unless: nil,
      if: nil,
      array: false,
      schema: nil,
      required: false,
      permitted: true
    }

    def initialize(field, model_class=nil, opts={}, &block)
      @field = field
      @model_class = model_class
      @type = (opts.delete(:type) || reflect_on_columns).to_sym
      @unless, @if, @schema, @required, @permitted, @array = DEFAULTS.merge(opts)
                                                             .values_at(:unless,
                                                                        :if,
                                                                        :schema,
                                                                        :required,
                                                                        :permitted,
                                                                        :array)
      @block = block
    end

    def as_schema_property(schema, action)
      super do
        schema_type = @array ? :array : type
        proc = if @schema
                 @schema
               elsif @array
                 proc { items type: type }
               end
        schema.add(schema_type, field, required: required?(action), &proc)
      end
    end
    
    def serialize(serializer)
      serializer.serialized[key] = fetch(serializer) if conditional?(serializer)
    end

    private
   
    def reflect_on_columns
      col = model_class.columns.find{ |col| col.name == field.to_s }
      if col.try(:array)
        @array = true
        col.type
      elsif %i(json jsonb).include? col.type
        :object 
      else
        col.type
      end
    end

    def fetch(serializer)
      if @block
        @block.call(serializer.model, serializer.context)
      elsif serializer.respond_to?(field)
        serializer.send(field)
      else
        serializer.model.attributes[field.to_s]
      end
    end
  end
end
