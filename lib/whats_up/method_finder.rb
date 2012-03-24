module WhatsUp
  class MethodFinder
    @@blacklist = %w(daemonize debug debugger display ed emacs exactly? exec exit! fork given
                     matches? mate nano not_blank? sleep stub stub! stub_chain syscall system unstub
                     unstub! vi vim what? what_equals what_matches what_works what_works_with
                     whats_exactly whats_not_blank whats_not_blank_with works?).map(&:to_sym)
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
          ->(value) { expected_result === value.to_s }
        elsif expected_result.is_a?(Regexp) && !opts[:force_exact]
          ->(value) { expected_result === value.to_s }
        elsif opts[:force_exact]
          ->(value) { expected_result.eql?(value) }
        elsif opts[:show_all]
          if opts[:exclude_blank]
            ->(value) { !value.nil? && !value.empty? }
          else
            ->(value) { true }
          end
        else
          ->(value) { expected_result == value }
        end
      end

      # Find all methods on [an_object] which, when called with [args] return [expected_result]
      def find(an_object, expected_result, opts = {}, *args, &block)
        check_result    = build_check_lambda(expected_result, opts)

        # Prevent any writing to the terminal
        stdout, stderr = $stdout, $stderr
        unless $stdout.is_a?(DummyOut)
          $stdout = $stderr = DummyOut.new
          restore_std = true
        end

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
        $stdout, $stderr = stdout, stderr if restore_std
        results
      end
      
      # Pretty prints the results of the previous method
      def show(an_object, expected_result, opts = {}, *args, &block)
        opts = {
          exclude_blank: false,
          force_exact:   false,
          force_regex:   false,
          show_all:      false
        }.merge(opts)

        found      = find(an_object, expected_result, opts, *args, &block)
        prettified = prettify_found(an_object, found, *args)
        max_length = prettified.map { |k, v| k.length }.max

        prettified.each { |k, v| puts "#{k.ljust max_length} == #{v}" }

        found
      end

      private

      # Pretty prints a method depending on whether it's an operator, has arguments, is array/hash
      # syntax, etc.
      def prettify_found(an_object, found, *args)
        args = args.map { |a| a.inspect }.join(", ")
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
          left_cutoff      = available_length * 2 / 3
          right_cutoff     = available_length - left_cutoff - 1

          "#{full[0..left_cutoff]} ... #{full[-right_cutoff..-1]}"
        else
          full
        end
      end
    end
  end
end
