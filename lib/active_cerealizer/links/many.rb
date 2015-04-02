require 'active_cerealizer/link'

module ActiveCerealizer
  module Links
    class Many < ActiveCerealizer::Link
      def linkage(*linked)
        linked.map do |(id, linked_type)|
          {
            id: id.to_s,
            type: linked_type || type
          }
        end
      end
    end
  end
end
