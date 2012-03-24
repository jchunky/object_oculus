require File.dirname(__FILE__) + "/spec_helper"

describe Methods do
  before :all do
    @stderr,  @stdout = $stderr, $stdout
    $stderr = $stdout = DummyOut.new
  end

  after :all do
    $stderr,  $stdout = @stderr, @stdout
  end

  it "should work" do
    "hello".given(1).what_equals("e").should have_key(:[])
  end
end
