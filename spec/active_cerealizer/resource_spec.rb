require 'spec_helper'
require 'active_cerealizer/resource'
require_relative '../support/examples/cerealizer_example.rb'

RSpec.describe ActiveCerealizer::Resource do
  let(:serializer) { Examples::CerealSerializer }
  let(:model) do
    Cereal.create! do |c|
      c.brand = 'Cheerios'
      c.slogan = 'Its fucking good for you'
    end
  end

  let(:base_response) do
    {
      id: model.id.to_s,
      href: "/cereals/#{model.id}",
      type: "cereals",
      brand: "Cheerios",
      slogan: "Its fucking good for you",
    }
  end
  
  describe "#serialize" do
    context "when there are no links" do
      it 'should output a hash' do
        expect(serializer.new(model).serialize).to eq(base_response)
      end
    end

    context "when are links" do
      let!(:linked) do
        [Meal.create! do |m|
           m.food = model
         end,
         Meal.create! do |m|
           m.food = model
         end]
      end

      it 'should output a hash with links' do
        base_response[:links] = {
          meals: linked.map(&:id).map(&:to_s)
        }
        expect(serializer.new(model).serialize).to eq(base_response)
      end
    end

    context  "when passed serailizer context" do
      it 'should output hash with response modified by context' do
        base_response[:slogan] = "MJOLNIR IS FOR BREAKFAST"
        base_response[:secret_formula] = {
          "High Fructose Corn Syrup" => "1 Part",
          "Human Hair" => "2 Pars",
          "Gluten" => "3 Parts"
        }
        expect(serializer.new(model, mighty_thor: true).serialize).to eq(base_response)
      end
    end
  end
end
