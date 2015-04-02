RSpec.shared_examples "a link" do |link, serializer| 
  describe "#schema_property" do
    it 'should have some specs' 
  end

  describe "serialize" do
    subject { link.serialize(serializer) }

    it { is_expected.to include(link.key) }
  end
end
