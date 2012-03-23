require File.dirname(__FILE__) + "/spec_helper"

describe Methods do
  before :all do
    @stderr,  @stdout = $stderr, $stdout
    $stderr = $stdout = DummyOut.new
  end

  after :all do
    $stderr,  $stdout = @stderr, @stdout
  end
end
