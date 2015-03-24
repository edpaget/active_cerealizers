require 'active_cerealizer/link'

module ActiveCerealizer
  module Links
    module Polymorphic
      def polymorphic?
        true
      end
      
      def link_response((id, type, href))
        type = type.is_a?(Class) ? to_type_name(type) : type
        href ||= linked_serializer(type).url_for(id)
        {
          id: id,
          type: type,
          href: href
        }
      end
      
      def to_type_name(type)
        if serializer = linked_serializer(type)
          serializer.key
        else
          type.to_s
            .demodulize
            .underscore
            .pluralize
        end
      end
    end
  end
end
