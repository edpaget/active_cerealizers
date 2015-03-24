require 'active_cerealizer/link'

module ActiveCerealizer
  module Links
    class One < Link

      def as_schema_property(schema_links, action)
        schema_links.add(:string, key, required: required?(action))
      end

      private

      def fetch(serializer)
        link_response(super)
      end
    end
  end
end
