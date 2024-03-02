RSpec.describe Methods do
  before(:all) do
    @stderr, @stdout = $stderr, $stdout
    $stderr = $stdout = DummyOut.new
  end

  after(:all) do
    $stderr, $stdout = @stderr, @stdout
  end

  describe "what_equals" do
    it "should find the correct method without arguments" do
      expect("hello ".what_equals("hello")).to have_key(:rstrip)
    end

    it "should find the correct method with arguments" do
      expect("hello".what_equals("e", 1)).to have_key(:[])
    end

    it "should find the correct method with arguments using given" do
      expect("hello".given(1).what_equals("e")).to have_key(:[])
    end
  end

  describe "what_matches" do
    it "should find the correct method given a regular expression" do
      expect(5.what_matches(/5/)).to have_key(:to_s)
    end

    it "should find the correct method by converting an arbitrary object to a regular expression" do
      expect(5.what_matches(5)).to have_key(:to_s)
    end
  end

  describe "whats_exactly" do
    it "should fail to match inexact matches that would succeed with == type coercion" do
      expect(5.whats_exactly(5.0)).not_to have_key(:to_i)
    end

    it "should succeed for exact matches" do
      expect(5.whats_exactly(5.0)).to have_key(:to_f)
    end
  end

  describe "whats_not_blank" do
    it "should include only non-blank values" do
      expect(5.whats_not_blank.select { |n| !n || n.empty? }).to be_empty
    end
  end

  describe "what_works" do
    it "should produce all results found with whats_not_blank" do
      works = 5.what_works

      5.whats_not_blank.keys.each do |key|
        expect(works).to have_key(key)
      end
    end
  end
end