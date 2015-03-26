require 'active_cerealizer/attribute'
require 'active_cerealizer/attributes/dsl'
require 'active_cerealizer/links/one'
require 'active_cerealizer/links/many'
require 'active_cerealizer/links/dsl'
require 'active_cerealizer/location'
require 'active_cerealizer/adapters/active_record'

module ActiveCerealizer
  class Resource
    attr_accessor :serialized
    attr_reader :model, :context

    class << self 
      attr_reader :attrs, :links
      
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
      
      def serialize_links
        links.map(&:template).reduce(&:merge)
      end
      
      def attribute(field, opts={}, &block)
        @attrs ||= []
        opts[:model_class] ||= model
        attr = Attributes::DSL.new(field, get_adapter(model), **opts)
        attr = attr.run(&block)
        @attrs.push attr.build
      end

      def attributes(*attrs)
        attrs.each do |(field, opts)|
          opts ||= {}
          attribute(field, **opts)
        end
      end

      def links_one(relation, klass=Links::One, &block)
        @links ||= []
        link = Links::DSL.new(relation, get_adapter(model), klass)
        link = link.run(&block)
        @links.push link.build
      end

      def links_many(relation, klass=Links::Many, &block)
        @links ||= []
        link = Links::DSL.new(relation, get_adapter(model), klass)
        link = link.run(&block)
        @links.push link.build
      end

      def url_for(id=nil)
        @url.format(id) 
      end

      def location(*url)
        @url = Location.new(url)
      end

      def key(key)
        @key = key
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
                                      href: self.class.url_for(model.id),
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
