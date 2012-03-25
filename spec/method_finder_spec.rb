describe MethodFinder do
  describe "blacklist" do
    it "should contain classic methods" do
      MethodFinder.class_variable_get(:@@blacklist).should include(:what?)
      MethodFinder.class_variable_get(:@@blacklist).should include(:works?)
    end

    it "should contain newer methods" do
      MethodFinder.class_variable_get(:@@blacklist).should include(:what_equals)
      MethodFinder.class_variable_get(:@@blacklist).should include(:what_works)
    end
  end
end
