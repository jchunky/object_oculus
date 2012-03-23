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

module WhatsUp
  autoload :Classic,       "whats_up/classic"
  autoload :DummyOut,      "whats_up/dummy_out"
  autoload :FrozenSection, "whats_up/frozen_section"
  autoload :MethodFinder,  "whats_up/method_finder"
  autoload :Methods,       "whats_up/methods"
end

class Object
  include WhatsUp::Methods
end
