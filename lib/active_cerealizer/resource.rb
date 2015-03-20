require 'active_cerealizer/attribute'
require 'active_cerealizer/link'
require 'active_cerealizer/adapters/active_record'

module ActiveCerealizer
  class Resource
    extend ResourceDSL
    
    attr_accessor :serialized
    attr_reader :model, :context

    self << class
      def serialize(models, ctx={})
        page, per_page = ctx.delete(:page, :per_page)
        include = ctx.delete(:include)
        {
          @key => models.map{ |model| Resource.new(model, ctx) }.map(&:serialize),
          meta: {},
          links: serialize_links
        }
      end
      
      def model
        self.to_s.demodulize.gsub('Serializer', '').constantize
      end

      def get_adapter(klass)
        if klass <= ActiveRecord::Base
          Adapters::ActiveRecord
        end
      end
    end
    
    def initialize(model, ctx={})
      @serialized = {}
      @model, @context = model, ctx
    end

    def attrs
      self.class.attrs
    end

    def links
      self.class.links
    end

    def serialize
      @serialized = serialized.merge({id: model.id.to_s,
                                      href: self.class.url_for(model, model.id),
                                      type: self.class.model.model_name.plural})
      
      attrs.each do |attr|
        attr.serialize(self)
      end

      links.each do |link|
        link.serialize(self)
      end

      serialized[:links].keep_if { |k, v| !v.empty? }
      serialized.delete(:links) if serialized[:links].blank?
      
      serialized
    end
  end
end
