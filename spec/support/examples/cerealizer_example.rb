module Examples
  class CerealSerializer < ActiveCerealizer::Resource
    attributes :id, :type, :href, :name

    attribute :secret_formula, type: :object, unless: :permitted?, do
      {
        "High Fructose Corn Syrup" => "1 Part",
        "Human Hair" => "2 Pars",
        "Gluten" => "3 Parts"
      }
    end

    url :breakfast, :cereals

    links_one :bowl, permitted_for: [:create, :update], required: true
    links_many :milks, polymorphic: true, permitted_for: [:create], required: false

    def name
      super unless context[:mighty_thor]
      "MJOLNIR IS FOR BREAKFAST"
    end

    def permitted?
      !!context[:mighty_thor]
    end
  end
end
