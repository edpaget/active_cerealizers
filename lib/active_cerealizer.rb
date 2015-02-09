require "active_cerealizer/version"
require "active_support/core_ext"

module ActiveCerealizer
  def self.resource_for_model(klass)
    Resource.descendents.find { |res| res.model == klass }
  end
end
