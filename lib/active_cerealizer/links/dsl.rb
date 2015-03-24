module ActiveCerealizer
  module Links
    class DSL 
      attr_reader :opts, :klass, :relation, :adapter
      
      def initialize(relation, adapter, klass)
        @relation = relation
        @adapter = adapter
        @klass = klass
        @opts = {}
      end

      def polymorphic(bool)
        @polymorphic = bool
      end

      def polymorphic?
        !!@polymorphic
      end

      def fetch(&block)
        opts[:block] = block
      end

      def serialize_when(&block)
        opts[:if] = block
      end
      
      def serialize_when_not(&block)
        opts[:unless] = block
      end

      def key(key)
        opts[:key] = key
      end

      def required(*actions)
        opts[:required] = actions
      end

      def permitted(*actions)
        opts[:permitted] = actions
      end

      def build
        instance = @klass.new(relation, adapter, opts)
        instance.singleton_class.include(Links::Polymorphic) if polymorphic?
        instance
      end
    end
  end
end
