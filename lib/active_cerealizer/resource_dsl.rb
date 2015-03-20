require 'active_cerealizer/attribute'
require 'active_cerealizer/link'

module ActiveCerealizer
  module ResouceDSL
    attr_reader :attrs, :links

    def serialize_links
      links.map(&:template).reduce(&:merge)
    end
    
    def attribute(field, opts={}, &block)
      @attrs ||= []
      @attrs.push(Attribute.new(field, model, **opts, &block))
      mod = Module.new do
        define_method field do
          model.send(field)
        end
      end
      
      include mod
    end

    def attributes(*attrs)
      attrs.each do |(field, opts)|
        opts ||= {}
        attribute(field, **opts)
      end
    end

    def links_one(relation, opts={}, &block)
      @links ||= []
      opts[:many] = false
      @links.push(Link.new(relation, model, get_adapter(model), **opts, &block))
    end

    def links_many(relation, opts={}, &block)
      @links ||= []
      opts[:many] = true
      @links.push(Link.new(relation, model, get_adapter(model), **opts, &block))
    end

    def url_for(model_or_class, id=nil)
      "/#{@url.first.pluralize}/#{id || model_or_class.id}"
    end

    def url(*url)
      @url = url.map(&:to_s)
    end

    def key(key)
      @key = key
    end
  end
end
