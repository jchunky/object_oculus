module ObjectOculus
  # A class to suppress anything that would normally output to $stdout
  class DummyOut
    # Does nothing (instead of writing to an IO stream)
    def write(*args)
    end
    alias :print :write
    alias :puts  :write
  end
end
