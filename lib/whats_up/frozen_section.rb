module WhatsUp
  class FrozenSection
    def initialize(object, vars = {})
      @object = object
      vars.each do |key, value|
        instance_variable_set "@#{key}", value
      end
    end

    private

    def show_methods(expected_result, opts = {}, *args, &block)
      @args = args unless args.empty?
      MethodFinder.show(@object, expected_result, opts, *@args)
    end
  end
end
