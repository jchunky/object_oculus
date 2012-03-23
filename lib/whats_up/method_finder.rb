module WhatsUp
  class MethodFinder
    @@blacklist = %w(daemonize display exec exit! fork sleep system syscall what_equals
                     whats_exactly what_matches what_works_with what_works whats_not_blank_with
                     whats_not_blank given ed emacs mate nano vi vim)
    @@infixes   = %w(+ - * / % ** == != =~ !~ !=~ > < >= <= <=> === & | ^ << >>).map(&:to_sym)
    @@prefixes  = %w(+@ -@ ~ !).map(&:to_sym)
    
    def initialize(obj, *args)
      @obj = obj
      @args = args
    end
    def ==(val)
      MethodFinder.show(@obj, val, *@args)
    end
    
    class << self
      def build_check_lambda(expected_result, opts = {})
        if opts[:force_regex]
          expected_result = Regexp.new(expected_result.to_s) unless expected_result.is_a?(Regexp)
          -> value { expected_result === value.to_s }
        elsif expected_result.is_a?(Regexp) && !opts[:force_exact]
          -> value { expected_result === value.to_s }
        elsif opts[:force_exact]
          -> value { expected_result.eql?(value) }
        elsif opts[:show_all]
          if opts[:exclude_blank]
            -> value { !value.nil? && !value.empty? }
          else
            -> value { true }
          end
        else
          -> value { expected_result == value }
        end
      end

      # Find all methods on [an_object] which, when called with [args] return [expected_result]
      def find(an_object, expected_result, opts = {}, *args, &block)
        check_result    = build_check_lambda(expected_result, opts)

        # Prevent any writing to the terminal
        stdout, stderr = $stdout, $stderr
        $stdout = $stderr = DummyOut.new

        # Use only methods with valid arity that aren't blacklisted
        methods = an_object.methods
        methods.select! { |n| an_object.method(n).arity <= args.size && !@@blacklist.include?(n) }

        # Collect all methods equaling the expected result
        results = methods.inject({}) do |res, name|
          begin
            stdout.print ""
            value = an_object.clone.method(name).call(*args, &block)
            res[name] = value if check_result.call(value)
          rescue
          end
          res
        end

        # Restore printing to the terminal
        $stdout, $stderr = stdout, stderr
        results
      end
      
      # Pretty-prints the results of the previous method
      def show(an_object, expected_result, opts = {}, *args, &block)
        opts = {
          force_regex:   false,
          force_exact:   false,
          show_all:      false,
          exclude_blank: false
        }.merge(opts)

        found = find(an_object, expected_result, opts, *args, &block)
        prettified = prettify_found(an_object, found, *args)
        max_length = prettified.map { |k, v| k.length }.max

        prettified.each do |key, value|
          puts "#{key.ljust max_length} == #{value}"
        end

        found
      end

      private

      # Pretty prints a method depending on whether it's an operator, has arguments, is array/hash
      # syntax, etc. For example:
      #
      #   
      def prettify_found(an_object, found, *args)
        args = args.map { |o| o.inspect }.join(", ")
        pretty_object = truncate_inspect(an_object, to: 40)

        found.map do |key, value|
          pretty_key = if @@infixes.include?(key)
                         "#{pretty_object} #{key} #{args}"
                       elsif @@prefixes.include?(key)
                         "#{key.to_s.sub /\@$/, ""}#{pretty_object}"
                       elsif key == :[]
                         "#{pretty_object}[#{args}]"
                       elsif args != ""
                         "#{pretty_object}.#{key}(#{args})"
                       else
                         "#{pretty_object}.#{key}"
                       end

          pretty_value = truncate_inspect(value, to: 120)

          [pretty_key, pretty_value]
        end
      end

      # Inspects an object and returns a string representation, truncating it to length in the
      # provided <tt>to:</tt> argument if necessary
      def truncate_inspect(object, opts = {})
        max_length = opts[:to] || 80
        full       = object.inspect

        if full.length > max_length
          available_length = max_length - 5  # to account for the " ... "
          left_cutoff      = available_length * 2 / 3.0
          right_cutoff     = available_length - left_cutoff - 1

          "#{full[0..left_cutoff]} ... #{full[-right_cutoff..-1]}"
        else
          full
        end
      end
    end
  end
end
