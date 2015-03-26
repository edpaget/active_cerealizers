require 'active_cerealizer/resource'

module Examples
  class CerealSerializer < ActiveCerealizer::Resource
    attributes :brand, :slogan

    attribute :secret_formula do
      type :object
      serialize_when :permitted?
      fetch do
        {
          "High Fructose Corn Syrup" => "1 Part",
          "Human Hair" => "2 Pars",
          "Gluten" => "3 Parts"
        }
      end
    end

    links_many :meals

    location :cereals

    def slogan
      return @model.slogan unless context[:mighty_thor]
      "MJOLNIR IS FOR BREAKFAST"
    end

    def permitted?
      !!context[:mighty_thor]
    end
  end
end
