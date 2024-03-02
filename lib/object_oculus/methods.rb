module ObjectOculus
  # The methods added to all objects by object_oculus
  module Methods
    # Provides a list of arguments that will be used when trying to find matching methods.
    #
    #   5.given(1).what_equals 6
    #   # => 5 + 1 == 6
    def given(*args)
      if frozen?
        FrozenSection.new(self, args:)
      else
        @args = args
        self
      end
    end

    # Outputs a list of methods and their values that equal an +expected_result+, allowing for some
    # coercion (e.g. <tt>5 == 5.0</tt>)
    def what_equals(expected_result, ...)
      show_methods(expected_result, {}, ...)
    end

    # Outputs a list of methods and their values that exactly equal an +expected_result+
    def whats_exactly(expected_result, ...)
      show_methods(expected_result, { force_exact: true }, ...)
    end

    # Outputs a list of methods and their values that match an +expected_result+, which is coerced
    # into a regular expression if it's not already one
    def what_matches(expected_result, ...)
      show_methods(expected_result, { force_regex: true }, ...)
    end

    # Outputs a list of all methods and their values
    def what_works_with(...)
      show_methods(nil, { show_all: true }, ...)
    end
    alias what_works what_works_with

    # Outputs a list of all methods and their values, provided they are not blank (nil, false,
    # undefined, empty)
    def whats_not_blank_with(...)
      show_methods(nil, { show_all: true, exclude_blank: true }, ...)
    end
    alias whats_not_blank whats_not_blank_with

    # The list of all methods unique to an object
    def unique_methods
      methods - self.class.methods
    end

    # Lists all methods available to the object by ancestor
    def methods_by_ancestor
      ([self] + self.class.ancestors).each_with_object({}) do |object, result|
        result[object] = object.unique_methods
      end
    end

    # Make sure cloning doesn't cause anything to fail via type errors
    alias __clone__ clone

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
    # :doc:
    def show_methods(expected_result, opts = {}, *args, &)
      @args = args unless args.empty?
      MethodFinder.show(self, expected_result, opts, *@args, &)
    end
  end
end
