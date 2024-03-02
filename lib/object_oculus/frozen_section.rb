module ObjectOculus
  # A classic designed to allow variables to be stored along with a frozen object.
  #
  # Frozen objects can't have new instance variables added directly, so this prevents object_oculus
  # methods from being locked out of inspecting anything frozen. This proxy class should be
  # initialized automatically if object_oculus detects that the object it's to inspect is frozen.
  class FrozenSection
    # The frozen object
    attr_reader :object

    # Creates a new FrozenSection object from the provided +object+ and a list of instance variables
    # to store
    def initialize(object, vars = {})
      @object = object
      vars.each do |key, value|
        instance_variable_set "@#{key}", value
      end
    end

    private

    # An override of Methods#show_methods that passes the object stored in <tt>@object</tt> instead of
    # +self+
    def show_methods(expected_result, opts = {}, *args, &block)  # :doc:
      @args = args unless args.empty?
      MethodFinder.show(@object, expected_result, opts, *@args)
    end
  end
end
