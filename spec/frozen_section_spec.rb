RSpec.describe FrozenSection do
  describe "initialization" do
    before(:each) do
      @number = 2
      @string = "hello"
    end

    it "should not occur given an unfrozen object" do
      expect(@string.given(1)).to be_a(String)
    end

    it "should occur given an integer" do
      expect(@number.given(1)).to be_a(FrozenSection)
    end

    it "should occur given a frozen object" do
      @number.freeze
      @string.freeze
      expect(@number.given(1)).to be_a(FrozenSection)
      expect(@string.given(1)).to be_a(FrozenSection)
    end
  end
end
