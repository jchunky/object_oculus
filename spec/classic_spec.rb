RSpec.describe "WhatsUp::Classic" do
  it "should not have any classic methods without Classic loaded" do
    expect("hello").not_to respond_to(:what?)
  end

  it "should have classic methods with Classic loaded" do
    require "whats_up/classic"
    expect("hello").to respond_to(:what?)
  end
end
