require 'active_cerealizer/links/one'
require 'active_cerealizer/links/many'

module ActiveCerealizer
  class Resource
    extend Forwardable
    
    class << self
      attr_reader :links
      
      def serialize(params, models, context={})
        data = models.map do |model|
          new(model, context).serialize
        end

        {
          links: {},
          data: data,
          meta: {}
        }
      end

      def links_one(relation, opts={}) 
        add_link(ActiveCerealizer::Links::One, relation, opts) 
      end

      def links_many(relation, opts={}) 
        add_link(ActiveCerealizer::Links::Many, relation, opts) 
      end

      private
      
      def add_link(klass, relation, opts) 
        @links ||= []
        link = klass.new(relation, **opts)
        include(link.modularize)
        @links.push link
      end
    end

    attr_accessor :model, :context

    def initialize(model, context)
      @model, @context = model, context
    end

    def_delegator self, :links

    def serialize
      {
        links: links.map{ |l| l.serialize(self) }
      }
    end
  end
end
