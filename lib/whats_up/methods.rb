module WhatsUp
  # The methods added to all objects by whats_up
  module Methods
    # Provides a list of arguments that will be used when trying to find matching methods.
    #
    #   5.given(1).what_equals 6
    #   # => 5 + 1 == 6
    def given(*args)
      if frozen?
        FrozenSection.new self, args: args
      else
        @args = args
        self
      end
    end

    # Outputs a list of methods and their values that equal an +expected_result+, allowing for some
    # coercion (e.g. <tt>5 == 5.0</tt>)
    def what_equals(expected_result, *args, &block)
      show_methods expected_result, {}, *args, &block
    end

    # Outputs a list of methods and their values that exactly equal an +expected_result+
    def whats_exactly(expected_result, *args, &block)
      show_methods expected_result, { force_exact: true }, *args, &block
    end

    # Outputs a list of methods and their values that match an +expected_result+, which is coerced
    # into a regular expression if it's not already one
    def what_matches(expected_result, *args, &block)
      show_methods expected_result, { force_regex: true }, *args, &block
    end

    # Outputs a list of all methods and their values
    def what_works_with(*args, &block)
      show_methods nil, { show_all: true }, *args, &block
    end
    alias :what_works :what_works_with

    # Outputs a list of all methods and their values, provided they are not blank (nil, false,
    # undefined, empty)
    def whats_not_blank_with(*args, &block)
      show_methods nil, { show_all: true, exclude_blank: true }, *args, &block
    end
    alias :whats_not_blank :whats_not_blank_with

    # The list of all methods unique to an object
    def unique_methods
      methods - self.class.methods
    end

    # Lists all methods available to the object by ancestor
    def methods_by_ancestor
      result = {}
      ([self] + self.class.ancestors).each do |object|
        result[object] = object.unique_methods
      end
      result
    end

    # Make sure cloning doesn't cause anything to fail via type errors
    alias_method :__clone__, :clone

    # Adds in a type error check to the default Object#clone method to prevent any interruptions while
    # checking methods. If a TypeError is encountered, +self+ is returned
    def clone
      __clone__
    rescue TypeError
      self
    end

    private

    # Called by all of the +what_+ methods, this tells MethodFinder to output the result for any methods
    # matching an +expected_result+ for the #given arguments
    def show_methods(expected_result, opts = {}, *args, &block)  # :doc:
      @args = args unless args.empty?
      MethodFinder.show(self, expected_result, opts, *@args, &block)
    end
  end
end
