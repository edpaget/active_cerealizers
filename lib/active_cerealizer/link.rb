module ActiveCerealizer
  class Link
    attr_reader :key, :type, :include_linkage
    
    def initialize(key, type: nil, include_linkage: true)
      @key = key
      @type = type || key.to_s.pluralize
      @include_linkage = include_linkage
    end

    def modularize
      k = key
      Module.new do
        define_method k do
          @model.send(k)
        end
      end
    end

    def serialize(serializer, send_linkage=include_linkage)
      l = links(serializer)
      if send_linkage
        l.merge({ linkage: linkage(serializer.send(key)) })
      else
        l
      end
    end

    def links(serializer)
      {
        self: serializer.self_link(key),
        related: serializer.related_link(key) 
      }
    end

    def linkage
      raise NotImplementedError
    end
  end
end
