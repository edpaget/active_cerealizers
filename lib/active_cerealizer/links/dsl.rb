require 'active_cerealizer/resource_dsl'

module ActiveCerealizer
  module Links
    class DSL < ActiveCerealizer::ResourceDSL
      def polymorphic(bool)
        @polymorphic = bool
      end

      def polymorphic?
        !!@polymorphic
      end

      def build
        instance = super 
        instance.singleton_class.include(Links::Polymorphic) if polymorphic?
        instance
      end
    end
  end
end
