module ActiveCerealizer
  class Attribute
    attr_reader :field, :model_class, :type

    DEFAULTS = {
      unless: nil,
      if: nil,
      array: false,
      schema: nil,
      required: false,
      permitted: [:create, :update]
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

    def serialize(serializer)
      cond = if @if
               eval_conditional(@if)
             elsif @unless
               !eval_conditional(@if)
             else
               true
             end
      serializer.serialized[field] = fetch_field(serializer) if cond
    end
    

    def as_schema_property(schema, action)
      return schema unless permitted?(action)
      schema_type = @array ? :array : type
      proc = if @schema
               @schema
             elsif @array
               proc { items type: type }
             end
      schema.add(schema_type, field, required: required?(action), &proc)
    end

    private

    def permitted?(action)
      test_action(@permitted, action)
    end

    def required?(action)
      return false if @required.nil?
      test_action(@required, action)
    end

    def test_action(var, action)
      case var
      when TrueClass, FalseClass
        var
      when Symbol
        var == action
      when NilClass
        true
      else
        var.include?(action)
      end
    end
    
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

    def fetch_field(serializer)
      if @block
        @block.call(serializer.model, serializer.context)
      elsif serializer.respond_to?(field)
        serializer.send(field)
      else
        serializer.model.send(field)
      end
    end
    
    def eval_conditional(conditional)
      case conditional
      when Proc
        !!conditional.call(serializer.model, serializer.context)
      when Symbol
        !!serializer.send(conditional)
      else
        raise ArgumentError, "conditional must be Proc or Symbol"
      end
    end
  end
end
