require 'spec_helper'
require 'active_cerealizer/attribute'

RSpec.describe ActiveCerealizer::Attribute do
  let(:model_class) { Cereal }
  let(:attribute) { described_class.new(:brand, ActiveCerealizer::Adapters::ActiveRecord, model_class: model_class) }

  describe "#initialize" do
    context "type is supplied" do
      it 'should set the model type' do
        attribute = described_class.new(:brand, ActiveCerealizer::Adapters::ActiveRecord, model_class: model_class, type: :string)
        expect(attribute.type).to eq :string
      end
    end

    context 'when type is not supplied' do
      it 'should use adapter.field_type' do
        adapter = ActiveCerealizer::Adapters::ActiveRecord
        expect(adapter).to receive(:field_type).and_return(:string)
        described_class.new(:brand, adapter, model_class: model_class)
      end

      it 'should return the type' do
        attribute = described_class.new(:brand, ActiveCerealizer::Adapters::ActiveRecord, model_class: model_class)
        expect(attribute.type).to eq :string
      end
    end
  end

  describe "#serialize" do
    let(:model) { Cereal.create!(brand: "Cheerios") }
    let(:serializer) { double model: model, context: {}, serialized: {} }

    before(:each) do
      attribute.serialize(serializer)
    end

    context "block given to attribute" do
      let(:attribute) do
        described_class.new(:brand, ActiveCerealizer::Adapters::ActiveRecord, model_class: model_class, block: -> (m, c) { m[:brand] + "!!"})
      end

      it 'should set the model attribute' do
        expect(serializer.serialized).to include(brand: 'Cheerios!!')
      end
    end

    context "serializer has method for attribute" do
      let(:serializer) do
        double model: model, context: {}, serialized: {}, brand: 'Trix'
      end

      it 'should set the model attribute' do
        expect(serializer.serialized).to include(brand: 'Trix')
      end
    end

    context "no method or block used" do
      it 'should set the model attribute' do
        expect(serializer.serialized).to include(brand: 'Cheerios')
      end
    end
  end
  
  describe "#as_schema_property" do
    subject { double }

    after(:each) do
      attribute.as_schema_property(subject, :create)
    end

    context "when attribute is an array" do
      let(:attribute) do
        described_class.new :brand, ActiveCerealizer::Adapters::ActiveRecord, model_class: model_class, type: [:string]
      end

      it { is_expected.to receive(:add).with(:array, :brand, required: false) }
      
      it 'should send a proc with the item type' do
        allow(subject).to receive(:add).and_yield
        expect(attribute).to receive(:items).with(type: :string)
      end
    end

    context "when a schema proc is passed" do
      let(:attribute) do
        described_class.new :brand, ActiveCerealizer::Adapters::ActiveRecord, model_class: model_class, schema: -> { pattern '^test' }
      end

      it 'should send the schema proc' do
        allow(subject).to receive(:add).and_yield
        expect(self).to receive(:pattern).with('^test')
      end
    end
    
    context "attribute is required for action" do
      let(:attribute) do
        described_class.new :brand, ActiveCerealizer::Adapters::ActiveRecord, model_class: model_class, required: :create
      end
      
      it { is_expected.to receive(:add).with(:string, :brand, required: true) }
    end

    context "attribute is not required for action" do
      let(:attribute) do
        described_class.new :brand, ActiveCerealizer::Adapters::ActiveRecord, model_class: model_class, required: :update
      end
      
      it { is_expected.to receive(:add).with(:string, :brand, required: false) }
    end

    context "attribute is required for all actions" do
      let(:attribute) do
        described_class.new :brand, ActiveCerealizer::Adapters::ActiveRecord, model_class: model_class, required: true
      end
      
      it { is_expected.to receive(:add).with(:string, :brand, required: true) }
    end
  end
end
