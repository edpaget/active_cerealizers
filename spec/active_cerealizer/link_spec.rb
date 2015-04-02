require 'spec_helper'
require 'active_cerealizer/link'

RSpec.describe ActiveCerealizer::Link do
  let(:mock_cereal) do
    double self_link: "/meals/1/links/cereals", related_link: "/meals/1/cereals", cereals: [1,2]
  end

  let(:link) { described_class.new(:cereals) }
  
  describe "#initialize" do
    context "when no type specified" do
      it 'should set the key as type' do
        expect(link.type).to eq('cereals')
      end

      it 'should pluralize the key as type' do
        link = described_class.new(:cereal)
        expect(link.type).to eq('cereals')
      end
    end
  end

  describe "#modularize" do
    let(:mod) { link.modularize }
    
    it 'should create a module with a single method named after the key' do
      expect(mod.instance_methods).to include(:cereals)
    end

    it 'should have a method that sends the key to a @model variable' do
      m = mod
      model_double = double cereals: [1,2]
      
      fake_class = Class.new do
        include m

        def initialize(model)
          @model = model
        end
      end

      fake_instance = fake_class.new(model_double)
      
      expect(fake_instance.cereals).to eq([1,2])
    end
  end

  describe "#serialize" do
    context "when include_linkage is true" do
      it 'should return a hash of the links and linkage' do
        allow(link).to receive(:linkage)
                        .and_return([{ id: "1", type: "cereals" },
                                     { id: "2", type: "cereals" }])
        
        expect(link.serialize(mock_cereal)).to eq({self: '/meals/1/links/cereals',
                                                   related: '/meals/1/cereals',
                                                   linkage: [{ id: "1", type: "cereals" },
                                                             { id: "2", type: "cereals" }]})
      end
    end

    context "when include_linkage is false" do
      it 'should only return the links' do
        link = described_class.new(:cereals, include_linkage: false)
        expect(link.serialize(mock_cereal)).to eq({self: '/meals/1/links/cereals',
                                                   related: '/meals/1/cereals'})
      end
    end

    context "when linkage is overridden" do
      it 'should only return the links' do
        expect(link.serialize(mock_cereal, false)).to eq({self: '/meals/1/links/cereals',
                                                   related: '/meals/1/cereals'})
      end
    end
  end

  describe "#links" do
    it 'should call self_link on the serializer' do
      expect(mock_cereal).to receive(:self_link)
      link.links(mock_cereal)
    end
    
    it 'should call related_link on the serializer' do
      expect(mock_cereal).to receive(:related_link)
      link.links(mock_cereal)
    end
    
    it 'should return the links as a hash' do
      expect(link.links(mock_cereal)).to include(self: '/meals/1/links/cereals',
                                                 related: '/meals/1/cereals')
    end
  end

  describe "#linkage" do
    it 'should raise NotImplementedError' do
      expect{ link.linkage }.to raise_error(NotImplementedError)
    end
  end
end

