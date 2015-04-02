require 'spec_helper'
require 'active_cerealizer/links/many'

RSpec.describe ActiveCerealizer::Links::Many do
  describe "#linkage" do
    let(:link) { described_class.new(:cereal) }
    context "when only one id is passed" do
      it 'should return a has of id and link type' do
        arg = [1]
        expect(link.linkage(*arg)).to eq([{ id: "1",
                                            type: "cereals" }])
      end
    end
    
    
    context "when only ids are passed" do
      it 'should return a has of id and link type' do
        arg = [1, 2]
        expect(link.linkage(*arg)).to eq([{ id: "1",
                                            type: "cereals" },
                                          { id: "2",
                                            type: "cereals" }])
      end
    end

    context "when ids and linked_types are passed" do
      it 'should return a has of id and linked_type' do
        arg = [[1, "cheerios"], [2, "fruity_pebbles"]]
        expect(link.linkage(*arg)).to eq([{ id: "1",
                                            type: "cheerios" },
                                          { id: "2",
                                            type: "fruity_pebbles" }])
      end
    end
  end
end
