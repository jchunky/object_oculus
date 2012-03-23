# coding: utf-8
require File.dirname(__FILE__) + "/spec_helper"

describe FrozenSection do
  describe "initialization" do
    before :each do
      @number = 2
      @string = "hello"
    end

    it "should not occur given an unfrozen object" do
      @number.given(1).should be_a(Fixnum)
      @string.given(1).should be_a(String)
    end

    it "should occur given a frozen object" do
      @number.freeze
      @string.freeze
      @number.given(1).should be_a(FrozenSection)
      @string.given(1).should be_a(FrozenSection)
    end
  end
end
