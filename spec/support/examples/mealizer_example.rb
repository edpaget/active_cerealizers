require 'active_cerealizer/resource'

module Examples
  class MealSerailizer < ActiveCerealizer::Resource
    attributes :name

    links_one :food
    links_one :beverage
  end
end
