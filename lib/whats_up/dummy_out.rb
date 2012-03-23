module WhatsUp
  # A class to suppress anything that would normally output to $stdout
  class DummyOut
    # Does nothing (instead of writing to $stdout)
    def write(*args)
    end
  end
end
