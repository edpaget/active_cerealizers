require 'active_cerealizer/attribute'
require 'active_cerealizer/resource_dsl'

module ActiveCerealizer
  module Attributes
    class DSL < ActiveCerealizer::ResourceDSL
      def initialize(key, adapter, opts={})
        super key, adapter, Attribute, opts
      end
      
      def schema(&block)
        opts[:schema] = block
      end

      def type(type)
        opts[:type] = type
      end
    end
  end
end
