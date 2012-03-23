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
  def given(*args)
    if frozen?
      WhatsUp::FrozenSection.new self, args: args
    else
      @args = args
      self
    end
  end

  def what_equals(expected_result, *args)
    show_methods expected_result, {}, *args
  end

  def whats_exactly(expected_result, *args)
    show_methods expected_result, { force_exact: true }, *args
  end
  
  def what_matches(expected_result, *args)
    show_methods expected_result, { force_regex: true }, *args
  end

  def what_works_with(*args)
    show_methods nil, { show_all: true }, *args
  end
  alias :what_works :what_works_with

  def whats_not_blank_with(*args)
    show_methods nil, { show_all: true, exclude_blank: true }, *args
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

  def show_methods(expected_result, opts = {}, *args)
    @args = args unless args.empty?
    WhatsUp::MethodFinder.show(self, expected_result, opts, *@args)
  end
end

module WhatsUp
  autoload :DummyOut,      "whats_up/dummy_out"
  autoload :FrozenSection, "whats_up/frozen_section"
  autoload :MethodFinder,  "whats_up/method_finder"
end
