describe "WhatsUp::Classic" do
  it "should not have any classic methods without Classic loaded" do
    "hello".should_not respond_to(:what?)
  end

  it "should have classic methods with Classic loaded" do
    require "whats_up/classic"
    "hello".should respond_to(:what?)
  end
end
