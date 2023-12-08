describe MethodFinder do
  describe "blacklist" do
    it "should contain classic methods" do
      expect(MethodFinder.class_variable_get(:@@blacklist)).to include(:what?)
      expect(MethodFinder.class_variable_get(:@@blacklist)).to include(:works?)
    end

    it "should contain newer methods" do
      expect(MethodFinder.class_variable_get(:@@blacklist)).to include(:what_equals)
      expect(MethodFinder.class_variable_get(:@@blacklist)).to include(:what_works)
    end
  end
end
