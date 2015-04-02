require 'spec_helper'
require 'active_cerealizer/resource'

RSpec.describe ActiveCerealizer::Resource do
  describe "::links_one" do
    before(:each) do
      described_class.links_one(:cereal)
    end
    
    it 'should add a new Links::One' do
      expect(described_class.links.pop).to be_a(ActiveCerealizer::Links::One)
    end

    it "should mixin the link's module" do
      expect(described_class.instance_methods).to include(:cereal)
    end
  end

  describe "::links_many" do
    before(:each) do
      described_class.links_many(:cereals)
    end
    
    it 'should add a new Links::Many' do
      expect(described_class.links.pop).to be_a(ActiveCerealizer::Links::Many)
    end
    
    it "should mixin the link's module" do
      expect(described_class.instance_methods).to include(:cereals)
    end
  end

  describe "::serialize" do
    let(:models) { [{}, {}] }
    let(:instance) { double(serialize: {}) }

    before(:each) do
      allow(described_class).to receive(:new).and_return(instance)
    end

    it 'should call serialize on each new serialize instance' do
      expect(instance).to receive(:serialize).twice
      described_class.serialize({}, models)
    end
    
    it 'should instantiate a serialize for each model' do
      models.each do |model|
        expect(described_class).to receive(:new).with(model, {})
      end
      described_class.serialize({}, models)
    end

    it 'should output a hash with a data key' do
      expect(described_class.serialize({}, models)).to include(:data)
    end
    
    it 'should output a hash with a links key' do
      expect(described_class.serialize({}, models)).to include(:links)
    end
    
    it 'should output a hash with a meta key' do
      expect(described_class.serialize({}, models)).to include(:meta)
    end
  end
  
end
