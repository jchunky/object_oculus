module WhatsUp
  module Methods
    def given(*args)
      if frozen?
        FrozenSection.new self, args: args
      else
        @args = args
        self
      end
    end

    def what_equals(expected_result, *args, &block)
      show_methods expected_result, {}, *args, &block
    end

    def whats_exactly(expected_result, *args, &block)
      show_methods expected_result, { force_exact: true }, *args, &block
    end

    def what_matches(expected_result, *args, &block)
      show_methods expected_result, { force_regex: true }, *args, &block
    end

    def what_works_with(*args, &block)
      show_methods nil, { show_all: true }, *args, &block
    end
    alias :what_works :what_works_with

    def whats_not_blank_with(*args, &block)
      show_methods nil, { show_all: true, exclude_blank: true }, *args, &block
    end
    alias :whats_not_blank :whats_not_blank_with

    # Make sure cloning doesn't cause anything to fail via type errors
    alias_method :__clone__, :clone
    def clone
      __clone__
    rescue TypeError
      self
    end

    private

    def show_methods(expected_result, opts = {}, *args, &block)
      @args = args unless args.empty?
      MethodFinder.show(self, expected_result, opts, *@args, &block)
    end
  end
end
