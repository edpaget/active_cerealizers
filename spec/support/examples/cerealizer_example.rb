require 'active_cerealizer/resource'

module Examples
  class CerealSerializer < ActiveCerealizer::Resource
    attributes :brand, :slogan

    attribute :secret_formula, type: :object, if: :permitted? do
      {
        "High Fructose Corn Syrup" => "1 Part",
        "Human Hair" => "2 Pars",
        "Gluten" => "3 Parts"
      }
    end

    links_many :meals

    url :cereals

    def slogan
      return super unless context[:mighty_thor]
      "MJOLNIR IS FOR BREAKFAST"
    end

    def permitted?
      !!context[:mighty_thor]
    end
  end
end
