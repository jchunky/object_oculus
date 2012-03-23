# Some credits:
# Code this version is based on: Andrew Birkett
#   http://www.nobugs.org/developer/ruby/method_finder.html
# Improvements from Why's blog entry
# * what? == - Why
# * @@blacklist - llasram
# * clone alias - Daniel Schierbeck
# * $stdout redirect - Why
#   http://redhanded.hobix.com/inspect/stickItInYourIrbrcMethodfinder.html
# Improvements from Nikolas Coukouma
# * Varargs and block support
# * Improved catching
# * Redirecting $stdout and $stderr (independently of Why)
#   http://atrustheotaku.livejournal.com/339449.html
#
# A version posted in 2002 by Steven Grady:
#   http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-talk/32844
# David Tran's versions:
# * Simple
#   http://www.doublegifts.com/pub/ruby/methodfinder.rb.html
# * Checks permutations of arguments
#   http://www.doublegifts.com/pub/ruby/methodfinder2.rb.html
#
# Last updated: 2006/05/20

class Object
  def what_equals(*a)
    WhatsUp::MethodFinder.show(self, {}, *a)
  end

  def whats_exactly(*a)
    WhatsUp::MethodFinder.show(self, { force_exact: true }, *a)
  end
  
  def what_matches(*a)
    WhatsUp::MethodFinder.show(self, { force_regex: true }, *a)
  end

  def what_works_with(*a)
    WhatsUp::MethodFinder.show(self, { show_all: true }, *a)
  end

  def whats_not_blank_with(*a)
    WhatsUp::MethodFinder.show(self, { show_all: true, exclude_blank: true }, *a)
  end

  # Make sure cloning doesn't cause anything to fail via type errors
  alias_method :__clone__, :clone
  def clone
    __clone__
  rescue TypeError
    self
  end
end

# A class to suppress anything that would normally output to $stdout
class DummyOut
  # Does nothing (instead of writing to $stdout)
  def write(*args); end
end

module WhatsUp
  class MethodFinder
    @@blacklist = %w(daemonize display exec exit! fork sleep system syscall what_equals
                     whats_exactly what_matches whats_up ed emacs mate nano vi vim)
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
          -> a, b { a === b.to_s }
        elsif expected_result.is_a?(Regexp) && !opts[:force_exact]
          -> a, b { a === b.to_s }
        elsif opts[:force_exact]
          -> a, b { a.eql?(b) }
        elsif opts[:show_all]
          if opts[:exclude_blank]
            -> a, b { !b.nil? && !b.empty? }
          else
            -> a, b { true }
          end
        else
          -> a, b { a == b }
        end
      end

      # Find all methods on [an_object] which, when called with [args] return [expected_result]
      def find(an_object, expected_result, opts = {}, *args, &block)
        check_result    = build_check_lambda(expected_result, opts)

        if opts[:force_regex] && expected_result.is_a?(String)
          expected_result = Regexp.new(expected_result)
        end

        # Prevent any writing to the terminal
        stdout, stderr = $stdout, $stderr
        $stdout = $stderr = DummyOut.new

        methods = an_object.methods

        # Use only methods with valid arity that aren't blacklisted
        methods.select! { |n| an_object.method(n).arity <= args.size && !@@blacklist.include?(n) }

        # Collect all methods equaling the expected result
        results = methods.inject({}) do |res, name|
          begin
            stdout.print ""
            value = an_object.clone.method(name).call(*args, &block)
            res[name] = value if check_result.call(expected_result, value)
          rescue
          end
          res
        end

        # Restore printing to the terminal
        $stdout, $stderr = stdout, stderr
        results
      end
      
      # Pretty-prints the results of the previous method
      def show(an_object, opts = {}, *args, &block)
        opts = {
          force_regex:   false,
          force_exact:   false,
          show_all:      false,
          exclude_blank: false
        }.merge(opts)

        expected_result = opts[:show_all] ? nil : args.shift
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
          left_cutoff  = (max_length - 5) * 2 / 3.0
          right_cutoff = max_length - 6 - left_cutoff
          "#{full[0..left_cutoff]} ... #{full[-right_cutoff..-1]}"
        else
          full
        end
      end
    end
  end
end
