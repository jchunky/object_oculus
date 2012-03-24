require File.dirname(__FILE__) + "/spec_helper"

describe Methods do
  before :all do
    @stderr,  @stdout = $stderr, $stdout
    $stderr = $stdout = DummyOut.new
  end

  after :all do
    $stderr,  $stdout = @stderr, @stdout
  end

  describe "what_equals" do
    it "should find the correct method without arguments" do
      "hello ".what_equals("hello").should have_key(:rstrip)
    end

    it "should find the correct method with arguments" do
      "hello".what_equals("e", 1).should have_key(:[])
    end

    it "should find the correct method with arguments using given" do
      "hello".given(1).what_equals("e").should have_key(:[])
    end
  end

  describe "what_matches" do
    it "should find the correct method given a regular expression" do
      5.what_matches(/5/).should have_key(:to_s)
    end

    it "should find the correct method by converting an arbitrary object to a regular expression" do
      5.what_matches(5).should have_key(:to_s)
    end
  end

  describe "whats_exactly" do
    it "should fail to match inexact matches that would succeed with == type coercion" do
      5.whats_exactly(5.0).should_not have_key(:to_i)
    end

    it "should succeed for exact matches" do
      5.whats_exactly(5.0).should have_key(:to_f)
    end
  end

  describe "whats_not_blank" do
    it "should include only non-blank values" do
      5.whats_not_blank.select { |n| !n || n.empty? }.should be_empty
    end
  end

  describe "what_works" do
    it "should produce all results found with whats_not_blank" do
      works = 5.what_works

      5.whats_not_blank.keys.each do |key|
        works.should have_key(key)
      end
    end
  end
end
