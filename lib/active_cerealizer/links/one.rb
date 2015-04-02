require 'active_cerealizer/link'

module ActiveCerealizer
  module Links
    class One < ActiveCerealizer::Link
      def linkage(id, linked_type=nil)
        {
          id: id.to_s,
          type: linked_type || type
        }
      end
    end
  end
end
