require 'spec_helper'
require 'active_cerealizer/links/one'

RSpec.describe ActiveCerealizer::Links::One do

  describe "#linkage" do
    let(:link) { described_class.new(:cereal) }
    context "when only an id is passed" do
      it 'should return a has of id and link type' do
        arg = 1
        expect(link.linkage(*arg)).to eq({ id: "1",
                                           type: "cereals" })
      end
    end

    context "when an id and linked_type are passed" do
      it 'should return a has of id and linked_type' do
        arg = [1, "cheerios"]
        expect(link.linkage(*arg)).to eq({ id: "1",
                                           type: "cheerios" })
      end
    end
  end
end
