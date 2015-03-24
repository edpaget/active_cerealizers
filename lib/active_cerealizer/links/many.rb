require 'active_cerealizer/link'

module ActiveCerealizer
  module Links
    class Many < Link

      def as_schema_property(schema_links, action)
        schema_links.add(:array, key, required: required?(action)) { items type: [:integer, :string] }
      end

      def fetch(serializer)
        super.map{ |link| link_response(link) }
      end
    end
  end
end
