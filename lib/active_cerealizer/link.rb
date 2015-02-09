require 'active_cerealizer/serialized'

module ActiveCerealizer
  class Link
    include Serialized

    attr_reader :key, :relation, :model_class
    
    DEFAULTS = {
      unless: nil,
      if: nil,
      include: true,
      required: false,
      permitted: true,
      polymorphic: false,
      many: true
    }

    def initialize(relation, model_class, model_adapter, opts={}, &block)
      @relation = relation
      @model_class = model_class
      @model_adapter = model_adapter
      @key = opts.delete(:key) || relation
      @association = model_class.reflect_on_association(relation)
      @unless, @if, @include, @required, @permitted, @many, @polymoprhic =
                                                     DEFAULTS.merge(opts)
                                                             .values_at(:unless,
                                                                        :if,
                                                                        :include,
                                                                        :required,
                                                                        :permitted,
                                                                        :many,
                                                                        :polymorphic)
      @block = block
    end

    def as_schema_property(schema_links, action)
      super do
        if @many
          schema_links.add(:array, key, required: required?(action)) { items type: [:integer, :string] }
        else
          schema_links.add(:string, key, required: required?(action))
        end
      end
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
      else
        links = @model_adapter.fetch(serializer.model, @association, @polymorphic)
        @many ? links.map{ |link| link_response(link) } : link_response(link)
      end
    end

    def link_response((id, klass))
      return id unless klass
      polymorphic_response(id, klass)
    end

    def polymorphic_response(id, klass)
      {
        id: id,
        type: to_type_name(klass),
        href: linked_serializer(klass).url_for(id)
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
